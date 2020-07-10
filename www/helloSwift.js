var exec = require('cordova/exec');
var PLUGIN_NAME = "helloSwift"; // This is just for code completion uses.

var helloSwift = function () {
};

helloSwift.yourFunctionName = function (onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "openCameraTest", []);
};

module.exports = helloSwift;
