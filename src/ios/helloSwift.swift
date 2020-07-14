

@objc(helloSwift) class helloSwift : CDVPlugin {
    @objc(openCameraTest:)
    func openCameraTest(command: CDVInvokedUrlCommand) {

        let callbackId: String = command.callbackId
        print("call: ", callbackId)

        let variables: [Int] = command.arguments as! [Int]

        var window: UIWindow?
        window = UIWindow(frame: CGRect(x: variables[0], y: variables[1], width: variables[2], height: variables[3]))
//        window = UIWindow(frame: UIScreen.main.bounds)
        AppCenter.shared.createWindow(window!)
        AppCenter.shared.start(array: variables)

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }


    @objc(startRecordVideo:)
    func startRecordVideo(command: CDVInvokedUrlCommand) {

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }

    @objc(stopRecordVideo:)
    func stopRecordVideo(command: CDVInvokedUrlCommand) {

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
}
