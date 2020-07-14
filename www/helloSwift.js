var exec = require('cordova/exec');
var PLUGIN_NAME = "helloSwift"; // This is just for code completion uses.

var helloSwift = function () {
};

helloSwift.openCameraTest = function (onSuccess, onError) {
  var asd = {
    y: 150,
    x: 150,
    width: 200,
    height: 200,
  };
  exec(onSuccess, onError, PLUGIN_NAME, "openCameraTest", [asd]);
};

helloSwift.startCamera = function (onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "startCamera", []);
};

helloSwift.recordVideo = function (onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "recordVideo", []);
};

helloSwift.stopRecord = function (onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "recordVideo", []);
};

helloSwift.test = function () {
  helloSwift.openCameraTest(function (sc) {
    console.error(sc)
  }, function (sc) {
    console.error(sc)
  })
};

module.exports = helloSwift;
