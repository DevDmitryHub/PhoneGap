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
    NSString* callbackId = command.callbackId;
    
    if (!command.arguments || ![command.arguments count]){
        
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No options found"];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
        return;
    }
    
    NSDictionary* initSdkOptions = [command argumentAtIndex:0 withDefault:[NSNull null]];
    
    NSString* devKey = nil;
    NSString* appId = nil;
    BOOL isDebug = YES;
    
    if (![initSdkOptions isKindOfClass:[NSNull class]]) {
        
        id value = nil;
        devKey = (NSString*)[initSdkOptions objectForKey:@"devKey"];
        appId = (NSString*)[initSdkOptions objectForKey:@"appId"];
        
        value = [initSdkOptions objectForKey:@"isDebug"];
        if ([value isKindOfClass:[NSNumber class]]) {
            // isDebug is a boolean that will come through as an NSNumber
            isDebug = [(NSNumber*)value boolValue];
            // NSLog(@"multiple is: %d", multiple);
        }
    }
    
    NSString* error = nil;
    
    if (!devKey || [devKey isEqualToString:@""]) {
        error = @"No 'devKey' found or its empty";
    }
    if (!appId || [appId isEqualToString:@""]) {
        error = @"No 'appId' found";
    }
    
    
    if(error != nil){
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: error];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
        return;

    }
    else{
        [AppsFlyerTracker sharedTracker].appleAppID = appId;
        [AppsFlyerTracker sharedTracker].appsFlyerDevKey = devKey;
        [AppsFlyerTracker sharedTracker].delegate = self;
        [AppsFlyerTracker sharedTracker].isDebug = isDebug;
        [[AppsFlyerTracker sharedTracker] trackAppLaunch];
        
        //TODO: connect to static lib success callback
         CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Success"];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }
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
