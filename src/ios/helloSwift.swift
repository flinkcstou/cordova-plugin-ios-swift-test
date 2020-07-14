

@objc(helloSwift) class helloSwift : CDVPlugin {
    @objc(openCameraTest:)
    
    func openCameraTest(command: CDVInvokedUrlCommand) {
            
//        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
//            window = UIWindow(frame: UIScreen.main.bounds)
//
//            let vc = RecordViewController()
//            window?.rootViewController = vc
//            window?.makeKeyAndVisible()
//
//            return true
//        }
        
        
        
//        var window: UIWindow?
//        window = UIWindow(frame: CGRect(x: 35, y: 35, width: 100, height: 100))
//        let vc = RecordViewController()
//        window?.rootViewController = vc
//        window?.makeKeyAndVisible()

        let callbackId:String = command.callbackId

        var obj:AnyObject = command.arguments[0] as AnyObject!

        var window: UIWindow?
        window = UIWindow(frame: CGRect(x: 35, y: 35, width: 100, height: 100))
        AppCenter.shared.createWindow(window!)
        AppCenter.shared.start()

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
}
