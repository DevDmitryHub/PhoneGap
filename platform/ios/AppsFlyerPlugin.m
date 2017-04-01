#import "AppsFlyerPlugin.h"
#import "AppsFlyerTracker.h"

@implementation AppsFlyerPlugin

- (CDVPlugin *)initWithWebView:(UIWebView *)theWebView
{
    [self pluginInitialize];
    return self;
}

- (void)initSdk:(CDVInvokedUrlCommand*)command
{
    if ([command.arguments count] < 2) {
        return;
    }
    
    NSString* devKey = [command.arguments objectAtIndex:0];
    NSString* appId = [command.arguments objectAtIndex:1];    
    
    [AppsFlyerTracker sharedTracker].appleAppID = appId;
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = devKey;
    [AppsFlyerTracker sharedTracker].delegate = self;
    [AppsFlyerTracker sharedTracker].isDebug = YES;
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    
  }

- (void)setCurrencyCode:(CDVInvokedUrlCommand*)command
{
    if ([command.arguments count] == 0) {
        return;
    }
    
    NSString* currencyId = [command.arguments objectAtIndex:0];
    [AppsFlyerTracker sharedTracker].currencyCode = currencyId;
}

- (void)setAppUserId:(CDVInvokedUrlCommand *)command
{
    if ([command.arguments count] == 0) {
        return;
    }
    
    NSString* userId = [command.arguments objectAtIndex:0];
    [AppsFlyerTracker sharedTracker].customerUserID  = userId;
}

- (void)getAppsFlyerUID:(CDVInvokedUrlCommand *)command
{
    NSString* userId = [[AppsFlyerTracker sharedTracker] getAppsFlyerUID];
    CDVPluginResult *pluginResult = [ CDVPluginResult
                                    resultWithStatus    : CDVCommandStatus_OK
                                    messageAsString: userId
                                    ];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)sendTrackingWithEvent:(CDVInvokedUrlCommand *)command
{
    if ([command.arguments count] < 2) {
        return;
    }
    
    NSString* eventName = [command.arguments objectAtIndex:0];
    NSString* eventValue = [command.arguments objectAtIndex:1];
    [[AppsFlyerTracker sharedTracker] trackEvent:eventName withValue:eventValue];
}

-(void)onConversionDataReceived:(NSDictionary*) installData {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:installData
                                            options:0
                                            error:&error];
    if (jsonData) {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        [self performSelectorOnMainThread:@selector(reportConversionData:) withObject:JSONString waitUntilDone:NO];
        NSLog(@"JSONString = %@",JSONString);

    } else {
        NSLog(@"%@",error);
    }
}

-(void) reportConversionData:(NSString *)data {
    
    [[super webViewEngine] evaluateJavaScript:[NSString stringWithFormat:@"javascript:window.plugins.appsFlyer.onInstallConversionDataLoaded(%@)", data] completionHandler:nil];

}

-(void)onConversionDataRequestFailure:(NSError *) error {
    
    NSLog(@"%@",error);
    
}

- (void)trackEvent:(CDVInvokedUrlCommand*)command {

    NSString* eventName = [command.arguments objectAtIndex:0];
    NSDictionary* eventValues = [command.arguments objectAtIndex:1];
    [[AppsFlyerTracker sharedTracker] trackEvent:eventName withValues:eventValues];

}

- (void)registerUninstall:(CDVInvokedUrlCommand*)command {

    NSData* token = [command.arguments objectAtIndex:0];
    NSString *deviceToken = [NSString stringWithFormat:@"%@",token];
    
    if(deviceToken!=nil){
        [[AppsFlyerTracker sharedTracker] registerUninstall:token];
    }else{
        NSLog(@"Invalid device token");
    }

}

@end
