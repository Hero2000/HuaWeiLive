//
//  FSSystemShareManage.m
//  7nujoom
//
//  Created by 王明 on 16/6/24.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import "FSSystemShareManage.h"

@implementation FSSystemShareManage

+ (void)fsSystemShareViewShowWithContent:(NSString *)shareContent image:(UIImage *)shareImage url:(NSURL *)shareUrl fromController:(UIViewController *)viewController result:(ShareResult)shareResult {
    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:0];
    if (shareContent != nil) {
        [contentArray addObject:shareContent];
    }
    if (shareImage != nil) {
        [contentArray addObject:shareImage];
    }
    if (shareUrl != nil) {
        [contentArray addObject:shareUrl];
    }
    
    UIActivityViewController *activeViewController = [[UIActivityViewController alloc]initWithActivityItems:contentArray applicationActivities:nil];
    //不显示哪些分享平台(具体支持那些平台，可以查看Xcode的api)
    [viewController presentViewController:activeViewController animated:YES completion:nil];
    //分享结果回调方法
    UIActivityViewControllerCompletionHandler myblock = ^(NSString *type,BOOL completed){
        NSLog(@"%d %@",completed,type);
        BOOL isSuccess = NO;
        if (completed) {
            isSuccess = YES;
//            [GlobelHttpTool shareRoom:(int)self.roomId shareType:3 isLogin:[[SharedUser SharedUser] Logined] withCallback:^(int errorCode, NSDictionary *datainfo) {
//                
//            }];
        }
        if (shareResult) {
            shareResult(isSuccess,type);
        }
    };
    activeViewController.completionHandler = myblock;
}

@end
