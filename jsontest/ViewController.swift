//
//  ViewController.swift
//  jsontest
//
//  Created by RS on 2019/02/09.
//  Copyright © 2019 RS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var loginActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var textFieldU: UITextField!
    @IBOutlet var textFieldP: UITextField!
    @IBOutlet var lable: UILabel!
    @IBOutlet var label: UILabel!
    @IBOutlet var login: UIButton!
    @IBOutlet var signup: UIButton!
    
    let userDefaults = UserDefaults.standard
    
    var getJson: NSDictionary!
    var getStatus: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textFieldU.delegate = self
        textFieldP.delegate = self
        
        textFieldU.placeholder = "username"
        textFieldP.placeholder = "password"
        textFieldP.isSecureTextEntry = true
        
        label.text = ""
        
        self.login.layer.borderColor = UIColor.white.cgColor
        self.signup.layer.borderColor = UIColor.white.cgColor
        
        self.loginActivityIndicator.hidesWhenStopped = true
        
        var request = URLRequest(url: URL(string: "https://brahe.canisius.edu/~sashidar/proj1/appstatus.php")!)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                return
            }
            
            do {
                self.getStatus = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(self.getStatus)
                DispatchQueue.main.async {
                    if (self.getStatus["appstatus"] as! String != "ok"){
                        let storyboard: UIStoryboard = self.storyboard!
                        let second = storyboard.instantiateViewController(withIdentifier: "fail")
                        self.present(second, animated: true, completion: nil)
                    }

                }
            } catch let parseError {
                print("parsing error: \(parseError)")
                let responseString = String(data: data!, encoding: .utf8)
                print("raw response: \(String(describing: responseString))")
            }
        })
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func submit() {
        self.login.isHidden = true
        self.loginActivityIndicator.startAnimating()
        let username = textFieldU.text!
        let password = textFieldP.text!
        //let postString = "name=nanasi&country=japan"
        let postString = "username=\(username)&password=\(password)"
        
        var request = URLRequest(url: URL(string: "https://brahe.canisius.edu/~sashidar/proj1/loginios.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    self.login.isHidden = false
                    self.loginActivityIndicator.stopAnimating()
                    self.al(title: "error",message: "Connection error")
//                    self.label.text = "Connection error"
//                    self.label.sizeToFit()
//                    //self.label.textAlignment = NSTextAlignment.center;
//                    //self.label.center = self.view.center
//                    self.label.textAlignment = NSTextAlignment.natural
                }
                return
            }
            
            do {
                self.getJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                //print(self.getJson)
                DispatchQueue.main.async {
                    if (self.getJson["status"] as! String == "success"){
                        self.loginActivityIndicator.stopAnimating()
                        self.userDefaults.set(username, forKey: "username")
                        let storyboard: UIStoryboard = self.storyboard!
                        let second = storyboard.instantiateViewController(withIdentifier: "home")
                        self.present(second, animated: true, completion: nil)
                    }else{
                        self.login.isHidden = false
                        self.loginActivityIndicator.stopAnimating()
                        self.al(title: "error",message: self.getJson["status"] as! String)
//                        self.label.text = self.getJson["status"] as! String
//                        self.label.sizeToFit()
                        //self.label.textAlignment = NSTextAlignment.center;
//                        self.label.textAlignment = NSTextAlignment.natural
                    }
                    
                }
            } catch let parseError {
                print("parsing error: \(parseError)")
                let responseString = String(data: data!, encoding: .utf8)
                print("raw response: \(String(describing: responseString))")
            }
            //print("response: \(response!)")
            //print(String(data: data!, encoding: .utf8)!)
            //phpOutput = String(data: data!, encoding: .utf8)!
            //NSLog("php",String (phpOutput))
        })
        task.resume()
//        print(self.getJson)
//        self.lable.text = phpOutput
//        NSLog("php here",String (phpOutput))
    }
    
    func al(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            return
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
}

