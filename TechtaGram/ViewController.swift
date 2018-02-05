//
//  ViewController.swift
//  TechtaGram
//
//  Created by 小西夏穂 on 2017/10/12.
//  Copyright © 2017年 小西夏穂. All rights reserved.
//

import UIKit

//写真をSNSに投稿したい時に必要なフレームワーク
import Accounts

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var cameraImageView: UIImageView!
    
    //画像を加工するための元となる画像
    var originalImage: UIImage!
    
    //画像を加工するフィルターの宣言
    var filter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //"撮影する"ボタンを押した時のメソッド
    @IBAction func takePhoto() {
        //カメラが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            //カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        } else {
            //カメラを使えないときはエラーがコンソールに出ます
            print("error")
        }
    }
    
    //カメラ、カメラロールを使ったときに選択した画像をアプリ内に表示するためのメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        cameraImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        originalImage = cameraImageView.image
        
        dismiss(animated: true, completion: nil)
    }
    
    //編集した画像に保存するためのメソッド
    @IBAction func savePhoto() {
        
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
        
    }
    
    //表示している画像にフィイルターを加工する時のメソッド
    @IBAction func colorFilter() {
        
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        //彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        //明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
        
    }
    
    //カメラロールにある画像を読み込む時のメソッド
    @IBAction func openAlbum() {
        
        //カメラロールを使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            //カメラロールの画像を選択して画像を表示するまでの一連の流れ
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
        
    }
    
    //SNSに編集した画像を投稿したい時のメソッド
    @IBAction func snsPhoto() {
        
        //投稿する時に一緒に乗せるコメント
        let shareText = "写真加工いえい"
        
        //投稿する画像の選択
        let shareImage = cameraImageView.image
        
        //投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems,applicationActivities: nil)
        
        let excludedAcivityTypes = [UIActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes = excludedAcivityTypes
        
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

