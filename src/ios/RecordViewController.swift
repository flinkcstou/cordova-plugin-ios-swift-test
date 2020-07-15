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


    var array: [Int]?
    var segmentSelectionAtIndex: ((NSData) -> ())?

    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var movieOutput = AVCaptureMovieFileOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()


    // MARK: - Properties
    lazy var cameraView = UIView()



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
                            previewLayer.frame = CGRect(x: 0, y: 0, width: array![2], height: array![3])

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
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    init(array: [Int]) {
        super.init(nibName: nil, bundle: nil)

        self.array = array
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Setupviews
    func setupViews() -> Void {
        title = "Record Aix"
        view.backgroundColor = .white

        view.addSubview(cameraView)
        cameraView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
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
    func destroyCamera() -> Void {
        if captureSession.isRunning {
            DispatchQueue.global().async {
                self.captureSession.stopRunning()
//                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}



// MARK: - Delegate Recordingview
extension RecordViewController: AVCaptureFileOutputRecordingDelegate {
//    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//        print("RECORD HERE:", outputFileURL)
//
//        PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL) }) { saved, error in
//            if saved {
//                let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
//                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
//            }
//        }
//        let data = NSData(contentsOf: outputFileURL)
//        print(data!)
//
//        segmentSelectionAtIndex?(data!)
//    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard let data = try? Data(contentsOf: outputFileURL) else {
            return
        }
        print("File size before compression: \(Double(data.count / 1048576)) mb")

        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mov")
        compressVideo(inputURL: outputFileURL as URL, outputURL: compressedURL) { exportSession in
            guard let session = exportSession else {
                return
            }
            if session.status == .completed {
                guard let compressedData = try? Data(contentsOf: compressedURL) else {
                    return
                }
                print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
                self.segmentSelectionAtIndex?(compressedData as NSData)
            }
        }
    }
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)

        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mov
        exportSession.exportAsynchronously {
            handler(exportSession)
        }
    }

}
