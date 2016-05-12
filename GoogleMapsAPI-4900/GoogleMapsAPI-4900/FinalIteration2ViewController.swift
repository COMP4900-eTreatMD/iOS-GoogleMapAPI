//
//  FinalIteration2ViewController.swift
//  GoogleMapsAPI-4900
//
//  Created by Jan Ycasas on 2016-04-29.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMaps
import MBProgressHUD

class FinalIteration2ViewController: UIViewController, UITextFieldDelegate,
                                     UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var filterTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filterTextField.delegate = self;
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    // MARK: -- TextField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

