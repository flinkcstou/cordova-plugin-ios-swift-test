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

class RecordViewController: UIViewController {
    
    
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var movieOutput = AVCaptureMovieFileOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    
    
    // MARK: - Properties
    lazy var cameraView = UIView()
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "record not begin"
        label.textColor = .black
        label.font = UIFont.init(name: Font.mullerRegular, size: 10)
        return label
    }()
    lazy var startRecordButton: UIButton = {
        let button = UIButton()
        button.setTitle("StartRecord", for: .normal)
        button.titleLabel?.font = UIFont.init(name: Font.mullerRegular, size: 10)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(tapStartRecord), for: .touchUpInside)
        return button
    }()
    lazy var stopRecordButton: UIButton = {
        let button = UIButton()
        button.setTitle("StopRecord", for: .normal)
        button.titleLabel?.font = UIFont.init(name: Font.mullerRegular, size: 10)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(tapStopRecord), for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
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
                        sessionOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecType.jpeg]

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
    
    
    
    // MARK: - Setupviews
    func setupViews() -> Void {
        title = "Record Aix"
        view.backgroundColor = .white
        
        view.addSubviews([cameraView, statusLabel, startRecordButton, stopRecordButton])
        cameraView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        statusLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-150)
            make.centerX.equalToSuperview()
        }
        startRecordButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-50)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        stopRecordButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-50)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
    
    
    // MARK: - Actions
    @objc func tapStartRecord() -> Void {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("output.mov")
        try? FileManager.default.removeItem(at: fileUrl)
        movieOutput.startRecording(to: fileUrl, recordingDelegate: self)
        
        statusLabel.text = "record starting"
    }
    @objc func tapStopRecord() -> Void {
        let delayTime = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.statusLabel.text = "record finish"
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
