//
//  FSSelectRoomIdView.h
//  HuaWeiLive
//
//  Created by 王明 on 2017/2/9.
//  Copyright © 2017年 王明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSSelectRoomIdViewDelegate <NSObject>

- (void)FSSelectRoomIdView:(NSString *)roomName;

@end

@interface FSSelectRoomIdView : UIView

@property (nonatomic, weak) id<FSSelectRoomIdViewDelegate> delegate;

- (void)show;

@end
