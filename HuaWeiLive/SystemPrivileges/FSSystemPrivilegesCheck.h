//
//  FSSystemPrivilegesCheck.h
//  7nujoom
//
//  Created by 王明 on 16/6/22.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSSystemPrivilegesFactory.h"
#import "FSCheckSystemPrivileges.h"


//typedef void (^CheckPermissionResult)(BOOL granted);

@interface FSSystemPrivilegesCheck : NSObject
{
    FSSystemPrivilegesFactory *_privilegesFactory;
    FSCheckSystemPrivileges *_checkSystemPrivileges;
}

+(FSSystemPrivilegesCheck *)sharedInstance;
/**
 *  单个权限检测
 *
 *  @param privilegesType 权限类型
 *  @param response       检测结果
 */
-(void)checkSourceTypeAvailable:(FSSystemPrivilegesType)privilegesType result:(CheckPermissionResult)response;
/**
 *  批量权限检测
 *
 *  @param privilegesTypeArray 权限数组
 *  @param response            检测结果，只有全都被授权才会返回YES
 */
-(void)checkSourceTypeArrayAvailable:(NSArray *)privilegesTypeArray result:(CheckPermissionResult)response;

- (BOOL)checkLocationPrivilegesCheck;
- (void)requestLocationPrivileges;

@end
