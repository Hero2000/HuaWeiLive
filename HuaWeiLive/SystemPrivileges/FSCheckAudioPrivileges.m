//
//  FSCheckAudioPrivileges.m
//  7nujoom
//
//  Created by 王明 on 16/6/29.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import "FSCheckAudioPrivileges.h"
#import <AVFoundation/AVFoundation.h>

@implementation FSCheckAudioPrivileges

- (void)checkPrivileges:(CheckPermissionResult)result {
    //第一次调用这个方法的时候，系统会提示用户让他同意你的app获取麦克风的数据
    // 其他时候调用方法的时候，则不会提醒用户
    // 而会传递之前的值来要求用户同意
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (result) {
            result(granted);
        }
        
        if (granted) {
            // 用户同意获取数据
            
        } else {
            // 可以显示一个提示框告诉用户这个app没有得到允许？
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *message = [SharedLanguages CustomLocalizedStringWithKey:@"MicrophoneControll"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Tips"] message:message delegate:self cancelButtonTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Cancel"] otherButtonTitles:[SharedLanguages CustomLocalizedStringWithKey:@"Sure"], nil];
                [alert show];
                
            });
            
        }
    }];
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
