# Cordova / PhoneGap AppsFlyer Plugin for Android and iOS.

[![Version](https://img.shields.io/npm/v/cordova-plugin-appsflyer.svg?style=flat)](#)
[![Cordova status](https://img.shields.io/badge/cordova-v5.x-blue.svg?style=flat)](#)
[![NPM downloads](https://img.shields.io/npm/dt/cordova-plugin-appsflyer.svg?style=flat)](#)
[![Github Issues](http://githubbadges.herokuapp.com/devdmitryhub/cordova-plugin-appsflyer/issues.svg)](https://github.com/devdmitryhub/cordova-plugin-appsflyer/issues)

## Documentation
- [Installation](#installation)
	- [Manual Installation](#manual-installation)
	- [Phone Gap Build](#phonegap-build)
- [Usage API](#usage-api)
- [Plugin wiki pages](https://github.com/DevDmitryHub/cordova-plugin-appsflyer/wiki)
- [Change Log](https://github.com/DevDmitryHub/cordova-plugin-appsflyer/releases)

Plugin was updated by AF to v.4.x with updated AF-Android-SDK & AF-iOS-SDK.

## Supported Platforms

- Android
- iOS 8+

## Installation

Using the reference to GitHub repository:

	cordova plugin add https://github.com/DevDmitryHub/cordova-plugin-appsflyer.git

Using plugin name (Cordova v.5+):

	cordova plugin add cordova-plugin-appsflyer


For old Cordova versions you should add reference to the plugin script file.
Then reference `appsflyer.js` in `index.html`, after `cordova.js`/`phonegap.js`.
Mind the path:

```html
<script type="text/javascript" src="js/plugins/appsflyer.js"></script>
```

### Manual Installation

For more details about manual installation see wiki page [Manual Installation](https://github.com/DevDmitryHub/cordova-plugin-appsflyer/wiki/Manual-installation) or use author's [page](https://github.com/AppsFlyerSDK/PhoneGap#manual-installation).

### PhoneGap Build
Built against Phonegap >= 4.3.x.

Add the following line to your config xml:

```xml
<gap:plugin name="cordova-plugin-appsflyer" version="3.3.1" />
```

## Usage API

#### 1\. Set your App_ID (iOS only), Dev_Key and enable AppsFlyer to detect installations, sessions (app opens), and updates.  
**Note:** *This is the minimum requirement to start tracking your app installs and it's already implemented in this plugin. You **_MUST_** modify this call and provide:*

- *devKey* - Your application devKey provided by AppsFlyer.
- *appId*  - **For iOS only.** Your iTunes application id.

**For Cordova:**

```javascript
document.addEventListener("deviceready", function(){
    var args = [];
    var devKey = "xxXXXXXxXxXXXXxXXxxxx8";   // your AppsFlyer devKey
    args.push(devKey);
    var userAgent = window.navigator.userAgent.toLowerCase();
                          
    if (/iphone|ipad|ipod/.test( userAgent )) {
        var appId = "123456789";            // your ios app id in app store
        args.push(appId);
    }
	window.plugins.appsFlyer.initSdk(args);
}, false);
```

**For Ionic**

```javascript
  $ionicPlatform.ready(function() {

    var args = [];
    var devKey = "xxXXXXXxXxXXXXxXXxxxx8";   // your AppsFlyer devKey
    args.push(devKey);

    if (ionic.Platform.isIOS()) {
        var appId = "123456789";            // your ios app id in app store
        args.push(appId);
    }

      window.plugins.appsFlyer.initSdk(args);

  });
```


#### 2\. Set currency code (optional)
```javascript
//USD is default value. Acceptable ISO(http://www.xe.com/iso4217.php) Currency codes here. Examples:  
//British Pound: window.plugins.appsFlyer.setCurrencyCode("GBP");  
window.plugins.appsFlyer.setCurrencyCode("USD");
```
#### 3\. Set customer user ID (Advance)
*Setting your own custom ID will enable you to cross-reference your own unique ID with AppsFlyer’s user ID and the 
other devices’ IDs. This ID will be available at AppsFlyer CSV reports along with postbacks APIs for cross-referencing 
with you internal IDs.*  
**Note:** *The ID must be set during the first launch of the app at the SDK initialization. The best practice is to call to this API during `deviceready` event if possible.*
```javascript
window.plugins.appsFlyer.setAppUserId(userId);
```
#### 4\. In App Events Tracking API (optional)
*These events help you track how loyal users discover your app and attribute them to specific campaign/source.*
- *These in-app events help you track how loyal users discover your app, and attribute them to specific 
campaigns/media-sources. Please take the time define the event/s you would like to measure to allow you 
to track ROI (Return on Investment) and LTV (Lifetime Value).*
- *The “trackEvent” method allows you to send in-app events to AppsFlyer analytics. This method allows you to 
add events dynamically by adding them directly to the application code.*
- Rich In App Events Tracking API (optional).
AppsFlyer’s rich in­app events provide advertisers with the ability to track any post­install event and attribute it to a media source and campaign.
An in­app event is comprised of an event name and event parameters

###### Example:
```javascript
var eventName = "af_add_to_cart";
var eventValues = {"af_content_id": "id123", "af_currency":"USD", "af_revenue": "2"};
window.plugins.appsFlyer.trackEvent(eventName, eventValues);
```
#### 5\. Get AppsFlyer’s Unique Device UID (Advanced)
*Get AppsFlyer’s proprietary device ID. AppsFlyer device ID is the main ID used by AppsFlyer in the Reports and API’s.*
###### Example:
```javascript
var getUserIdCallbackFn = function(id) {
	alert('received id is: ' + id);
}
window.plugins.appsFlyer.getAppsFlyerUID(getUserIdCallbackFn);
```
#### 6\. Accessing AppsFlyer Attribution / Conversion Data from the SDK (Deferred Deep-linking).
Read more: [Android](http://support.appsflyer.com/entries/69796693-Accessing-AppsFlyer-Attribution-Conversion-Data-from-the-SDK-Deferred-Deep-linking-), [iOS](http://support.appsflyer.com/entries/22904293-Testing-AppsFlyer-iOS-SDK-Integration-Before-Submitting-to-the-App-Store-)
**Note:** AppsFlyer plugin will fire `onInstallConversionDataLoaded` event with attribution data. You must implement listener to receive the data.
###### Example:
```javascript
document.addEventListener('onInstallConversionDataLoaded', function(e){
	var attributionData = (JSON.stringify(e.detail));
	alert(attributionData);
}, false);
```
