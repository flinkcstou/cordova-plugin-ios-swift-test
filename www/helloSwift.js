var exec = require('cordova/exec');
var PLUGIN_NAME = "helloSwift"; // This is just for code completion uses.

var helloSwift = function () {
};

helloSwift.startCamera = function (onSuccess, onError, data) {
  exec(onSuccess, onError, PLUGIN_NAME, "startCamera", data);
};

helloSwift.stopCamera = function (onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "stopCamera", []);
};

helloSwift.startRecordVideo = function (onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "startRecordVideo", []);
};

helloSwift.stopRecordVideo = function (onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "stopRecordVideo", []);
};
module.exports = helloSwift;
