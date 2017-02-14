//
//  FSSelectResolutionview.h
//  HuaWeiLive
//
//  Created by 王明 on 2017/2/9.
//  Copyright © 2017年 王明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSSelectResolutionviewDelegate <NSObject>

- (void)FSSelectResolutionview:(NSString *)resolution  bitrate:(NSString *)biteRate;

@end

@interface FSSelectResolutionview : UIView

@property (nonatomic, weak) id<FSSelectResolutionviewDelegate> delegate;

- (void)show;


@end
