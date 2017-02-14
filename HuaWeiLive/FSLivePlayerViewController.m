//
//  FSLivePlayerViewController.m
//  HuaWeiLive
//
//  Created by 王明 on 2017/2/8.
//  Copyright © 2017年 王明. All rights reserved.
//

#import "FSLivePlayerViewController.h"
#import "FlyRtmpRecorder.h"
#import "SharedLanguages.h"

@interface FSLivePlayerViewController ()<FlyRecorderListener>

@property (nonatomic,strong)  FlyRtmpRecorder *RtmpRecoder;
@property (nonatomic, assign) BOOL running;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *revertCameraButton;
@property (nonatomic, strong) UIButton *videorecordButton;
@property (nonatomic, strong) UIButton *liveSwitchButton;
@property (nonatomic, strong) UILabel *fpsLabel;
@property(nonatomic,strong)NSTimer *postFPSTimer;
@property(nonatomic,strong)NSTimer *liveTimeTimer;
@property(nonatomic,assign)BOOL recorderStarted;
@property(nonatomic,strong)UIView        *previewView;
@property (nonatomic, strong) UILabel *liveTimeLabel;
@property (nonatomic, assign) int hour;
@property (nonatomic, assign) int mimute;
@property (nonatomic, assign) int second;
@property (nonatomic, strong) UILabel *roomIdLabel;

@end

@implementation FSLivePlayerViewController

- (void)dealloc {
    if(_postFPSTimer){
        [_postFPSTimer invalidate];
        _postFPSTimer = nil;
    }
    
    if (_liveTimeTimer) {
        [_liveTimeTimer invalidate];
        _liveTimeTimer = nil;
    }
    
    if(_RtmpRecoder){
        [_RtmpRecoder turnOffPreview];
        [_RtmpRecoder setEventListener:nil];
        [_RtmpRecoder stopPreview];
        [_RtmpRecoder stop];
        _RtmpRecoder = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kNSNotificationIponeResignAtivic" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kNSNotificationInhoneDidBecomeActive" object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.clipsToBounds = YES;
    
    _hour = 0;
    _mimute = 0;
    _second = 0;
    
    [self initRecorderView:self.view.bounds];
    [self startPreViewRecord];
    
    [self initBaseUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackGroundWhenRecordVideo) name:@"kNSNotificationIponeResignAtivic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterForeGroundWhenRecordVideo) name:@"kNSNotificationInhoneDidBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

}

- (void)initBaseUI {
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(20, 20, 57/2, 57/2);
    _backButton.backgroundColor = [UIColor clearColor];
//    _backButton.layer.cornerRadius = 57/4;
//    _backButton.layer.masksToBounds = YES;
    [_backButton setImage:[UIImage imageNamed:@"Right"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    _revertCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _revertCameraButton.frame = CGRectMake(CGRectGetMaxX(_backButton.frame)+15, 20, 57/2, 57/2);
    _revertCameraButton.backgroundColor = [UIColor clearColor];
//    _revertCameraButton.layer.cornerRadius = 57/4;
//    _revertCameraButton.layer.masksToBounds = YES;
    [_revertCameraButton setImage:[UIImage imageNamed:@"zhibojian_camer_btn"] forState:UIControlStateNormal];
    [_revertCameraButton addTarget:self action:@selector(revertCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_revertCameraButton];
    
    _videorecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _videorecordButton.frame = CGRectMake(CGRectGetMaxX(_revertCameraButton.frame)+15, 20, 57/2, 57/2);
    _videorecordButton.backgroundColor = [UIColor clearColor];
//    _videorecordButton.layer.cornerRadius = 20;
//    _videorecordButton.layer.masksToBounds = YES;
    [_videorecordButton setImage:[UIImage imageNamed:@"liveicon"] forState:UIControlStateNormal];
    [_videorecordButton addTarget:self action:@selector(videorecordClick) forControlEvents:UIControlEventTouchUpInside];
    _videorecordButton.hidden = YES;
    [self.view addSubview:_videorecordButton];
    
    _liveTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_revertCameraButton.frame)+10, 20, 100, 57/2)];
    _liveTimeLabel.backgroundColor = [UIColor clearColor];
    _liveTimeLabel.textColor = [UIColor whiteColor];
    _liveTimeLabel.textAlignment = NSTextAlignmentLeft;
    _liveTimeLabel.text = @"00:00:00";
    [self.view addSubview:_liveTimeLabel];
    
    _liveSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _liveSwitchButton.frame = CGRectMake(self.view.frame.size.width-20-90, 20, 90, 57/2);
    _liveSwitchButton.backgroundColor = [UIColor redColor];
    _liveSwitchButton.layer.cornerRadius = 57/4;
    _liveSwitchButton.layer.masksToBounds = YES;
    [_liveSwitchButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    if ([[SharedLanguages AppUsedLanguage] isEqualToString:@"en"]) {
        [_liveSwitchButton setImage:[UIImage imageNamed:@"start-en"] forState:UIControlStateNormal];
    }
    else {
        [_liveSwitchButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];

    }
    [_liveSwitchButton addTarget:self action:@selector(liveSwitchClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_liveSwitchButton];
    
    _fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20-100, self.view.frame.size.height-20-30, 100, 30)];
    _fpsLabel.backgroundColor = [UIColor clearColor];
    _fpsLabel.textColor = [UIColor redColor];
    _fpsLabel.textAlignment = NSTextAlignmentRight;
    _fpsLabel.text = @"0/s";
    [self.view addSubview:_fpsLabel];
    
    _roomIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-20-30, 100, 30)];
    _roomIdLabel.backgroundColor = [UIColor clearColor];
    _roomIdLabel.textColor = [UIColor redColor];
    _roomIdLabel.textAlignment = NSTextAlignmentLeft;
    _roomIdLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"RoomName"];
    [self.view addSubview:_roomIdLabel];
    
   // [self orientChange:nil];
}

