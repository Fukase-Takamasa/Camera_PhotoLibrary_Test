//
//  ViewController.swift
//  Camera&PhotoLibraryTest
//
//  Created by 深瀬 貴将 on 2020/02/27.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Instantiate
import InstantiateStandard

class ViewController: UIViewController, StoryboardInstantiatable {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        if imageView.image != nil {
            placeHolderMessageLabel.isHidden = true
        }else {
            placeHolderMessageLabel.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setSwipeBack()

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
            self.showPhotoLibrary()
        }
        let tappedCamera = UIAlertAction(title: "カメラで撮影する", style: .default) { (UIAlertAction) in
            //カメラ起動する処理
            self.showCamera()
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

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showCamera() {
        let sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }else {
            print("failed to start Camera")
        }
    }
    
    func showPhotoLibrary() {
        let sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let photoLibrary = UIImagePickerController()
            photoLibrary.sourceType = sourceType
            photoLibrary.delegate = self
            self.present(photoLibrary, animated: true, completion: nil)
            print("show photoLibrary")
        }else {
            print("failed to show photoLibrary")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
        print("picked image completed")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("canceled")
    }
    
}

