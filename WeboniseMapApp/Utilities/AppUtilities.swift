//
//  AppUtilies.swift
//  WeboniseMapApp
//
//  Created by Pradeep Singh on 06/03/17.
//  Copyright © 2017 Pradeep Singh. All rights reserved.
//

import UIKit

class AppUtilities {
    
    static func showAlert_YES_NO_Style(_ title: String, message: String, yesBtnTitle:String, yesHandler:@escaping (UIAlertAction!) -> Void, noBtnTitle:String, noHandler:@escaping (UIAlertAction!) -> Void, presenter: UIViewController!) {
        
        let alert = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title:noBtnTitle, style: UIAlertActionStyle.cancel, handler:noHandler))
        alert.addAction(UIAlertAction(title:yesBtnTitle, style: UIAlertActionStyle.default, handler:yesHandler))
        
        presenter.present(alert, animated: true, completion: nil)
    }
    
    static func showAlert (_ title: String, message: String, okBtnTitle:String, okHandler:@escaping (UIAlertAction!) -> Void, presenter: UIViewController!) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: okBtnTitle, style: UIAlertActionStyle.default, handler: okHandler))
        presenter.present(alert, animated: true, completion: nil)
    }
    
    static func showNetworkDialog(_ title: String, message: String, okBtnTitle: String, presenter: UIViewController!) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: okBtnTitle, style: UIAlertActionStyle.default, handler: nil))
        presenter.present(alert, animated: true, completion: nil)
    }
    
    static func isNetworkAvailable() -> Bool {
        if(Reachability.isConnectedToNetwork()) {
            return true
        }
        
        return false
    }
    
    static func showErrorMessageForNetworkDrop(_ presenter: UIViewController) {
        
        AppUtilities.showAlert("Unable to process your request.", message:"Please try again later.", okBtnTitle: "Okay", okHandler: {(alertAction: UIAlertAction!) in}, presenter: presenter)
    }
}
