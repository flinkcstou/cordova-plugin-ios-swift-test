/*
* Notes: The @objc shows that this class & function should be exposed to Cordova.
*/


@objc(helloSwift) class helloSwift : CDVPlugin {
  @objc(openCameraTest:) // Declare your function name.
  func openCameraTest(command: CDVInvokedUrlCommand) { // write the function code.



    Appcenter.shared.start()
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
  }
}
