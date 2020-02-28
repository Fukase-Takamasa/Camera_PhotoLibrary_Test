//
//  ViewController.swift
//  Camera&PhotoLibraryTest
//
//  Created by 深瀬 貴将 on 2020/02/27.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeHolderMessageLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var previousImageButton: UIButton!
    @IBOutlet weak var nextImageButton: UIButton!
    @IBOutlet weak var toCheckPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if imageView.image != nil {
            placeHolderMessageLabel.isHidden = true
        }else {
            placeHolderMessageLabel.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSwipeBack()
        
        //other
        backButton.rx.tap.subscribe{ _ in
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        quitButton.rx.tap.subscribe{ _ in
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        uploadButton.rx.tap.subscribe{ _ in
            self.showActionSheet()
        }.disposed(by: disposeBag)
        toCheckPageButton.rx.tap.subscribe{ _ in
            //エビデンスが選択されていたら、確認ページに遷移
        }.disposed(by: disposeBag)
        
    }
    
    func showActionSheet() {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let tappedLibrary = UIAlertAction(title: "ライブラリから選択する", style: .default) { (UIAlertAction) in
            //ライブラリにアクセスする処理
        }
        let tappedCamera = UIAlertAction(title: "カメラで撮影する", style: .default) { (UIAlertAction) in
            //カメラ起動する処理
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) in
            //キャンセル
        }
        actionSheet.addAction(tappedLibrary)
        actionSheet.addAction(tappedCamera)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}

