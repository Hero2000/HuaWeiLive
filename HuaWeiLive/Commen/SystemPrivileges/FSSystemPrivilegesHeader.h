//
//  FSSystemPrivilegesHeader.h
//  7nujoom
//
//  Created by 王明 on 16/6/29.
//  Copyright © 2016年 Fission. All rights reserved.
//

#ifndef FSSystemPrivilegesHeader_h
#define FSSystemPrivilegesHeader_h

typedef NS_ENUM(NSUInteger,FSSystemPrivilegesType)  {
    FSSystemPrivilegesTypeCamera = 1,
    FSSystemPrivilegesTypeAudio = 2,
    FSSystemPrivilegesTypeLocation = 3,
};

#define BV_Exception_Format @"在%@的子类中必须voerride:%@方法"
typedef void (^CheckPermissionResult)(BOOL granted);

#endif /* FSSystemPrivilegesHeader_h */
