//
//  FSSystemPrivilegesFactory.h
//  7nujoom
//
//  Created by 王明 on 16/6/29.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSCheckSystemPrivileges.h"

@interface FSSystemPrivilegesFactory : NSObject

- (FSCheckSystemPrivileges *)factoryMethod:(FSSystemPrivilegesType)type;

@end
