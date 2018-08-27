# Cordova / PhoneGap AppsFlyer Plugin for Android and iOS.

[![Version](https://img.shields.io/npm/v/cordova-plugin-appsflyer.svg?style=flat)](#)
[![Cordova status](https://img.shields.io/badge/cordova-v5.x-blue.svg?style=flat)](#)
[![AF-Android-SDK](https://img.shields.io/badge/AF%20Android%20SDK-v4.7.4-green.svg?style=flat)](#)
[![AF-iOS-SDK](https://img.shields.io/badge/AF%20iOS%20SDK-v4.7.11-green.svg?style=flat)](#)
[![NPM downloads](https://img.shields.io/npm/dt/cordova-plugin-appsflyer.svg?style=flat)](#)
[![Github Issues](http://githubbadges.herokuapp.com/devdmitryhub/cordova-plugin-appsflyer/issues.svg)](https://github.com/devdmitryhub/cordova-plugin-appsflyer/issues)
[![Build Status](https://api.travis-ci.org/DevDmitryHub/cordova-plugin-appsflyer.svg?branch=master)](https://travis-ci.org/DevDmitryHub/cordova-plugin-appsflyer)

## Documentation
- [Installation](#installation)
	- [Manual Installation](#manual-installation)
	- [Phone Gap Build](#phonegap-build)
- [Usage API](#usage-api)
- [Uninstalls Tracking](#uninstall-tracking)
- [Deep Links Tracking](#deep-linking-tracking)
- [Plugin wiki pages](https://github.com/DevDmitryHub/cordova-plugin-appsflyer/wiki)
- [Change Log](https://github.com/DevDmitryHub/cordova-plugin-appsflyer/releases)
- [Sample App](#sample-app)

## Installation

Using the reference to GitHub repository:

	cordova plugin add https://github.com/DevDmitryHub/cordova-plugin-appsflyer.git

Using plugin name (Cordova v.5+):

	cordova plugin add cordova-plugin-appsflyer

For Ionic Framework:

    ionic plugin add cordova-plugin-appsflyer

For old Cordova versions you should add reference to the plugin script file.
Then reference `appsflyer.js` in `index.html`, after `cordova.js`/`phonegap.js`.
Mind the path:

```html
<script type="text/javascript" src="js/plugins/appsflyer.js"></script>
```

### Manual Installation

For more details about manual installation see wiki page [Manual Installation](https://github.com/DevDmitryHub/cordova-plugin-appsflyer/wiki/Manual-installation) or use author's [page](https://github.com/AppsFlyerSDK/PhoneGap#manual-installation).

### PhoneGap Build
Built against `Phonegap >= 4.3.x.` `Cordova >= 4.3.x.`

Add the following line to your config xml:

```xml
<gap:plugin name="cordova-plugin-appsflyer" version="4.2.17" />
```

## Usage API

#### 1\. Set your App_ID (iOS only), Dev_Key and enable AppsFlyer to detect installations, sessions (app opens), and updates.
**Note:** *This is the minimum requirement to start tracking your app installs and it's already implemented in this plugin. You **_MUST_** modify this call and provide:*

- *devKey* - Your application devKey provided by AppsFlyer.
- *appId*  - **For iOS only.** Your iTunes application id.

```javascript
function isIOS() {
    //for Cordova
    var userAgent = window.navigator.userAgent.toLowerCase();
    var result = /iphone|ipad|ipod/.test( userAgent );

    //for Ionic
    var result = ionic.Platform.isIOS();

    return result;
}

function initListener() {
    var options = {
        devKey: "xxXXXXXxXxXXXXxXXxxxx8", // your AppsFlyer devKey
        isDebug: true                     // optional
    };

    if (isIOS()) {
        options.appId = "123456789";     // your ios app id in app store
    }

    window.plugins.appsFlyer.initSdk(options);
}

//for Cordova
document.addEventListener("deviceready", initListener, false);
//for Ionic
$ionicPlatform.ready(initListener);
```

#### 2\. Set currency code (optional)
```javascript
//USD is default value. Acceptable ISO(http://www.xe.com/iso4217.php) Currency codes here. Examples:
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
**Note:** AppsFlyer plugin replaced event `onInstallConversionDataLoaded` by using listener `onInstallConversionDataListener` if you want use it,
you have to enable option `onInstallConversionDataListener` to `true` on `initSdk` and handle information.

#### 7\. End User Opt-Out. Device Tracking Disabled
AppsFlyer provides you a method to opt‐out specific users from AppsFlyer analytics. This method complies with the latest privacy requirements and complies with Facebook data and privacy policies. Default is FALSE, meaning tracking is enabled by default.

###### Example:
```javascript
window.plugins.appsFlyer.setDeviceTrackingDisabled(true);
```

## Uninstall Tracking

**Android** - AppsFlyer requires a Google Project Number to enable uninstall tracking for Android apps.
<a href="https://support.appsflyer.com/hc/en-us/articles/208004986-Android-Uninstall-Tracking">More Information</a>.

Usage: `setGCMProjectID(gcmProjectNumber): void //@Deprecated `.

Usage: `enableUninstallTracking(token, onSuccess, onError): void`.

**iOS** - AppsFlyer requires a Token to enable uninstall tracking for iOS apps.
 <a href="https://support.appsflyer.com/hc/en-us/articles/211211963-iOS-Uninstall-Tracking">More Information</a>.
Usage: `enableUninstallTracking(token, onSuccess, onError): void`.

Usage: `registerUninstall(token): void`.

## Deep Linking Tracking

#### Android
Since v.4.2.0 deeplinking metadata (scheme/host) is sent automatically

#### iOS
Add the following function `handleOpenUrl` to your root, and call SDK as shown:
###### Example:
```javascript
var handleOpenURL = function(url) {
    window.plugins.appsFlyer.handleOpenUrl(url);
}
```
**Universal Links in iOS**

To enable Universal Links in iOS please follow the guide <a href="https://support.appsflyer.com/hc/en-us/articles/207032266-Setting-Deeplinking-on-iOS9-using-iOS-Universal-Links">here</a>.

**Note**: Our plugin utilizes the

 ` - (BOOL)application:(UIApplication *)application
 continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler; `

##### method for Universal Links support.

***If additional instances of the method exist in your code - merge all calls into one***

**(Available on cordova-plugin-appsflyer-sdk 4.2.24 and higher )**

## Sample App

This plugin has a `examples` folder with `demoA` (AngularJS 1.x) and `demoC` (Cordova) projects bundled with it. To give it a try , from root plugin folder execute following:

```sh
# for Cordova
npm run setup_c
# for Angular
npm run setup_a

npm run <example>.<operation>
```
**<example>**
  - `demo_a` - for Android application
  - `demo_c` - for Cordova application
**<operation>**
  - `run-android` - runs Android
  - `build-android` - builds Android
  - `run-ios` - runs iOS
  - `build-ios` - builds iOS