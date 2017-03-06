//
//  ImageDownloader.swift
//  WeboniseMapApp
//
//  Created by Pradeep Singh on 06/03/17.
//  Copyright © 2017 Pradeep Singh. All rights reserved.
//

import UIKit

typealias ImageDownloadCompletionHandler = (Bool) -> Swift.Void

class ImageDownloader {
    
    static func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func download(image : UIImage, failureCompletionHandler : ImageDownloadCompletionHandler){
        // Create a path
        let documentsURL = getDocumentsDirectory()
        
        let imageName = NSUUID().uuidString + ".png"
        let imagePath = documentsURL.appending(imageName)
        let imageURL =  URL(fileURLWithPath: imagePath)
        do{
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            
            if imageData != nil {
                try imageData?.write(to: imageURL)
            }
            else{
                failureCompletionHandler(true)
            }
        } catch {
            // if it fails then, send failed status true
            failureCompletionHandler(true)
        }
        
    }
    
}
