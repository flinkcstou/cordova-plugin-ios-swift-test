var exec = require('cordova/exec');
var PLUGIN_NAME = "helloSwift"; // This is just for code completion uses.

var helloSwift = function () {
};

helloSwift.openCameraTest = function (onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "openCameraTest", []);
};
helloSwift.test = function () {
  helloSwift.openCameraTest(function (sc) {
    console.error(sc)
  }, function (sc) {
    console.error(sc)
  })
};

module.exports = helloSwift;
