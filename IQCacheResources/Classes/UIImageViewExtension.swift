//
//  UIImageViewExtension.swift
//  Pods
//
//  Created by Irshad on 15/07/17.
//
//


import Foundation
import UIKit

public extension UIImageView {
    
    
    public func iq_setImageWithUrl(url: NSURL, completion: @escaping (_ error : NSError?) -> Void) {
        
        self.setImageWithUrl(url: url, placeholderImage: nil, completion: completion)
    }
    
    
    public func setImageWithUrl(url: NSURL) {
        
        self.setImageWithUrl(url: url, placeholderImage: nil, completion: nil)
    }
    
    
    public func setImageWithUrl(url: NSURL, placeholderImage: UIImage? = nil, completion: ((_ error : NSError?) -> Void)?) {
        
        self.image = nil
        
        if let _ = placeholderImage {
            
            self.image = placeholderImage
        }
        
        // check for cache
        if let cachedImage = CacheManager.sharedCache.unarchiveImage(url: url.absoluteString!) {
            
            self.image = cachedImage
            
            if let _ = completion {
                completion!(nil)
                return
            }
        }
        

        download(url: url).getImage { (url, image, error) -> Void in
            
            if error == nil , let _ = image {
                
                self.image = image!
                
                CacheManager.sharedCache.archiveImage(image: image!, url: url.absoluteString!)
                if let _ = completion {
                    completion!(nil)
                }
                
            } else {
                
                if let _ = completion {
                    completion!(error)
                }
            }
        }
    }
}


