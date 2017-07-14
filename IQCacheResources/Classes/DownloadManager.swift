//
//  DownloadManager.swift
//  Pods
//
//  Created by Irshad on 15/07/17.
//
//

import Foundation
import UIKit

public class DownloadManager: NSObject {
    

    var session: URLSession
    let url: NSURL
    var isCaching: Bool
    

    init(url: NSURL, shouldCache: Bool) {
        
        session = URLSession(configuration: URLSessionConfiguration.default)
        
        self.url = url
        self.isCaching = shouldCache
        
        super.init()
    }
    
    convenience init(url: NSURL) {
        
        self.init(url: url, shouldCache: true)
    }
    

    
    func download(completion: @escaping (_ data: NSData?, _ error : NSError?) -> Void) {

        session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in

            if (error != nil) {
                
                completion(nil, error as NSError?)
            }
            if let _ = data {
                
                completion(data as NSData?, nil)
            }
            
            self.session.finishTasksAndInvalidate()
            
        }).resume()
        
    }
    
    func storeInCache(object: AnyObject){
        
        if self.isCaching {
            
            CacheManager.sharedCache.archiveAnyData(any: object, url: url.absoluteString!)
        }
    }
    
    
    
    

    public func getData(completion: @escaping (_ url: NSURL, _ data: NSData?, _ error : NSError?) -> Void) {
        
        self.download{ (data, error) -> Void in
            
            DispatchQueue.main.async() {
                
                if error == nil , let _ = data{
                    
                    self.storeInCache(object: data!)
                }
                
                completion(self.url, data, error)
            }
        }
    }
    
    
    
    public func getImage(completion: @escaping (_ url: NSURL, _ image: UIImage?, _ error : NSError?) -> Void) {

        if let cachedImage = CacheManager.sharedCache.unarchiveImage(url: self.url.absoluteString!) {
            
            DispatchQueue.main.async() {
                
                completion(self.url, cachedImage, nil)
            }
            return
        }
        else{
            
            download{ (data, error) -> Void in
                
                DispatchQueue.main.async() {
                    
                    if let thisData = data, let currentImage = UIImage(data: thisData as Data) {
                        
                        self.storeInCache(object: currentImage)
                        
                        completion(self.url, currentImage, nil)
                        
                    } else {
                        
                        completion(self.url, nil,  NSError(domain: "BeanError", code: -8000, userInfo: nil))
                    }
                }
            }
        }
    }
    
    //For getting the JSON objects
    public func getJSON(completion: @escaping (_ url: NSURL, _ json: [String: AnyObject]?, _ error : NSError?) -> Void) {
        
        if let cachedJson = CacheManager.sharedCache.unarchiveJSON(url: self.url.absoluteString!) {
            
            //Returns Cached JSON
            DispatchQueue.main.async() {
                
                completion(self.url, cachedJson, nil)
                return
            }
        } else{
            
            download{ (data, error) -> Void in
                do{
                    //Converts data into JSON by serialization
                    if let thisData = data, let json = try JSONSerialization.jsonObject(with: thisData as Data, options:.allowFragments) as? [String: AnyObject] {
                        
                        self.storeInCache(object: json as AnyObject)
                        
                        completion(self.url, json, nil)
                        
                    } else {
                        
                        completion(self.url, nil,  error)
                    }
                }
                catch let jsonError as NSError {
                    
                    completion(self.url, nil, jsonError)
                }
            }
        }
    }
    
    public func cancel(url: NSURL){
        
        session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) -> Void in
            
            let tasks = dataTasks.filter({ (currentTask) -> Bool in
                
                return ((currentTask.originalRequest?.url)! == url as URL)
                
            })
            
            for task in tasks {
                
                task.cancel()
            }
        }
    }
    
    
}

