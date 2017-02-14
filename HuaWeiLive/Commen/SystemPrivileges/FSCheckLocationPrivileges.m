//
//  FSCheckLocationPrivileges.m
//  7nujoom
//
//  Created by 王明 on 16/6/29.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import "FSCheckLocationPrivileges.h"
#import <CoreLocation/CoreLocation.h>

@interface FSCheckLocationPrivileges()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation FSCheckLocationPrivileges

- (instancetype)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return self;
}

- (void)checkPrivileges:(CheckPermissionResult)result {
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled] &&
        !([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)) {
        //开始定位用户的位置
        if (result) {
            result(YES);
        }
        
        // [_locationManager requestAlwaysAuthorization];
    }
    else{//不能定位用户的位置
        //1.提醒用户检查当前的网络状况
        //2.提醒用户打开定位开关
        if (result) {
            result(NO);
        }
        NSString *message = nil;
//        if(AR == 1){
//            message = [SharedLanguages CustomLocalizedStringWithKey:@"RequestLocationRightAR"];
//        }else if (TR == 1){
//            message = [SharedLanguages CustomLocalizedStringWithKey:@"RequestLocationRightTR"];
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            FSNewestAlertView *alertView = [[FSNewestAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenF.size.width, ScreenF.size.height) title:nil message:message cancelButton:nil buttonImageArray:nil otherButtons:[SharedLanguages CustomLocalizedStringWithKey:@"RequestSystemPrivilegesSetText"],[SharedLanguages CustomLocalizedStringWithKey:@"RequestSystemPrivilegesCancelText"],nil];
//            alertView.delegate = self;
//            alertView.tag = 1003;
//            [alertView showView];
//        });
    }

}

- (BOOL)checkLocationPrivilegesCheck {
    
    [super checkLocationPrivilegesCheck];
    
    if ([CLLocationManager locationServicesEnabled] &&
        !([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)) {
        //开始定位用户的位置
        return YES;
        
        // [_locationManager requestAlwaysAuthorization];
    }
    else{//不能定位用户的位置
        //1.提醒用户检查当前的网络状况
        //2.提醒用户打开定位开关
        return NO;
        
        
    }
}

#pragma mark - FSNewestAlertViewDelegate
//- (void)FSNewestAlertView:(FSNewestAlertView *)alertView didSelectButtonIndex:(NSInteger)index {
//    if (index == 1) {
//        //跳转到系统设置的其他界面
//        NSURL * url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
//        if([[UIApplication sharedApplication] canOpenURL:url]) {
//            
//            [[UIApplication sharedApplication] openURL:url];
//        }
//        else {
//            NSLog(@"canOpenURL");
//            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            
//            if([[UIApplication sharedApplication] canOpenURL:url]) {
//                
//                [[UIApplication sharedApplication] openURL:url];
//            }
//        }
//    }
//}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                
                [self.locationManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
                [self.locationManager requestAlwaysAuthorization];
                
            }
            break;
        default:
            break;
            
            
    }
}


@end