- (void)orientChange:(NSNotification *)noti {
    NSLog(@"%ld",(long)[UIDevice currentDevice].orientation);
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        _backButton.transform = CGAffineTransformIdentity;
        _backButton.transform = CGAffineTransformMakeRotation(M_PI/2);
        _revertCameraButton.transform = CGAffineTransformIdentity;
        _revertCameraButton.transform = CGAffineTransformMakeRotation(M_PI/2);
        _videorecordButton.transform = CGAffineTransformIdentity;
        _videorecordButton.transform = CGAffineTransformMakeRotation(M_PI/2);
        _liveTimeLabel.transform = CGAffineTransformIdentity;
        _liveTimeLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        _liveSwitchButton.transform = CGAffineTransformIdentity;
        _liveSwitchButton.transform = CGAffineTransformMakeRotation(M_PI/2);
        _fpsLabel.transform = CGAffineTransformIdentity;
        _fpsLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        _roomIdLabel.transform = CGAffineTransformIdentity;
        _roomIdLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        
        _backButton.frame = CGRectMake(self.view.frame.size.width-20-57/2, 20, 57/2, 57/2);
        _revertCameraButton.frame = CGRectMake(self.view.frame.size.width-20-57/2, CGRectGetMaxY(_backButton.frame)+15, 57/2, 57/2);
        _videorecordButton.frame = CGRectMake(self.view.frame.size.width-20-57/2, CGRectGetMaxY(_revertCameraButton.frame)+15, 57/2, 57/2);
        _liveTimeLabel.frame = CGRectMake(self.view.frame.size.width-20-57/2, CGRectGetMaxY(_revertCameraButton.frame)+10, 57/2, 100);
        _liveSwitchButton.frame = CGRectMake(self.view.frame.size.width-20-57/2, self.view.frame.size.height-20-90, 57/2, 90);
        _fpsLabel.frame = CGRectMake(20, self.view.frame.size.height-20-100, 30, 100);
        _roomIdLabel.frame = CGRectMake(20, 20, 30, 100);
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    }
    else if (orientation == UIDeviceOrientationLandscapeRight) {
        _backButton.transform = CGAffineTransformIdentity;
        _backButton.transform = CGAffineTransformMakeRotation(-M_PI/2);
        _revertCameraButton.transform = CGAffineTransformIdentity;
        _revertCameraButton.transform = CGAffineTransformMakeRotation(-M_PI/2);
        _videorecordButton.transform = CGAffineTransformIdentity;
        _videorecordButton.transform = CGAffineTransformMakeRotation(-M_PI/2);
        _liveTimeLabel.transform = CGAffineTransformIdentity;
        _liveTimeLabel.transform = CGAffineTransformMakeRotation(-M_PI/2);
        _liveSwitchButton.transform = CGAffineTransformIdentity;
        _liveSwitchButton.transform = CGAffineTransformMakeRotation(-M_PI/2);
        _fpsLabel.transform = CGAffineTransformIdentity;
        _fpsLabel.transform = CGAffineTransformMakeRotation(-M_PI/2);
        _roomIdLabel.transform = CGAffineTransformIdentity;
        _roomIdLabel.transform = CGAffineTransformMakeRotation(-M_PI/2);
        
        _backButton.frame = CGRectMake(20, self.view.frame.size.height-20-57/2, 57/2, 57/2);
        _revertCameraButton.frame = CGRectMake(20, CGRectGetMinY(_backButton.frame)-15-57/2, 57/2, 57/2);
        _videorecordButton.frame = CGRectMake(20, CGRectGetMinY(_revertCameraButton.frame)-15-57/2, 57/2, 57/2);
        _liveTimeLabel.frame = CGRectMake(20, CGRectGetMinY(_revertCameraButton.frame)-10-100, 57/2, 100);

        _liveSwitchButton.frame = CGRectMake(20, 20, 57/2, 100);
        _fpsLabel.frame = CGRectMake(self.view.frame.size.width -20-30, 20, 30, 100);
        _roomIdLabel.frame = CGRectMake(self.view.frame.size.width -20-30, self.view.frame.size.height -20-100, 30, 100);
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
    }
    else {
        _backButton.transform = CGAffineTransformIdentity;
        _backButton.transform = CGAffineTransformMakeRotation(M_PI*2);
        _revertCameraButton.transform = CGAffineTransformIdentity;
        _revertCameraButton.transform = CGAffineTransformMakeRotation(M_PI*2);
        _videorecordButton.transform = CGAffineTransformIdentity;
        _videorecordButton.transform = CGAffineTransformMakeRotation(M_PI*2);
        _liveTimeLabel.transform = CGAffineTransformIdentity;
        _liveTimeLabel.transform = CGAffineTransformMakeRotation(M_PI*2);
        _liveSwitchButton.transform = CGAffineTransformIdentity;
        _liveSwitchButton.transform = CGAffineTransformMakeRotation(M_PI*2);
        _fpsLabel.transform = CGAffineTransformIdentity;
        _fpsLabel.transform = CGAffineTransformMakeRotation(M_PI*2);
        _roomIdLabel.transform = CGAffineTransformIdentity;
        _roomIdLabel.transform = CGAffineTransformMakeRotation(M_PI*2);
        
        _backButton.frame = CGRectMake(20, 20, 57/2, 57/2);
        _revertCameraButton.frame = CGRectMake(CGRectGetMaxX(_backButton.frame)+15, 20, 57/2, 57/2);
        _videorecordButton.frame = CGRectMake(CGRectGetMaxX(_revertCameraButton.frame)+15, 20, 57/2, 57/2);
        _liveTimeLabel.frame = CGRectMake(CGRectGetMaxX(_revertCameraButton.frame)+10, 20, 100, 57/2);
        _liveSwitchButton.frame = CGRectMake(self.view.frame.size.width-20-100, 20, 100, 57/2);
        _fpsLabel.frame = CGRectMake(self.view.frame.size.width-20-100, self.view.frame.size.height-20-30, 100, 30);
        _roomIdLabel.frame = CGRectMake(20, self.view.frame.size.height-20-30, 100, 30);
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortraitUpsideDown];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backClick {
    _recorderStarted = NO;
    [self stopRecordVideo];
    
    [self stopPreViewRecord];
    
    if(_postFPSTimer){
        [_postFPSTimer invalidate];
        _postFPSTimer = nil;
    }
    if (_liveTimeTimer) {
        [_liveTimeTimer invalidate];
        _liveTimeTimer = nil;
    }
    if(_RtmpRecoder){
        [_RtmpRecoder turnOffPreview];
        [_RtmpRecoder setEventListener:nil];
        [_RtmpRecoder stopPreview];
        [_RtmpRecoder stop];
        _RtmpRecoder = nil;
    }
    
    [self.navigationController popViewControllerAnimated:YES];

    
}

