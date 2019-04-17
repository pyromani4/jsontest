//
//  SignupViewController.swift
//  jsontest
//
//  Created by RS on 2019/03/15.
//  Copyright © 2019 RS. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textFieldU: UITextField!
    @IBOutlet var textFieldP: UITextField!
    @IBOutlet var textFieldP2: UITextField!
    @IBOutlet var textFieldE: UITextField!
    @IBOutlet var lable: UILabel!
    @IBOutlet var label: UILabel!
    @IBOutlet var login: UIButton!
    @IBOutlet var signup: UIButton!
    
    var getJson: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldU.delegate = self
        textFieldP.delegate = self
        textFieldU.placeholder = "username"
        textFieldP.placeholder = "password"
        textFieldE.placeholder = "email"
        textFieldP2.placeholder = "confirmation password"
        textFieldP.isSecureTextEntry = true
        textFieldP2.isSecureTextEntry = true
        label.text = ""
        self.login.layer.borderColor = UIColor.white.cgColor
        self.signup.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit() {
        
        
        let username = textFieldU.text!
        let password = textFieldP.text!
        let password2 = textFieldP2.text!
        let email = textFieldE.text!
        
        let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        if (result == true){
            //let postString = "name=nanasi&country=japan"
            let postString = "username=\(username)&password=\(password)&password2=\(password2)&email=\(email)"
            
            var request = URLRequest(url: URL(string: "https://brahe.canisius.edu/~sashidar/proj1/signupios.php")!)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in

                if error != nil {
                    DispatchQueue.main.async {
                        self.label.text = "Connection error"
                        self.label.sizeToFit()
                        self.label.textAlignment = .center
                        //self.label.center = self.view.center
                    }
                    return
                }
                
                do {
                    self.getJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    DispatchQueue.main.async {
                        if (self.getJson["status"] as! String == "successfully signup!!"){
                            let storyboard: UIStoryboard = self.storyboard!
                            let second = storyboard.instantiateViewController(withIdentifier: "suc")
                            self.present(second, animated: true, completion: nil)
                        }else{
                            self.al(title: "error",message: self.getJson["status"] as! String)
//                            self.label.text = self.getJson["status"] as! String
//                            self.label.sizeToFit()
                            //self.label.center = self.view.center
                            
                        }
                        
                    }
                } catch let parseError {
                    print("parsing error: \(parseError)")
                    let responseString = String(data: data!, encoding: .utf8)
                    print("raw response: \(responseString)")
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
        }else{
            self.al(title: "error",message: "please check all field or validate email")
//            self.label.text = "please check all field or confrim email"
//            self.label.sizeToFit()
            //self.label.center = self.view.center
        }
    }
    
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func al(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            return
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }

}
