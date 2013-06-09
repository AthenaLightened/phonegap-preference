//
//  CDVPreferencePlugin.h
//  PhoneGAP-Preference
//
//  Created by xu.li on 6/9/13.
//
//

#import <Cordova/CDV.h>

@interface CDVPreferencePlugin : CDVPlugin

- (void)getPreference:(CDVInvokedUrlCommand*)command;
- (void)setPreference:(CDVInvokedUrlCommand*)command;

@end
