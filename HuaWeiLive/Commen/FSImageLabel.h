//
//  FSImageLabel.h
//  7nujoom
//
//  Created by 王明 on 16/9/28.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSImageLabel : UIControl

@property (nonatomic, strong) NSString *textLabelString;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;

- (void)resetFrame;

@end
