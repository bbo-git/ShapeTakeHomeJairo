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
        guard let url = URL(string: "https://shape-recruiting.s3.us-east-2.amazonaws.com/ios/3dadv") else { completion([], NetworkError.invalidURL); return;}
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
            do {
                
                guard let tmpurl = tmpurl else { return }
                
                let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
                let destinationPath = documentDirectoryPath.appendingPathComponent(tmpurl.lastPathComponent)
                
                
                let file: FileHandle = try FileHandle(forReadingFrom: tmpurl)
                                
                DispatchQueue.global().async {
                    let data = file.readDataToEndOfFile()
                    print(data.count)
                    print(FileManager().createFile(atPath: destinationPath.absoluteString, contents: data, attributes: nil))
                }
                if let index = self?.models.firstIndex(where: { (model) -> Bool in
                    model.url == response!.url!.absoluteString
                }) {
                    self?.models[index].localUrl = destinationPath
                }
                promise.fulfill(destinationPath)
                
            } catch {
                print(error.localizedDescription)
            }
        })
        task?.resume()
        
        return promise
    }

    func downloadAllModels(completion: @escaping ([URL]) -> Void) {
        
        if FileManager.default.fileExists(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.absoluteString ) {
            let deletePaths: [String] = try! FileManager.default.contentsOfDirectory(atPath: FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.absoluteString)
            
            let _ = deletePaths.map { (path) -> Void in
                try? FileManager.default.removeItem(at: URL(string: path)!)
            }
        } else {
            try? FileManager.default.createDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!, withIntermediateDirectories: true, attributes: nil)
        }
        
        let networkPromises = models.map {
            performNetworkPromise(url: $0.url)
        }
        
        all(networkPromises).then { urlArray in
            completion(urlArray)
        }
    }
}

