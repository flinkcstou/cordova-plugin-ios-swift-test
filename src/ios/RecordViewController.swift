//
//  RecordViewController.swift
//  AixDetected
//
//  Created by greetgo on 7/9/20.
//  Copyright © 2020 greetgo. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import SnapKit

class RecordViewController: UIViewController {



    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var movieOutput = AVCaptureMovieFileOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()



    // MARK: - Properties
    lazy var cameraView = UIView()



    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        startCamera()
    }



    // MARK: - Functions
    func startCamera() -> Void {
        self.cameraView = self.view

        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in devices {
            if (device as AnyObject).position == AVCaptureDevice.Position.front {
                do{
                    let input = try AVCaptureDeviceInput(device: device )

                    if captureSession.canAddInput(input) {
                        captureSession.addInput(input)
                        if #available(iOS 11.0, *) {
                            sessionOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecType.jpeg]
                        } else {
                            // Fallback on earlier versions
                        }

                        if captureSession.canAddOutput(sessionOutput) {

                            captureSession.addOutput(sessionOutput)
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

                            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                            previewLayer.connection!.videoOrientation = AVCaptureVideoOrientation.portrait
                            previewLayer.frame = CGRect(x: UIScreen.main.bounds.size.width * 0.4, y: UIScreen.main.bounds.size.height * 0.4, width: 100, height: 150)

                            cameraView.layer.addSublayer(previewLayer)
                        }
                        captureSession.addOutput(movieOutput)
                        captureSession.startRunning()
                    }
                }
                catch { print("Error") }
            }
        }
    }
    init(array: [Int]) {
        super.init(nibName: nil, bundle: nil)

        view.addSubview(cameraView)
        cameraView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(array[0])
            make.top.equalToSuperview().offset(array[1])
            make.width.equalTo(array[2])
            make.height.equalTo(array[3])
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    // MARK: - Functions
    func startRecord() -> Void {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("output.mov")
        try? FileManager.default.removeItem(at: fileUrl)
        movieOutput.startRecording(to: fileUrl, recordingDelegate: self)
    }
    func stopRecord() -> Void {
        let delayTime = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.movieOutput.stopRecording()
        }
    }
}



// MARK: - Delegate Recordingview
extension RecordViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("RECORD HERE:", outputFileURL)

        PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL) }) { saved, error in
            if saved {
                let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        let data = NSData(contentsOf: outputFileURL)
        print(data!)
    }
}
