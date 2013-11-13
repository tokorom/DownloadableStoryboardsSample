//
//  AppDelegate.m
//  DownloadableStoryboardsSample
//
//  Created by yuta-tokoro on 11/12/13.
//  Copyright (c) 2013 cookpad. All rights reserved.
//

#import "AppDelegate.h"
#import "SSZipArchive.h"

@interface AppDelegate () <SSZipArchiveDelegate>
@end 

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

@end
