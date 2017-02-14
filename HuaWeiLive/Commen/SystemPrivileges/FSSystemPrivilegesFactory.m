//
//  FSSystemPrivilegesFactory.m
//  7nujoom
//
//  Created by 王明 on 16/6/29.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import "FSSystemPrivilegesFactory.h"
#import "FSCheckCameraPrivileges.h"
#import "FSCheckAudioPrivileges.h"
#import "FSCheckLocationPrivileges.h"

@implementation FSSystemPrivilegesFactory

- (FSCheckSystemPrivileges *)factoryMethod:(FSSystemPrivilegesType)type {
    
    if (type == FSSystemPrivilegesTypeCamera) {
        return [[FSCheckCameraPrivileges alloc] init];
    }
    else if (type == FSSystemPrivilegesTypeAudio) {
        return [[FSCheckAudioPrivileges alloc] init];
    }
    else if (type == FSSystemPrivilegesTypeLocation) {
        return [[FSCheckLocationPrivileges alloc] init];
    }
    return nil;
}

@end
