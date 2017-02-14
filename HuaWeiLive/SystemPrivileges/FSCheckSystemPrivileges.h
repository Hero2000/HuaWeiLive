//
//  FSCheckSystemPrivileges.h
//  7nujoom
//
//  Created by 王明 on 16/6/29.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSSystemPrivilegesHeader.h"
#import <UIKit/UIKit.h>
#import "SharedLanguages.h"

@interface FSCheckSystemPrivileges : NSObject<UIAlertViewDelegate>

- (void)checkPrivileges:(CheckPermissionResult)result;
- (BOOL)checkLocationPrivilegesCheck;

@end
