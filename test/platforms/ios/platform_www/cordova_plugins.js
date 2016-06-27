cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/com.appsflyer.phonegap.plugins.appsflyer/www/appsflyer.js",
        "id": "com.appsflyer.phonegap.plugins.appsflyer.appsflyer",
        "pluginId": "com.appsflyer.phonegap.plugins.appsflyer",
        "clobbers": [
            "window.plugins.appsFlyer"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "com.appsflyer.phonegap.plugins.appsflyer": "4.0",
    "cordova-plugin-whitelist": "1.2.1"
}
// BOTTOM OF METADATA
});