- (void)liveSwitchClick{
    _liveSwitchButton.userInteractionEnabled = NO;
    if (_running) {
        _recorderStarted = NO;
        [self stopRecordVideo];
        if (_liveTimeTimer) {
            [_liveTimeTimer setFireDate:[NSDate distantFuture]];
        }
    }
    else {
        NSString *url = [[NSUserDefaults standardUserDefaults] valueForKey:@"RoomAddress"];
        [self setRecoderUrl:url];
        [_liveSwitchButton setImage:nil forState:UIControlStateNormal];
        [_liveSwitchButton setTitle:[SharedLanguages CustomLocalizedStringWithKey:@"StartLiving"] forState:UIControlStateNormal];

    }
}

- (void)videorecordClick {

}

-(void)postFPSReportTimer{
    int fps = _RtmpRecoder.getFPS;
    int bw = ceilf(_RtmpRecoder.getBW);
    NSLog(@"--- fps:%d --- bw:%f ---",fps,bw);
    
    _fpsLabel.text = [NSString stringWithFormat:@"%dK/s",bw];
}

-(void)initRecorderView:(CGRect)frame
{
    if(_RtmpRecoder == nil){
        NSString *resolution = [[NSUserDefaults standardUserDefaults] valueForKey:@"Resolution"];
        int VIDEO_FPS, VIDEO_WIDTH, VIDEO_HEIGHT, CRF, BITRATE, spec;
        if ([resolution isEqualToString:@"960x540"]) {
            VIDEO_FPS = 25;
            VIDEO_WIDTH = 540;
            VIDEO_HEIGHT = 960;
            CRF = 25;
            BITRATE = 1200;
            spec = 0;
        } else if ([resolution isEqualToString:@"640x360(标)"] || [resolution isEqualToString:@"640x360(normal)"]) {
            VIDEO_FPS = 25;
            VIDEO_WIDTH = 360;
            VIDEO_HEIGHT = 640;
            CRF = 28;
            BITRATE = 800;
            spec = 1;
        } else if ([resolution isEqualToString:@"640x360(低)"] || [resolution isEqualToString:@"640x360(low)"]) {
            VIDEO_FPS = 25;
            VIDEO_WIDTH = 360;
            VIDEO_HEIGHT = 640;
            CRF = 32;
            BITRATE = 400;
            spec = 2;
        }
        
        _RtmpRecoder = [[FlyRtmpRecorder alloc] initWithSpec:spec];
        [_RtmpRecoder setEventListener:self];
        [_RtmpRecoder setVideoOrientation:AVCaptureVideoOrientationPortrait];
        [_RtmpRecoder setAudioSampleRate:22050];
        [_RtmpRecoder setAacBitrate:64000]; //64kbit/s
        [_RtmpRecoder setAutoWhiteBalance:YES];
        [_RtmpRecoder setAutoExposure:NO];
        [_RtmpRecoder setCameraPosition:AVCaptureDevicePositionFront];
        
        
        CGFloat viewH = CGRectGetHeight(frame);
        CGFloat viewW = viewH *0.75;
        CGFloat viewX = (CGRectGetWidth(frame) - viewW)/2.0;
        CGFloat viewY = (CGRectGetHeight(frame) - viewH)/2.0;
        
        
        CGRect viewRect = CGRectMake(viewX, viewY, viewW, viewH);
        
        if(self.previewView == nil)
            self.previewView = [_RtmpRecoder createPreviewView:viewRect];
        
        [self.view addSubview:self.previewView];
        [self.previewView setBackgroundColor:[UIColor colorWithRed: 0 green:127 blue:127 alpha:1]];
        [self.view bringSubviewToFront:self.previewView];
        [self.previewView setAlpha:0];

        
//        GPUImageView *viewBeautify = [[GPUImageView alloc] initWithFrame:viewRect];
//        [self.view addSubview:viewBeautify];
//        [viewBeautify setBackgroundColor:[UIColor clearColor]];
       // _RtmpRecoder.viewBeautify = viewBeautify;
    }
    
}

