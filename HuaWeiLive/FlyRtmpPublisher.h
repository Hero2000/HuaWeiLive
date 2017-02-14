//
//  FlyRtmpPublisher.h
//  FlyRtmpPlayerEngine
//
//  Created by ShawnFeng on 16/12/1.
//  Copyright © 2016年 djy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    KPublishSucc = 0,
    KPublishStart,
    KPublishStop,
    KPublishError
}FlyPublishStatus;

@protocol FlyPublishListener

-(void) recorderStatusChanged:(FlyPublishStatus)status intValue:(int)value;

@end

@interface FlyRtmpPublisher : NSObject

-(instancetype)init;
-(void)dealloc;
-(BOOL)start;
-(void)stop;
-(void)sendARGBData:(uint8_t *)imageFrameBuffer size:(CGSize)size;
-(void)sendARGBData:(uint8_t *)imageFrameBuffer;
-(void)sendYUVData:(uint8_t *)pY pCb:(uint8_t *)pCb pCr:(uint8_t *)pCr size:(CGSize)size;
-(void)recvEngineEvent:(int)evt eventValue:(int)value;

-(int)getFPS;
-(double)getBW;

-(void)setAudioSampleRate:(int)sampeRate;
-(void)setAacBitrate:(int)bitrate;
//range: [0-10], recommend [4-6]
-(void)setVideoQuality:(int)quality;
-(BOOL)isRunning;

//Step 2, set url and event listener
@property (nonatomic, retain)NSString* rtmpUrlWithParam;
@property (nonatomic, assign)id<FlyPublishListener> eventListener;
@property (nonatomic, assign)CGSize frameSize;

@end
