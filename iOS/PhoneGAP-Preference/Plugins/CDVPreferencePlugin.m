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
        // handle the format like "getPreference("key1", "key2")"
        for (key in command.arguments) {
            [keys addObject:key];
        }
    } else {
        // handle the format like "getPreference(["key1", "key2"])"
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
    // prepare all the keys and values
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    if ([command.arguments count] > 1) {
        // handle the format like "setPreference("key1", "value1")"
        [values setValue:[command.arguments lastObject] forKey:[command.arguments objectAtIndex:0]];
    } else {
        // handle the format like "setPreference({"key1": "value1"})"
        id firstArgument = [command.arguments lastObject];
        if (firstArgument && [firstArgument isKindOfClass:[NSDictionary class]]) {
            values = firstArgument;
        }
    }
    
    // set the values
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (NSString *key in values) {
        [defaults setValue:values[key] forKey:key];
    }
    
    // return back
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
