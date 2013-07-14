//
//  AppDataManager.m
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "AppDataManager.h"

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
		NSDictionary *defaultsData = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
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


@end
