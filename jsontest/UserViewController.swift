//
//  UserViewController.swift
//  jsontest
//
//  Created by RS on 2019/03/15.
//  Copyright © 2019 RS. All rights reserved.
//

protocol DoSomethingDelegate {
    func chooseIconPicture()
    func chooseTopPicture()
    func chooseLeftPicture()
    func chooseRightPicture()
}

import Alamofire
import UIKit

class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let username = self.userDefaults.string(forKey: "username") as String!
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
        //cell.backgroundColor = UIColor.blue
        cell.userLabel.text = username
        cell.layer.cornerRadius = 30
        
        cell.iconActivityIndicator.startAnimating()
        cell.topActivityIndicator.startAnimating()
        cell.leftActivityIndicator.startAnimating()
        cell.rightActivityIndicator.startAnimating()
        
        cell.iconActivityIndicator.hidesWhenStopped = true
        cell.topActivityIndicator.hidesWhenStopped = true
        cell.leftActivityIndicator.hidesWhenStopped = true
        cell.rightActivityIndicator.hidesWhenStopped = true
        
        cell.iconButton.addTarget(self, action: #selector(self.chooseIconPicture(sender:)), for: .touchUpInside)
        
        cell.topButton.addTarget(self, action: #selector(self.chooseTopPicture(sender:)), for: .touchUpInside);
        
        cell.leftButton.addTarget(self, action: #selector(self.chooseLeftPicture(sender:)), for: .touchUpInside);
        
        cell.rightButton.addTarget(self, action: #selector(self.chooseRightPicture(sender:)), for: .touchUpInside);
        
        let iconUrl = "https://brahe.canisius.edu/~sashidar/proj1/users/" + username! + "/imgs/icon.jpg"
        let iconImageURL = URL(string: iconUrl)!
        getImage(pictureUrl: iconImageURL, imageHolder: cell.icon, indicator: cell.iconActivityIndicator!)
        
        let topUrl = "https://brahe.canisius.edu/~sashidar/proj1/users/" + username! + "/imgs/top.jpg"
        let topPictureURL = URL(string: topUrl)!
        getImage(pictureUrl: topPictureURL, imageHolder: cell.top, indicator: cell.topActivityIndicator!)
        
        let leftUrl = "https://brahe.canisius.edu/~sashidar/proj1/users/" + username! + "/imgs/left.jpg"
        let leftPictureURL = URL(string: leftUrl)!
        getImage(pictureUrl: leftPictureURL, imageHolder: cell.left, indicator: cell.leftActivityIndicator!)
        
        let rightUrl = "https://brahe.canisius.edu/~sashidar/proj1/users/" + username! + "/imgs/right.jpg"
        let rightPictureURL = URL(string: rightUrl)!
        getImage(pictureUrl: rightPictureURL, imageHolder: cell.right, indicator: cell.rightActivityIndicator!)
        
        return cell
    }
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet var userCellCollectionView: UICollectionView!
    
    @IBOutlet var iconActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var topActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var leftActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var rightActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var icon:UIImageView!
    @IBOutlet var top:UIImageView!
    @IBOutlet var left:UIImageView!
    @IBOutlet var right:UIImageView!
    @IBOutlet var userButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCellCollectionView.delegate = self
        userCellCollectionView.dataSource = self
        
        let nib: UINib = UINib(nibName: "UserCollectionViewCell", bundle: nil)
        userCellCollectionView.register(nib, forCellWithReuseIdentifier: "UserCollectionViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("there")
        userCellCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 画面の中心になるようにする
//        self.shapeLayer.position = CGPoint(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.height / 2.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fadein(img : UIImageView, animationDuration: Float){
        UIView.animate(withDuration: TimeInterval(animationDuration), animations: { () -> Void in
            img.alpha = 1
        }, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
        //let imageData:Data = UIImagePNGRepresentation(image_data!)!
        //let imageStr = imageData.base64EncodedString()
        uploadImage(image_data: image_data!)
        self.dismiss(animated: true)
    }
    
    func uploadImage(image_data: UIImage) {
        let username = self.userDefaults.string(forKey: "username") as String!
        let position = self.userDefaults.string(forKey: "position") as String!
        
        let image = image_data
        //let image = UIImage.init(named: "myImage")
        let imgData = UIImageJPEGRepresentation(image, 0.1)!
        //let imageData = NSData(data: UIImagePNGRepresentation(image)!)
        //let imageToUploadURL = Bundle.main.url(forResource: "tree", withExtension: "jpg")
        //let fileName =  position! + ".jpg"
        //print(imgData)
        
        let parameters = ["position": position, "username": username]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image",fileName: "pic", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
            }
        },
                         to:"https://brahe.canisius.edu/~sashidar/proj1/uploadPictureios.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result)   // result of response serialization
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    
    
    @objc func chooseIconPicture(sender : UIButton) {
        underAlert(position: "icon")
        self.userDefaults.set("icon", forKey: "position")
    }
    
    @objc func chooseTopPicture(sender : UIButton) {
        underAlert(position: "top")
        self.userDefaults.set("top", forKey: "position")
    }
    
    @objc func chooseLeftPicture(sender : UIButton) {
        underAlert(position: "left")
        self.userDefaults.set("left", forKey: "position")
    }
    
    @objc func chooseRightPicture(sender : UIButton) {
        underAlert(position: "right")
        self.userDefaults.set("right", forKey: "position")
    }

    func underAlert(position: String){
        let alert: UIAlertController = UIAlertController(title: "", message: "Do you want to change the image", preferredStyle:  UIAlertControllerStyle.actionSheet)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            // カメラロールが利用可能か？
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerView = UIImagePickerController()
                pickerView.sourceType = .photoLibrary
                pickerView.delegate = self
                self.present(pickerView, animated: true)
            }
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
}



