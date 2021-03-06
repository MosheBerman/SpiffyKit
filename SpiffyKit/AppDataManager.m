//
//  AppDataManager.m
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "AppDataManager.h"

#import "Constants.h"

#import "SpiffyController.h"

@implementation AppDataManager


+ (NSData *)deviceData
{
    NSString *device = [[UIDevice currentDevice] model];
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    NSMutableDictionary *deviceData = [[NSMutableDictionary alloc] init];
    
    deviceData[@"Device"] = device;
    deviceData[@"System Name"] = systemName;
    deviceData[@"System Version"] = systemVersion;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:deviceData options:0 error:nil];
    
    
    return data;
}

+ (NSData *)defaultsData
{
    NSMutableDictionary *defaultsData = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] mutableCopy];
    
    //	Convert NSURL objects to NSStrings
    for (NSString *key in [defaultsData allKeys]) {
        if ([defaultsData[key] isKindOfClass:[NSDate class]]) {
            defaultsData[key] = [(NSDate *)(defaultsData[key]) description];
        }
        
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:defaultsData options:0 error:nil];
    
    return data;
}

+ (NSData *)localeData
{
    NSString *systemLocale = [[NSLocale systemLocale] localeIdentifier];
    NSString *currentLocale = [[NSLocale currentLocale] localeIdentifier];
    
    NSString *systemTimeZone = [[NSTimeZone systemTimeZone] name];
    NSInteger systemSecondsFromGMT = [[NSTimeZone systemTimeZone] secondsFromGMT];
    
    NSString *localTimeZone = [[NSTimeZone localTimeZone] name];
    NSInteger localSecondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
    
    NSMutableDictionary *localeData = [[NSMutableDictionary alloc] init];
    
    localeData[@"System Locale"] = systemLocale;
    localeData[@"Current Locale"] = currentLocale;
    
    localeData[@"System Time Zone"] = systemTimeZone;
    localeData[@"Local Time Zone"] = localTimeZone;
    
    localeData[@"System Seconds From GMT"] = @(systemSecondsFromGMT);
    localeData[@"Local Seconds From GMT"] = @(localSecondsFromGMT);
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:localeData options:0 error:nil];
    
    return data;
}

+ (NSData *)appData
{
    NSMutableDictionary *appData = [[[NSBundle mainBundle] infoDictionary] mutableCopy];
    
    //	Convert NSURL objects to NSStrings
    for (NSString *key in [appData allKeys]) {
        if ([appData[key] isKindOfClass:[NSURL class]]) {
            appData[key] = [(NSURL *)(appData[key]) path];
        }
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:appData options:0 error:nil];
    
    return data;
}

+ (NSData *)appDataAsSingleFile
{
    NSData *device = [self deviceData];
    NSData *defaults = [self defaultsData];
    NSData *localeData = [self localeData];
    NSData *appData = [self appData];
    
    NSString *newlines = @"\n\n";
    
    NSMutableData *composite = [[NSMutableData alloc] init];
    
    [composite appendBytes:[device bytes] length:[device length]];
    [composite appendBytes:[newlines UTF8String] length:[newlines length]];
    
    [composite appendBytes:[defaults bytes] length:[defaults length]];
    [composite appendBytes:[newlines UTF8String] length:[newlines length]];
    
    [composite appendBytes:[localeData bytes] length:[localeData length]];
    [composite appendBytes:[newlines UTF8String] length:[newlines length]];
    
    [composite appendBytes:[appData bytes] length:[appData length]];
    [composite appendBytes:[newlines UTF8String] length:[newlines length]];
    
    return composite;
}

#pragma mark - App Name

+ (NSString *)appName
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}

#pragma mark - App Version

+ (NSString *)appVersion
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

#pragma mark - App Build

+ (NSString *)appBuild
{
	return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

#pragma mark - App Icon Name

+ (NSString *)appIconName
{
    
    NSString *imageName = [[NSBundle mainBundle] infoDictionary][@"CFBundleIconFiles"][0];
    
    if(!imageName)
    {
        NSDictionary *dictionary = [[NSBundle mainBundle] infoDictionary][@"CFBundleIcons"][@"CFBundlePrimaryIcon"];
        imageName = dictionary[@"CFBundleIconFiles"][0];
    }
    
    return imageName;
}

#pragma mark - App Color

+ (UIColor *)appColor
{
    return [[SpiffyController sharedController] appColor];
}



@end
