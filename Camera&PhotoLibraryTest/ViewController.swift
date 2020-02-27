//
//  ViewController.swift
//  Camera&PhotoLibraryTest
//
//  Created by 深瀬 貴将 on 2020/02/27.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func choosePhotoButton(_ sender: Any) {
        let actionSheet: UIAlertController = UIAlertController(title: "", message: "アップロードする写真を選択してください", preferredStyle: .actionSheet)
        let tappedCamera = UIAlertAction(title: "カメラで撮影する", style: .default) { (UIAlertAction) in
            //何か処理
        }
        let tappedLibrary = UIAlertAction(title: "ライブラリから選択する", style: .default) { (UIAlertAction) in
            //何か処理
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) in
            //キャンセル
        }
        actionSheet.addAction(tappedCamera)
        actionSheet.addAction(tappedLibrary)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}

