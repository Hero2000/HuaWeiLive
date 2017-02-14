//
//  FSImageLabel.m
//  7nujoom
//
//  Created by 王明 on 16/9/28.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import "FSImageLabel.h"

@implementation FSImageLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //[self initBaseUI];
        _textLabel = [[UILabel alloc] init];
        [self addSubview:_textLabel];
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)resetFrame {
    [self.textLabel sizeToFit];

    self.textLabel.frame = CGRectMake((self.frame.size.width-self.imageView.frame.size.width-self.textLabel.frame.size.width)/2, 0, self.textLabel.frame.size.width, self.frame.size.height);
    self.imageView.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame), self.frame.size.height/2-self.imageView.image.size.height/2, self.imageView.image.size.width, self.imageView.image.size.height);
    
}

@end
