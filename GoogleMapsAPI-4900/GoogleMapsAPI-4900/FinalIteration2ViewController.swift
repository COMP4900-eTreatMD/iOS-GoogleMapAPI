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
    @IBOutlet weak var myTable: UITableView!
    
    var names = ["1","2","3"]
    var address = ["123","123","123"]
    var category = ["123","123","123"]
    
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: CustomeCell2?
        
        cell = self.myTable.dequeueReusableCellWithIdentifier("mycell2",forIndexPath: indexPath) as?
        CustomeCell2
        
        cell?.name.text = names[indexPath.row]
        cell?.address.text = address[indexPath.row]
        cell?.category.text = address[indexPath.row]
        
        return cell!
    }
}

