//
//  HomeViewController.swift
//  jsontest
//
//  Created by RS on 2019/03/15.
//  Copyright © 2019 RS. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let userDefaults = UserDefaults.standard
    var getJson: NSDictionary!
    
    var errorJson: NSDictionary!
    
    var cellUserList: [String] = []
    var copyCellUserList: [String] = []

    override func viewDidLoad() {
        
        //let userDefaults = UserDefaults.standard
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let username = self.userDefaults.string(forKey: "username") as String!
        let postString = "username=\(username!)"
        var request = URLRequest(url: URL(string: "https://brahe.canisius.edu/~sashidar/proj1/homeCellios.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    self.al(title: "error",message: "Connection error")
                }
                return
            }
            
            do {
                self.getJson = try! JSONSerialization.jsonObject(with: data!, options:[]) as! NSDictionary
                //self.errorJson = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                //print(self.getJson)
                print(self.getJson)
                DispatchQueue.main.async {
                    if !(self.getJson is String){
                        //print("there")
                        //self.cellUserList = self.getJson["result"]
                        //self.cellUserList = [self.getJson["result"] as! String]
                        for var i in self.getJson.allValues{
                            //print(type(of: i))
                            i = String(describing: i)
                            //print(type(of: i))
                            var user = (i as! String).replacingOccurrences(of: "follower = ", with: "")
                            user = user.replacingOccurrences(of: "\n", with: "")
                            user = user.replacingOccurrences(of: "    ", with: "")
                            user = user.replacingOccurrences(of: "user = ", with: "")
                            user = user.replacingOccurrences(of: "{", with: "")
                            user = user.replacingOccurrences(of: "}", with: "")
                            user = user.replacingOccurrences(of: "(", with: "")
                            user = user.replacingOccurrences(of: ")", with: "")
                            user = user.replacingOccurrences(of: ";", with: "")
                            //print(user)
                            self.cellUserList.append(user)
                            if let index = self.cellUserList.index(of:"()") {
                                self.cellUserList.remove(at: index)
                            }
                            print(self.cellUserList)
                            self.copyCellUserList = self.cellUserList
                            self.collectionView.reloadData()
                        }
                    }else{
                        self.al(title: "error",message: self.errorJson["result"] as! String!)
                    }
                    
                }
            } catch let parseError {
                print("parsing error: \(parseError)")
                let responseString = String(data: data!, encoding: .utf8)
                print("raw response: \(String(describing: responseString))")
            }
        })
        task.resume()

        //cellUserList = self.getJson["result"] as! [String]
        copyCellUserList = cellUserList
        //print(cellUserList)
        let nib: UINib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func al(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            return
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellUserList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        //cell.backgroundColor = UIColor.blue
        let cellUser = self.copyCellUserList[indexPath.row]
        print("here")
        print(cellUser)
        //copyCellUserList.remove(at: 0)
        cell.layer.cornerRadius = 30
        
        cell.userLabel.text = cellUser
        cell.iconActivityIndicator.startAnimating()
        cell.topActivityIndicator.startAnimating()
        cell.leftActivityIndicator.startAnimating()
        cell.rightActivityIndicator.startAnimating()
        
        cell.iconActivityIndicator.hidesWhenStopped = true
        cell.topActivityIndicator.hidesWhenStopped = true
        cell.leftActivityIndicator.hidesWhenStopped = true
        cell.rightActivityIndicator.hidesWhenStopped = true
        //
        let iconURL = "https://brahe.canisius.edu/~sashidar/proj1/users/" + cellUser + "/imgs/icon.jpg"
        let iconImageURL = URL(string: iconURL)
        //let iconImageURL = URL(string: "https://brahe.canisius.edu/~sashidar/proj1/sampleimgs/left.jpg")
        getImage(pictureUrl: iconImageURL!, imageHolder: cell.icon, indicator: cell.iconActivityIndicator!)
        
        
        let topURL = "https://brahe.canisius.edu/~sashidar/proj1/users/" + cellUser + "/imgs/top.jpg"
        let topPictureURL = URL(string: topURL)!
        getImage(pictureUrl: topPictureURL, imageHolder: cell.top, indicator: cell.topActivityIndicator!)
        
        let leftURL = "https://brahe.canisius.edu/~sashidar/proj1/users/" + cellUser + "/imgs/left.jpg"
        let leftPictureURL = URL(string: leftURL)!
        getImage(pictureUrl: leftPictureURL, imageHolder: cell.left, indicator: cell.leftActivityIndicator!)
        
        let rightURL = "https://brahe.canisius.edu/~sashidar/proj1/users/" + cellUser + "/imgs/right.jpg"
        let rightPictureURL = URL(string: rightURL)!
        getImage(pictureUrl: rightPictureURL, imageHolder: cell.right, indicator: cell.rightActivityIndicator!)
        
        return cell
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