-(void)setRecoderUrl:(NSString *)recoderUrl
{
    
    if (recoderUrl == nil) {
        return;
    }
    
    if (self.previewView) {
        [self.previewView setAlpha:1];
    }
    
    if ([recoderUrl hasPrefix:@"rtmp://"]) {
        _RtmpRecoder.rtmpUrlWithParam = recoderUrl;
    }
    else
    {
        NSMutableString* strRtmp = [[NSMutableString alloc] initWithString:@"rtmp://ingress-alt.sympl.tv/live_ch/"];
        [strRtmp appendString:recoderUrl];
        _RtmpRecoder.rtmpUrlWithParam = strRtmp;
    }
    [_RtmpRecoder startPreview];

    [self startRecordVideo];
    
    if(!_postFPSTimer){
        _postFPSTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(postFPSReportTimer) userInfo:nil repeats:YES];
    }
    
}


-(void)startRecordVideo
{
    if (!_running) {
        _running = [_RtmpRecoder start];
    }
    
    if (!_running) {
        _recorderStarted = NO;

    }else
    {
        _recorderStarted = YES;
    }
}
-(void)stopRecordVideo
{
    if (_running) {
        [_RtmpRecoder stop];
    }
}
-(void)revertCamera
{
    if (_RtmpRecoder.cameraPosition == AVCaptureDevicePositionFront) {
        [_RtmpRecoder setCameraPosition:AVCaptureDevicePositionBack];
    }else if (_RtmpRecoder.cameraPosition == AVCaptureDevicePositionBack)
    {
        [_RtmpRecoder setCameraPosition:AVCaptureDevicePositionFront];
    }
}

