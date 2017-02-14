//
//  FSRtmpMovieWriter.m
//  7nujoom
//
//  Created by ShawnFeng on 16/12/1.
//  Copyright © 2016年 Fission. All rights reserved.
//

#import "FSRtmpMovieWriter.h"

@implementation FSRtmpMovieWriter
{
    FlyRtmpPublisher *_publisher;
    dispatch_queue_t _sendQueue;
    BOOL _stopSend;
    uint8_t *sendBuffer;
    uint8_t *sendBufferCache;
    NSLock *sendBufferLock;
    dispatch_semaphore_t semaphore;
    dispatch_semaphore_t sendSemaphore;
    
    CGSize frameSize;
    GLProgram *filterProgram;
    CMTime _frameTime;
}

-(instancetype)initWithLiveSize:(CGSize)liveSize
{
    self = [super init];
    if(self) {
        _publisher = [[FlyRtmpPublisher alloc] init];
        [_publisher setEventListener:self];
        [_publisher setFrameSize:liveSize];
        [_publisher setAudioSampleRate:22050];
        [_publisher setAacBitrate:64000]; //64kbit/s
        frameSize = liveSize;
        self.enabled = YES;
        _sendQueue = dispatch_queue_create("rtmp send queue", DISPATCH_QUEUE_SERIAL);
        sendBufferLock = [[NSLock alloc] init];
        semaphore = dispatch_semaphore_create(1);
        sendSemaphore = dispatch_semaphore_create(2);
//        [_movieWriterContext useSharegroup:[[[GPUImageContext sharedImageProcessingContext] context] sharegroup]];
    }
    return self;
}

-(void)dealloc
{
    [self stopSendThread];
#if !OS_OBJECT_USE_OBJC
    if(semaphore != NULL) {
        dispatch_release(semaphore);
    }
    
    if(sendSemaphore != NULL) {
        dispatch_release(sendSemaphore);
    }
#endif
}

-(BOOL)start
{
    if([_publisher start]) {
        [self startSendThread];
        return YES;
    }
    
    return NO;
}

-(void)stop
{
    [self stopSendThread];
    [_publisher stop];
}

-(int) getFPS
{
    return [_publisher getFPS];
}

-(double) getBW
{
    return [_publisher getBW];
}

-(void) setRtmpUrlWithParam:(NSString *)rtmpUrlWithParam
{
    [_publisher setRtmpUrlWithParam:rtmpUrlWithParam];
}

-(NSString *) rtmpUrlWithParam
{
    return [_publisher rtmpUrlWithParam];
}

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex
{
    if (![_publisher isRunning])
    {
        [firstInputFramebuffer unlock];
        return;
    }
    
    if(dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW) == 0) {
        static const GLfloat imageVertices[] = {
            -1.0f, -1.0f,
            1.0f, -1.0f,
            -1.0f,  1.0f,
            1.0f,  1.0f,
        };
        
        _frameTime = frameTime;
        [self renderToTextureWithVertices:imageVertices textureCoordinates:[[self class] textureCoordinatesForRotation:inputRotation]];
        
        [self setSendBuffer];
//        dispatch_async([_movieWriterContext contextQueue], ^{
//            [_publisher sendARGBData:frame size:inputSize];
//            free(frame);
//            dispatch_semaphore_signal(semaphore);
//        });
    }
//    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
//    NSLog(@"FSRtmpMovieWriter newFrameReadyAtTime start:%f end:%f spend:%f", start, end, end - start);
    
}


-(void) recorderStatusChanged:(FlyPublishStatus)status intValue:(int)value
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(publishStatusChanged:intValue:)]){
        [self.delegate publishStatusChanged:status intValue:value];
    }
}


BOOL _hasSendBuffer;
-(void)startSendThread
{
    _stopSend = NO;
    _hasSendBuffer = NO;
    dispatch_async(_sendQueue, ^{
        while(!_stopSend) {
            if(!_hasSendBuffer) {
                usleep(10000);
                continue;
            }
            
            uint8_t *bytes = [outputFramebuffer byteBuffer];
            [_publisher sendARGBData:bytes size:frameSize];
            [super informTargetsAboutNewFrameAtTime:_frameTime];
            _hasSendBuffer = NO;
            dispatch_semaphore_signal(semaphore);
        }
    });
}

-(void)stopSendThread
{
    _stopSend = YES;
}

-(void)setSendBuffer
{
//    sendBuffer = buffer;
//    dispatch_semaphore_signal(sendSemaphore);
    _hasSendBuffer = YES;
}

@end
