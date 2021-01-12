//
//  Network.swift
//  ShapeTakeHomeJairo
//
//  Created by Jairo Bambang Oetomo on 10/01/2021.
//

import UIKit
import Promises

enum NetworkError: Error {
    case invalidURL
    case invalidData
}

struct ModelData: Codable {
    var id: String
    var desc: String
    var url: String
    var localUrl: URL?
}

class DownloadManager: NSObject {
    
    static var shared = DownloadManager()
    
    var models: [ModelData] = []
    var session: URLSession?
    var request: URLRequest?
    
    func getModelsJson(completion: @escaping ([ModelData], Error?) -> Void) {
        guard let url = URL(string: "https://shape-recruiting.s3.us-east-2.amazonaws.com/ios/3d") else { completion([], NetworkError.invalidURL); return;}
        session = URLSession(configuration: URLSessionConfiguration.default)
        request = URLRequest(url: url)
        request?.httpMethod = "GET"
        let task = session?.dataTask(with: request!, completionHandler: { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], NetworkError.invalidData)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let models = try decoder.decode([ModelData].self, from: data)
                DispatchQueue.main.async {
                    self.models = models
                    completion(models, nil)
                }
                return
            } catch {
                DispatchQueue.main.async {
                    completion([], NetworkError.invalidData)
                    return
                }
            }
        })
        task?.resume()
    }
    
    var modelSession: URLSession?
    var modelRequest: URLRequest?
    
    func performNetworkPromise(url: String) -> Promise<URL>{
        let promise =  Promise<URL>.pending()
        
        guard let remoteurl = URL(string: url) else {
            return Promise.init(NetworkError.invalidURL)
        }
        modelRequest = URLRequest(url: remoteurl)
        modelSession = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        
        let task = modelSession?.downloadTask(with: modelRequest!, completionHandler: { [weak self] (tmpurl, response, error) in
            guard let tmpurl = tmpurl else { return }
            
            let cahcesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let destinationURL = cahcesURL.appendingPathComponent(remoteurl.lastPathComponent)
            // delete original copy
            // copy from temp to Document
            do {
                //try? FileManager.default.removeItem(at: destinationURL)
                try FileManager.default.copyItem(at: tmpurl, to: destinationURL)
                print(FileManager.default.fileExists(atPath: destinationURL.path))
                
            } catch let error {
                print("Copy Error: \(error.localizedDescription)")
            }
            
            if let index = self?.models.firstIndex(where: { (model) -> Bool in
                model.url == url
            }) {
                self?.models[index].localUrl = destinationURL
            }
            promise.fulfill(destinationURL)
            
        })
        task?.resume()
        
        return promise
    }
    
    func downloadAllModels(completion: @escaping ([URL]) -> Void) {
        
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        
        //remove files in documents directory
        let deletePaths: [String] = try! FileManager.default.contentsOfDirectory(atPath: cachesURL.path)
        
        let _ = deletePaths.filter({ (str) -> Bool in
            str.range(of: "co.bbo.ShapeTakeHomeJairo") == nil
        }).map { (path) -> Void in
            do {
                try FileManager.default.removeItem(at: cachesURL.appendingPathComponent(path))
            } catch {
                print(error)
            }
            
        }
        
        
        let networkPromises = models.map {
            performNetworkPromise(url: $0.url)
        }
        
        //let networkPromises = [models[0]].map { performNetworkPromise(url: $0.url) }
        
        all(networkPromises).then { urlArray in
            completion(urlArray)
        }
        
    }
}
