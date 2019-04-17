//
//  SearchViewController.swift
//  jsontest
//
//  Created by RS on 2019/03/15.
//  Copyright © 2019 RS. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! HomeCollectionViewCell
        //cell.backgroundColor = UIColor.blue
        cell.layer.cornerRadius = 30
        
        cell.iconActivityIndicator.startAnimating()
        cell.topActivityIndicator.startAnimating()
        cell.leftActivityIndicator.startAnimating()
        cell.rightActivityIndicator.startAnimating()
        
        cell.iconActivityIndicator.hidesWhenStopped = true
        cell.topActivityIndicator.hidesWhenStopped = true
        cell.leftActivityIndicator.hidesWhenStopped = true
        cell.rightActivityIndicator.hidesWhenStopped = true
        
        let iconImageURL = URL(string: "https://brahe.canisius.edu/~sashidar/proj1/sampleimgs/icon.jpg")
        getImage(pictureUrl: iconImageURL!, imageHolder: cell.icon, indicator: cell.iconActivityIndicator!)
        
        let topPictureURL = URL(string: "https://brahe.canisius.edu/~sashidar/proj1/sampleimgs/top.jpg")!
        getImage(pictureUrl: topPictureURL, imageHolder: cell.top, indicator: cell.topActivityIndicator!)
        
        let leftPictureURL = URL(string: "https://brahe.canisius.edu/~sashidar/proj1/sampleimgs/left.jpg")!
        getImage(pictureUrl: leftPictureURL, imageHolder: cell.left, indicator: cell.leftActivityIndicator!)
        
        let rightPictureURL = URL(string: "https://brahe.canisius.edu/~sashidar/proj1/sampleimgs/right.jpg")!
        getImage(pictureUrl: rightPictureURL, imageHolder: cell.right, indicator: cell.rightActivityIndicator!)
        
        return cell
    }
    
    
    var userDefaults = UserDefaults.standard
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var serachActivityIndicator: UIActivityIndicatorView!
    
    var getJson: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.placeholder = "search by username"
        
        self.serachActivityIndicator.hidesWhenStopped = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func search(){
        let keywords = searchTextField.text!
        var username = self.userDefaults.string(forKey: "username") as! String!
        //let postString = "name=nanasi&country=japan"
        let postString = "keyword=\(keywords)&username=\(username)"
        
        if (keywords == ""){
            self.al(title: "error",message: "Please type some keywords to search")
        }else{
            serachActivityIndicator.startAnimating()
            submit(postString: postString)
        }
    }
    
    func submit(postString: String) {
        
        
        var request = URLRequest(url: URL(string: "https://brahe.canisius.edu/~sashidar/proj1/serachios.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    self.serachActivityIndicator.stopAnimating()
                    self.al(title: "error",message: "Connection error")
                }
                return
            }
            
            do {
                self.getJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                DispatchQueue.main.async {
                    if (self.getJson["result"] != nil){
                        self.serachActivityIndicator.stopAnimating()
                    }else{
                        self.serachActivityIndicator.stopAnimating()
                        self.al(title: "error",message: self.getJson["status"] as! String)
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
    

    func al(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            return
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func getImage(pictureUrl: URL, imageHolder: UIImageView, indicator: UIActivityIndicatorView!) {
        Alamofire.request(pictureUrl).responseData { (response) in
            if response.error == nil {
                //print(response.result)
                if let data = response.data {
                    indicator.stopAnimating()
                    imageHolder.image = UIImage(data: data)
                }
            }
        }
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
