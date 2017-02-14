//
//  FSCheckCameraPrivileges.m
//  7nujoom
//
//  Created by 王明 on 16/6/29.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import "FSCheckCameraPrivileges.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>


@implementation FSCheckCameraPrivileges

- (void)checkPrivileges:(CheckPermissionResult)result {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            //isAvailable = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *message = [SharedLanguages CustomLocalizedStringWithKey:@"CameraControll"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Tips"] message:message delegate:self cancelButtonTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Cancel"] otherButtonTitles:[SharedLanguages CustomLocalizedStringWithKey:@"Sure"], nil];
                [alert show];
            });
            if (result) {
                result(NO);
            }
            
        }
        else if (authStatus == AVAuthorizationStatusNotDetermined) {
            //第一次使用
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if (result) {
                    result(granted);
                }
            }];
        }
        else {
            if (result) {
                result(YES);
            }
            
        }
    }
}

#pragma mark - FSNewestAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
