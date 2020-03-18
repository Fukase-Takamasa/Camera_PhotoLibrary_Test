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
import Photos
import AVFoundation

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
            //パーミッション確認
            self.checkPhotoLibraryAuthorization()
        }
        let tappedCamera = UIAlertAction(title: "カメラで撮影する", style: .default) { (UIAlertAction) in
            //パーミッション確認
            self.checkCameraAuthorization()
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
            DispatchQueue.main.async {
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = sourceType
                cameraPicker.delegate = self
                self.present(cameraPicker, animated: true, completion: nil)
                print("カメラ起動")
            }
        }else {
            print("カメラ起動失敗")
        }
    }
    
    func showPhotoLibrary() {
        
        let sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            DispatchQueue.main.async {
                let photoLibrary = UIImagePickerController()
                photoLibrary.sourceType = sourceType
                photoLibrary.delegate = self
                self.present(photoLibrary, animated: true, completion: nil)
                print("フォトライブラリ起動")
            }
        }else {
            print("フォトライブラリ起動失敗")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
            UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
        }
        picker.dismiss(animated: true, completion: nil)
        print("画像取得成功")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("キャンセル")
    }
    
    func checkPhotoLibraryAuthorization() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            //既に許可済みなのでフォトライブラリを表示
            print("既に許可済みなのでフォトライブラリを表示")
            self.showPhotoLibrary()
        case .notDetermined:
            //まだ認証をしてないのでアクセスを求める
            print("まだ認証をしてないのでアクセスを求める")
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    //デフォのアラートが許可されたのでフォトライブラリを表示
                    print("デフォのアラートが許可されたのでフォトライブラリを表示")
                    self.showPhotoLibrary()
                }else if status == .denied {
                    //デフォのアラートが拒否されたので再設定用のダイアログを表示
                    print("デフォのアラートが拒否されたので再設定用のダイアログを表示")
                    self.requestPermissionForPhotoLibrary()
                }
            }
        case .denied:
            //デフォのアラートが拒否されているので再設定用のダイアログを表示
            print("デフォのアラートが拒否されているので再設定用のダイアログを表示")
            self.requestPermissionForPhotoLibrary()
        case .restricted:
            //システムによって拒否された、もしくはアルバムが存在しない
            print("システムによって拒否された、もしくはアルバムが存在しない")
        default:
            print("何らかのエラー")
        }
    }
    
    func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            //既に許可済みなのでカメラを表示
            print("既に許可済みなのでカメラを表示")
            self.showCamera()
        case .notDetermined:
            //まだ認証をしてないのでアクセスを求める
            print("まだ認証をしてないのでアクセスを求める")
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status {
                    print("許可されたのでカメラを表示")
                    self.showCamera()
                }else {
                    print("拒否されたので再設定用のダイアログを表示")
                    self.requestPermissionForCamera()
                }
            }
        case .denied:
            //拒否されているので再設定用のダイアログを表示
            print("拒否されているので再設定用のダイアログを表示")
            self.requestPermissionForCamera()
        case .restricted:
            //システムによって拒否された、もしくはカメラが存在しない
            print("システムによって拒否された、もしくはカメラが存在しない")
        default:
            print("何らかのエラー")
        }
    }
    
    func requestPermissionForCamera() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "カメラへのアクセスを許可", message: "カメラへのアクセスを許可する必要があります。設定を変更して下さい。", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "設定変更", style: .default) { (UIAlertAction) in
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                    print("settingsURLを開けませんでした")
                    return
                }
                print("設定アプリを開きます")
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) in
                print("再設定用ダイアログも拒否されたので閉じます")
            }
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    func requestPermissionForPhotoLibrary() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "写真へのアクセスを許可", message: "写真へのアクセスを許可する必要があります。設定を変更して下さい。", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "設定変更", style: .default) { (UIAlertAction) in
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                    print("settingsURLを開けませんでした")
                    return
                }
                print("設定アプリを開きます")
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) in
                print("再設定用ダイアログも拒否されたので閉じます")
            }
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}


//        let status = PHPhotoLibrary.authorizationStatus()
//        if status == PHAuthorizationStatus.denied {
//            print("デフォアラートが拒否されたので自作アラートを表示します。")
//            let alert = UIAlertController(title: "写真を撮る", message: "カメラを使用するためにアクセスを許可して下さい。", preferredStyle: .alert)
//            let settingsAction = UIAlertAction(title: "許可", style: .default) { (UIAlertAction) in
//                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
//                    print("settingsURLが開ませんでした")
//                    return
//                }
//                print("自作アラートが許可されたので設定アプリを開きます")
//                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
//            }
//            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) in
//                print("自作アラートも拒否されたので閉じます")
//            }
//            alert.addAction(settingsAction)
//            alert.addAction(cancelAction)
//            self.present(alert, animated: true, completion: nil)
//        }else if status == PHAuthorizationStatus.authorized {
//            print("デフォアラートが許可されました")
//            showPhotoLibrary()
//        }else {
//            print("status: \(status)")
//            showPhotoLibrary()
//        }
