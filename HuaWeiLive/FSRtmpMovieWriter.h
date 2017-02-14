//
//  FSRtmpMovieWriter.h
//  7nujoom
//
//  Created by ShawnFeng on 16/12/1.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "GPUImage.h"
#import "FlyRtmpPublisher.h"

@protocol FSRtmpMovieWriterDelegate <NSObject>

- (void)publishStatusChanged:(FlyPublishStatus)status intValue:(int)value;

@end

@interface FSRtmpMovieWriter : GPUImageFilter <FlyPublishListener>

@property(nonatomic, assign) id<FSRtmpMovieWriterDelegate> delegate;

-(instancetype)initWithLiveSize:(CGSize)liveSize;
-(BOOL)start;
-(void)stop;
-(int) getFPS;
-(double) getBW;

@property (nonatomic, retain)NSString* rtmpUrlWithParam;
@property(nonatomic) BOOL enabled;

@end
