//
//  CellSettingViewController.swift
//  jsontest
//
//  Created by RS on 2019/03/25.
//  Copyright © 2019 RS. All rights reserved.
//

import UIKit

class CellSettingViewController: UIViewController {
    
    @IBOutlet var setCellBorder: UIButton!
    @IBOutlet var setImageBorder: UIButton!
    @IBOutlet var setBothBorder: UIButton!
    
    @IBOutlet var labelCellBorder: UILabel!
    @IBOutlet var labelImageBorder: UILabel!
    @IBOutlet var labelBackground: UILabel!
    
    @IBOutlet var blueBut: UIButton!
    @IBOutlet var pinkBut: UIButton!
    @IBOutlet var greenBut: UIButton!
    @IBOutlet var redBut: UIButton!
    @IBOutlet var whiteBut: UIButton!
    @IBOutlet var blackBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelCellBorder.layer.masksToBounds = true
        labelCellBorder.layer.cornerRadius = 5
        labelCellBorder.layer.borderColor = UIColor.black.cgColor
        labelCellBorder.layer.borderWidth = 0.6
        
        labelImageBorder.layer.masksToBounds = true
        labelImageBorder.layer.cornerRadius = 5
        labelImageBorder.layer.borderColor = UIColor.black.cgColor
        labelImageBorder.layer.borderWidth = 0.6
        
        labelBackground.layer.masksToBounds = true
        labelBackground.layer.cornerRadius = 5
        labelBackground.layer.borderColor = UIColor.black.cgColor
        labelBackground.layer.borderWidth = 0.6

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cellBorder(){
    }
    
    @IBAction func imageBorder(){
    }

    @IBAction func backgroundSetter(){
    }
    
    @IBAction func apply(){
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

