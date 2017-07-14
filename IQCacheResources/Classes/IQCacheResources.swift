//
//  IQCacheResources.swift
//  Pods
//
//  Created by Irshad on 15/07/17.
//
//

import Foundation


public func download(url: NSURL) -> DownloadManager {
    
    return DownloadManager(url: url)
}


public func download(url: NSURL, shouldCache: Bool) -> DownloadManager {
    
    return DownloadManager(url: url, shouldCache: shouldCache)
}
