//
//  FSSystemShareManage.h
//  7nujoom
//
//  Created by 王明 on 16/6/24.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ShareResult)(BOOL isSucceed, NSString *type);

@interface FSSystemShareManage : NSObject

+ (void)fsSystemShareViewShowWithContent:(NSString *)shareContent image:(UIImage *)shareImage url:(NSURL *)shareUrl fromController:(UIViewController *)viewController result:(ShareResult)shareResult;

@end
