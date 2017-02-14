//
//  FlyRtmpRecorder.h
//  FlyRtmpPlayerEngine
//
//  Created by Dong Junyi on 13-4-27.
//  Copyright (c) 2013年 djy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define CAMERA_DEFAULT  AVCaptureDevicePositionUnspecified
#define CAMERA_BACK     AVCaptureDevicePositionBack
#define CAMERA_FRONT    AVCaptureDevicePositionFront

typedef enum{
    KRecorderSucc = 0,
    KRecorderStart,
    KRecorderStop,
    KRecorderError,
    KRecorderPause,
    KRecorderResume
}FlyRecorderStatus;

@protocol FlyRecorderListener

@required
-(void) recorderStatusChanged:(FlyRecorderStatus)status intValue:(int)value;

@end

@interface FlyRtmpRecorder : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

//Help method if you want to put player and recorder in the same view
+(BOOL) openAudioSessionForPlayAndRecord;
+(BOOL) releaseAudioSessionForPlayAndRecord;

-(id) init;
-(id) initWithSpec:(int)spec;
-(void) dealloc;

//Step 1, create a view for display video
-(UIView*) createPreviewView:(CGRect)rect;

//Experimental function
-(void) enableRecordToFile:(NSString*)filename;

//Step 3, start recording
-(BOOL) startPreview;
-(void) stopPreview;
-(BOOL) start;
-(void) stop;

//[[Internally used methods
-(void) recvEngineEvent:(int)evt eventValue:(int)value;
//Internal end]]

-(int) getFPS;
-(double) getBW;
-(void) turnOnPreview;
-(void) turnOffPreview;
-(void) setAutoFocus:(BOOL)enable;
-(void) setAutoWhiteBalance:(BOOL)enable;
-(void) setAutoExposure:(BOOL)enable;
-(void) setAudioSampleRate:(int)sampeRate;
-(void) setAacBitrate:(int)bitrate;
//range: [0-10], recommend [4-6]
-(void) setVideoQuality:(int)quality;

//Step 2, set url and event listener
@property (nonatomic, retain)NSString* rtmpUrlWithParam;
@property (nonatomic, assign)id<FlyRecorderListener> eventListener;

//Optional attributes
@property (nonatomic, assign)NSInteger videoOrientation;
@property (nonatomic, assign)NSInteger cameraPosition;

@property (nonatomic, assign)BOOL audioOnly;

@end
