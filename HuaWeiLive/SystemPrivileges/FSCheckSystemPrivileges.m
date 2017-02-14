//
//  FSCheckSystemPrivileges.m
//  7nujoom
//
//  Created by 王明 on 16/6/29.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import "FSCheckSystemPrivileges.h"

@implementation FSCheckSystemPrivileges

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)checkPrivileges:(CheckPermissionResult)result {
    result(NO);
    if ([self isMemberOfClass:[FSCheckSystemPrivileges class]]) {
        NSLog(@"FSCheckSystemPrivileges");
    }
    else {
        [NSException raise:NSInternalInconsistencyException format:BV_Exception_Format,[NSString stringWithUTF8String:object_getClassName(self)],NSStringFromSelector(_cmd)];
    }
}

- (BOOL)checkLocationPrivilegesCheck {
    return NO;
}


@end
