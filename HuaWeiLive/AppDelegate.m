//
//  AppDelegate.m
//  HuaWeiLive
//
//  Created by 王明 on 2017/2/8.
//  Copyright © 2017年 王明. All rights reserved.
//

#import "AppDelegate.h"
#import "RealReachability.h"
#import "SharedLanguages.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSInteger time = [self compareNowWithDate:@"2017-03-01"];
    if (time == 0 || time == -1) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        
        [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            window.alpha = 0;
            window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
        } completion:^(BOOL finished) {
            exit(0);
        }];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; 
    [GLobalRealReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
    
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"RoomAddress"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"RoomName"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"VideoAddress"];
    [[NSUserDefaults standardUserDefaults] setValue:@"960x540" forKey:@"Resolution"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    return YES;
}

- (NSInteger)compareNowWithDate:(NSString*)bDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate *dta = [NSDate date];
    NSDate *dtb = [[NSDate alloc] init];
    
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //        相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result==NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}

- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    NSLog(@"currentStatus:%@",@(status));
    if (status == RealStatusNotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Tips"] message:[SharedLanguages CustomLocalizedStringWithKey:@"BadNetWork"] delegate:nil cancelButtonTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Sure"] otherButtonTitles: nil];
        [alert show];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNSNotificationIponeResignAtivic" object:nil];

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNSNotificationInhoneDidBecomeActive" object:nil];

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
