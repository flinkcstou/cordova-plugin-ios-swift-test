

@objc(helloSwift) class helloSwift : CDVPlugin {


    var window: UIWindow?
    var vc = RecordViewController(array: [100, 100, 200, 200])


    @objc(openCameraTest:)
    func openCameraTest(command: CDVInvokedUrlCommand) {

        let variables: [Int] = command.arguments as! [Int]
        vc = RecordViewController(array: variables)

        window = UIWindow(frame: CGRect(x: variables[0], y: variables[1], width: variables[2], height: variables[3]))
        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }


    @objc(startRecordVideo:)
    func startRecordVideo(command: CDVInvokedUrlCommand) {
        vc.startRecord()

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }


    @objc(stopRecordVideo:)
    func stopRecordVideo(command: CDVInvokedUrlCommand) {
        vc.stopRecord()

        vc.segmentSelectionAtIndex = { [weak self] (asd) in
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsArrayBuffer: asd as Data);
            self!.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
    }
}
