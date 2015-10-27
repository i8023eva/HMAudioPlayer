//
//  AppDelegate.m
//  HMAudioPlayer
//
//  Created by lyh on 15/10/27.
//  Copyright © 2015年 lyh. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)applicationDidEnterBackground:(UIApplication *)application {
    //开启后台任务  + Info.plist
    UIBackgroundTaskIdentifier ID = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:ID];
    }];
}

@end