-(void)startPreViewRecord
{
    if (_RtmpRecoder) {
        [_RtmpRecoder turnOnPreview];
        [self.previewView setAlpha:1];
        [_RtmpRecoder startPreview];
    }
}
-(void)stopPreViewRecord
{
    if (_RtmpRecoder) {
        [_RtmpRecoder turnOffPreview];
        [self.previewView setAlpha:0];
        [_RtmpRecoder stopPreview];
    }
}

#pragma mark - FlyRecorderListener

- (void)recorderStatusChanged:(FlyRecorderStatus)status intValue:(int)value {
    switch (status) {
        case KRecorderStop:
            _running = NO;
            [_liveSwitchButton setTitle:@"" forState:UIControlStateNormal];
            if ([[SharedLanguages AppUsedLanguage] isEqualToString:@"en"]) {
                [_liveSwitchButton setImage:[UIImage imageNamed:@"start-en"] forState:UIControlStateNormal];
            }
            else {
                [_liveSwitchButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
                
            }
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            NSLog(@"recorderStatusChanged =====================KRecorderStop");
            if (_liveTimeTimer) {
                [_liveTimeTimer setFireDate:[NSDate distantFuture]];
            }
            break;
        case KRecorderError:
        {
            _running = NO;
            [_liveSwitchButton setTitle:@"" forState:UIControlStateNormal];
            if ([[SharedLanguages AppUsedLanguage] isEqualToString:@"en"]) {
                [_liveSwitchButton setImage:[UIImage imageNamed:@"start-en"] forState:UIControlStateNormal];
            }
            else {
                [_liveSwitchButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
                
            }
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Tips"] message:[SharedLanguages CustomLocalizedStringWithKey:@"LiveFaild"] delegate:nil cancelButtonTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Sure"] otherButtonTitles: nil];
            [alert show];
            if (_liveTimeTimer) {
                [_liveTimeTimer setFireDate:[NSDate distantFuture]];
            }
            NSLog(@"recorderStatusChanged =====================KRecorderError");
        }
            break;
        case KRecorderPause:
            break;
        case KRecorderResume:
            break;
        case KRecorderStart:
            [_liveSwitchButton setTitle:@"" forState:UIControlStateNormal];
            if ([[SharedLanguages AppUsedLanguage] isEqualToString:@"en"]) {
                [_liveSwitchButton setImage:[UIImage imageNamed:@"stop-en"] forState:UIControlStateNormal];
            }
            else {
                [_liveSwitchButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
                
            }
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            NSLog(@"recorderStatusChanged =====================KRecorderStart");
            if (!_liveTimeTimer) {
                _liveTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLiveTime) userInfo:nil repeats:YES];
            }
            else {
                [_liveTimeTimer setFireDate:[NSDate date]];

            }
            break;
        default:
            break;
    }
    [self startPreViewRecord];
    _liveSwitchButton.userInteractionEnabled = YES;

}
-(void)reconnectRecord
{
}

- (void)updateLiveTime {
    _second++;
    if (_second == 60) {
        _mimute++;
        _second = 0;
        if (_mimute == 60) {
            _hour++;
            _mimute = 0;
        }
    }
    _liveTimeLabel.text = [NSString stringWithFormat:@"%d:%d:%d",_hour,_mimute,_second];
}

// 直播时进入后台
-(void)appEnterBackGroundWhenRecordVideo
{
    if (!_recorderStarted) {
        return;
    }
    
    [self stopRecordVideo];
    
}
// 直播时进入前台
-(void)appEnterForeGroundWhenRecordVideo
{
    if (!_recorderStarted) {
        return;
    }
    
    [self startRecordVideo];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
