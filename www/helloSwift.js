var exec = require('cordova/exec');
var PLUGIN_NAME = "helloSwift"; // This is just for code completion uses.

var helloSwift = function () {
};

helloSwift.openCameraTest = function (onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "openCameraTest", [150, 150, 200, 200]);
};

helloSwift.startCamera = function (onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "startCamera", []);
};

helloSwift.startRecordVideo = function (onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "startRecordVideo", []);
};

helloSwift.stopRecordVideo = function (onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "stopRecordVideo", []);
};

helloSwift.test = function () {
  helloSwift.openCameraTest(function (sc) {
    console.error(sc)
  }, function (sc) {
    console.error(sc)
  })
};

module.exports = helloSwift;
