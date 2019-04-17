//
//  ForgetViewController.swift
//  jsontest
//
//  Created by RS on 2019/03/16.
//  Copyright © 2019 RS. All rights reserved.
//

import UIKit

class ForgetViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textFieldE: UITextField!
    @IBOutlet var textFieldE2: UITextField!
    
    override func viewDidLoad() {
        textFieldE.delegate = self
        textFieldE2.delegate = self
        textFieldE.placeholder = "email"
        textFieldE2.placeholder = "confirm email"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(){
        let alertController = UIAlertController(title: "Confirmation", message: "We sent you an email", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            let storyboard: UIStoryboard = self.storyboard!
            let second = storyboard.instantiateViewController(withIdentifier: "login")
            self.present(second, animated: true, completion: nil)
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
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

}
