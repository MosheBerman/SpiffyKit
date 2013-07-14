//
//  AppDataManager.h
//  SpiffyKit
//
//  Created by Moshe Berman on 7/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppDataManager : NSObject

+ (NSData *)deviceData;
+ (NSData *)defaultsData;
+ (NSData *)localeData;
+ (NSData *)appData;

+ (NSString *)appName;

@end
