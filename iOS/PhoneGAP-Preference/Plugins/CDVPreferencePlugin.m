//
//  CDVPreferencePlugin.m
//  PhoneGAP-Preference
//
//  Created by xu.li on 6/9/13.
//
//

#import "CDVPreferencePlugin.h"
#import <Foundation/Foundation.h>

@implementation CDVPreferencePlugin

- (void)getPreference:(CDVInvokedUrlCommand*)command
{
    // prepare all the keys
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSString *key = nil;
    if ([command.arguments count] > 1) {
        for (key in command.arguments) {
            [keys addObject:key];
        }
    } else {
        id firstArgument = [command.arguments lastObject];
        if (firstArgument) {
            if ([firstArgument isKindOfClass:[NSArray class]]) {
                for (key in firstArgument) {
                    [keys addObject:key];
                }
            } else {
                [keys addObject:firstArgument];
            }
        }
    }
    
    // get all the default values
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *preferences = [[NSMutableDictionary alloc] init];
    for (key in keys) {
        id value = [defaults valueForKey:key];
        if (value) {
            [preferences setValue:value forKey:key];
        } else {
            [preferences setValue:[NSNull null] forKey:key];
        }
    }
    
    // return back
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                  messageAsDictionary:preferences];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setPreference:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    if ([command.arguments count] != 2) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } else {
        NSString *key = [command.arguments objectAtIndex:0];
        id value = [command.arguments lastObject];
        [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
