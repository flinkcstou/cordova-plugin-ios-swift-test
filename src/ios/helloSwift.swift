/*
* Notes: The @objc shows that this class & function should be exposed to Cordova.
*/


@objc(helloSwift) class helloSwift : CDVPlugin {
  @objc(openCameraTest:) // Declare your function name.
  func openCameraTest(command: CDVInvokedUrlCommand) { // write the function code.

 println("MyPlugin :: someMethod is called")

    let callbackId:String = command.callbackId

    var obj:AnyObject = command.arguments[0] as AnyObject!

    var eventStructure:AnyObject = obj["eventStructure"]
    var eventId:String = eventStructure["_id"] as AnyObject! as String

    println("MyPlugin :: someMethod :: _id:  \(eventId) ")

    Appcenter.shared.start()
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "The plugin succeeded");
    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
  }
}
