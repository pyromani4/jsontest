//
//  SuccessViewController.swift
//  jsontest
//
//  Created by RS on 2019/03/15.
//  Copyright © 2019 RS. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {
    
    @IBOutlet var login: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.login.layer.borderColor = UIColor.purple.cgColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
