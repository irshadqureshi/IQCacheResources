//
//  UIImageViewExtension.swift
//  Pods
//
//  Created by Irshad on 15/07/17.
//
//


import Foundation
import UIKit


// Mark:- Image View Extension to check if image exsist in cache or not. If not then download it from server.
public extension UIImageView {
    
    
    public func iq_setImageWithUrl(url: NSURL, completion: @escaping (_ error : NSError?) -> Void) {
        
        self.iq_setImageWithUrl(url: url, placeholderImage: nil, completion: completion)
    }
    
    
    public func iq_setImageWithUrl(url: NSURL) {
        
        self.iq_setImageWithUrl(url: url, placeholderImage: nil, completion: nil)
    }
    
    
    public func iq_setImageWithUrl(url: NSURL, placeholderImage: UIImage? = nil, completion: ((_ error : NSError?) -> Void)?) {
        
        self.image = nil
        
        if let _ = placeholderImage {
            
            self.image = placeholderImage
        }
        
        if let cachedImage = CacheManager.sharedCache.unarchiveImage(url: url.absoluteString!) {
            
            self.image = cachedImage
            
            if let _ = completion {
                completion!(nil)
            }
            return
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



