//
//  ViewController.m
//  HuaWeiLive
//
//  Created by 王明 on 2017/2/8.
//  Copyright © 2017年 王明. All rights reserved.
//

#import "ViewController.h"
#import "FSLivePlayerViewController.h"
#import "FSSettingViewController.h"
#import "FSSelectRoomIdView.h"
#import "FSSelectResolutionview.h"
#import "FSImageLabel.h"
#import "FSSystemShareManage.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SharedLanguages.h"
#import "FSSystemPrivilegesCheck.h"
#import "RealReachability.h"

@interface ViewController ()<FSSelectRoomIdViewDelegate, FSSelectResolutionviewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *headView;
@property (strong, nonatomic) IBOutlet UIButton *avatarButton;
@property (strong, nonatomic) IBOutlet UIButton *settingButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (nonatomic, strong) UIImageView *appNameImageView;
@property (nonatomic, strong) UILabel *roomNumLabel;
@property (strong, nonatomic) IBOutlet FSImageLabel *selectRoomButton;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *codeRateImageView;
@property (nonatomic, strong) UILabel *codeRateNumLabel;
@property (nonatomic, strong) UILabel *codeRateNameLabel;
@property (nonatomic, strong) UIImageView *resolutionImageView;
@property (strong, nonatomic) IBOutlet FSImageLabel *selectResolutionButton;
@property (nonatomic, strong) UILabel *resolutionLabel;
@property (strong, nonatomic) IBOutlet UIButton *startLiveButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic ,strong) UIImagePickerController *imgPickerController;
@property (nonatomic, strong) UILabel *versionLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createBaseUI];
}

- (void)createBaseUI {
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 363/2)];
    [_headView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"headimage"]]];
    [self.view addSubview:_headView];
    
//    _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _settingButton.frame = CGRectMake(CGRectGetWidth(_headView.frame)-20-25, 20, 25, 25);
//    _settingButton.backgroundColor = [UIColor lightGrayColor];
//    _settingButton.layer.cornerRadius = 25/2;
//    _settingButton.layer.masksToBounds = YES;
//    [_settingButton setImage:[UIImage imageNamed:@"Settings"] forState:UIControlStateNormal];
//    [_settingButton addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_headView addSubview:_settingButton];
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectMake(CGRectGetWidth(_headView.frame)-20-43/2, 20, 43/2, 21);
    _shareButton.backgroundColor = [UIColor clearColor];
    [_shareButton setImage:[UIImage imageNamed:@"share_open"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_shareButton];
    
    _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _avatarButton.frame = CGRectMake(30, 80, 75, 75);
    _avatarButton.backgroundColor = [UIColor whiteColor];
    _avatarButton.layer.cornerRadius = 75/2;
    _avatarButton.layer.masksToBounds = YES;
    [_avatarButton setImage:[UIImage imageNamed:@"userphotoSmall"] forState:UIControlStateNormal];
    [_avatarButton addTarget:self action:@selector(changeAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_avatarButton];
    
    _roomNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarButton.frame)+15, CGRectGetMinY(_avatarButton.frame), CGRectGetWidth(_headView.frame)-CGRectGetMaxX(_avatarButton.frame)-15-20, 30)];
    _roomNameLabel.backgroundColor = [UIColor clearColor];
    _roomNameLabel.textColor = [UIColor whiteColor];
    _roomNameLabel.font = [UIFont boldSystemFontOfSize:20];
    _roomNameLabel.textAlignment = NSTextAlignmentLeft;
    [_roomNumLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"appname"]]];
    _roomNameLabel.text = @"Envision Live";
    [_headView addSubview:_roomNameLabel];
    
//    _appNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarButton.frame)+15, CGRectGetMinY(_avatarButton.frame), CGRectGetWidth(_headView.frame)-CGRectGetMaxX(_avatarButton.frame)-15-60, 19)];
//    _appNameImageView.image = [UIImage imageNamed:@"appname"];
//    [_headView addSubview:_appNameImageView];

    
    _roomNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_roomNameLabel.frame), CGRectGetMaxY(_roomNameLabel.frame)+10, 60, 15)];
    _roomNumLabel.backgroundColor = [UIColor clearColor];
    _roomNumLabel.textColor = [UIColor whiteColor];
    _roomNumLabel.font = [UIFont systemFontOfSize:15];
    _roomNumLabel.textAlignment = NSTextAlignmentLeft;
    _roomNumLabel.text = [SharedLanguages CustomLocalizedStringWithKey:@"RoomNumText"];
    [_headView addSubview:_roomNumLabel];
    
    _selectRoomButton = [[FSImageLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_roomNumLabel.frame)+5, CGRectGetMaxY(_roomNameLabel.frame)+10, CGRectGetWidth(_roomNameLabel.frame)-CGRectGetWidth(_roomNumLabel.frame)-5, 15)];
    [_selectRoomButton.imageView setImage:[UIImage imageNamed:@"open"]];
    _selectRoomButton.textLabel.textColor = [UIColor whiteColor];
    _selectRoomButton.textLabel.font = [UIFont systemFontOfSize:15];
    _selectRoomButton.textLabel.textAlignment = NSTextAlignmentLeft;
    _selectRoomButton.textLabel.backgroundColor = [UIColor clearColor];
    _selectRoomButton.textLabel.text = [SharedLanguages CustomLocalizedStringWithKey:@"SelectRoomText"];
    [_selectRoomButton resetFrame];
    _selectRoomButton.textLabel.frame = CGRectMake(0, _selectRoomButton.textLabel.frame.origin.y, _selectRoomButton.textLabel.frame.size.width, _selectRoomButton.textLabel.frame.size.height);
    _selectRoomButton.imageView.frame = CGRectMake(CGRectGetMaxX(_selectRoomButton.textLabel.frame), _selectRoomButton.imageView.frame.origin.y, _selectRoomButton.imageView.frame.size.width, _selectRoomButton.imageView.frame.size.height);
    [_selectRoomButton addTarget:self action:@selector(selectRoom:) forControlEvents:UIControlEventTouchUpInside];

    [_headView addSubview:_selectRoomButton];

    
//    _selectRoomButton.frame = CGRectMake(CGRectGetMaxX(_roomNumLabel.frame)+5, CGRectGetMaxY(_roomNameLabel.frame)+10, CGRectGetWidth(_roomNameLabel.frame)-CGRectGetWidth(_roomNumLabel.frame)-5, 15);
//    _selectRoomButton.backgroundColor = [UIColor clearColor];
//    [_selectRoomButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [_selectRoomButton setTitle:@"请选择" forState:UIControlStateNormal];
//    [_selectRoomButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
//    //_selectRoomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    CGFloat contentWidth = _selectRoomButton.titleLabel.frame.size.width+_selectRoomButton.imageView.frame.size.width;
//    _selectRoomButton.imageEdgeInsets = UIEdgeInsetsMake(0, _selectRoomButton.titleLabel.frame.size.width-(_selectRoomButton.frame.size.width-contentWidth)/2+_selectRoomButton.imageView.frame.size.width+_selectRoomButton.imageView.frame.size.width, 0, (_selectRoomButton.frame.size.width-contentWidth)-((_selectRoomButton.frame.size.width-contentWidth)/2+_selectRoomButton.titleLabel.frame.size.width)-_selectRoomButton.imageView.frame.size.width);
//    _selectRoomButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(_selectRoomButton.frame.size.width-contentWidth)/2-_selectRoomButton.imageView.frame.size.width, 0, (_selectRoomButton.frame.size.width-_selectRoomButton.titleLabel.frame.size.width)-(_selectRoomButton.frame.size.width-contentWidth)/2);
//    
//    [_selectRoomButton addTarget:self action:@selector(selectRoom:) forControlEvents:UIControlEventTouchUpInside];
//    [_headView addSubview:_selectRoomButton];


    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height-20-200)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_bottomView.frame)-1)/2, 60, 1, 60)];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    [_bottomView addSubview:_lineView];
    
    _codeRateImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetMinX(_lineView.frame)-20)/2, 50, 20, 17)];
    _codeRateImageView.image = [UIImage imageNamed:@"coderate"];
    [_bottomView addSubview:_codeRateImageView];
    
    _codeRateNumLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetMinX(_lineView.frame)-120)/2, CGRectGetMaxY(_codeRateImageView.frame)+5, 120, 20)];
    _codeRateNumLabel.backgroundColor = [UIColor clearColor];
    _codeRateNumLabel.textColor = [UIColor blackColor];
    _codeRateNumLabel.font = [UIFont systemFontOfSize:18];
    _codeRateNumLabel.textAlignment = NSTextAlignmentCenter;
    _codeRateNumLabel.text = @"1200K";
    [_bottomView addSubview:_codeRateNumLabel];
    
    _codeRateNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetMinX(_lineView.frame)-120)/2, CGRectGetMaxY(_codeRateNumLabel.frame)+5, 120, 20)];
    _codeRateNameLabel.backgroundColor = [UIColor clearColor];
    _codeRateNameLabel.textColor = [UIColor grayColor];
    _codeRateNameLabel.font = [UIFont systemFontOfSize:18];
    _codeRateNameLabel.textAlignment = NSTextAlignmentCenter;
    _codeRateNameLabel.text = [SharedLanguages CustomLocalizedStringWithKey:@"CodeRateText"];
    [_bottomView addSubview:_codeRateNameLabel];
    
    _resolutionImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetMinX(_lineView.frame)-20)/2+CGRectGetWidth(_bottomView.frame)/2, 50, 20, 17)];
    _resolutionImageView.image = [UIImage imageNamed:@"resolution"];
    [_bottomView addSubview:_resolutionImageView];
    
    _selectResolutionButton = [[FSImageLabel alloc] initWithFrame:CGRectMake((CGRectGetMinX(_lineView.frame)-120)/2+CGRectGetWidth(_bottomView.frame)/2, CGRectGetMaxY(_resolutionImageView.frame)+5, 120, 20)];
    [_selectResolutionButton.imageView setImage:[UIImage imageNamed:@"down_arrow"]];
    _selectResolutionButton.textLabel.textColor = [UIColor redColor];
    _selectResolutionButton.textLabel.font = [UIFont systemFontOfSize:18];
    _selectResolutionButton.textLabel.textAlignment = NSTextAlignmentCenter;
    _selectResolutionButton.textLabel.backgroundColor = [UIColor clearColor];
    _selectResolutionButton.textLabel.text = @"960x540";
    [_selectResolutionButton resetFrame];
    [_selectResolutionButton addTarget:self action:@selector(selectResolution:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:_selectResolutionButton];
    
    
    _resolutionLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetMinX(_lineView.frame)-120)/2+CGRectGetWidth(_bottomView.frame)/2, CGRectGetMaxY(_selectResolutionButton.frame)+5, 120, 20)];
    _resolutionLabel.backgroundColor = [UIColor clearColor];
    _resolutionLabel.textColor = [UIColor grayColor];
    _resolutionLabel.font = [UIFont systemFontOfSize:18];
    _resolutionLabel.textAlignment = NSTextAlignmentCenter;
    _resolutionLabel.text = [SharedLanguages CustomLocalizedStringWithKey:@"ResolutionText"];
    [_bottomView addSubview:_resolutionLabel];
    
    _startLiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startLiveButton.frame = CGRectMake(CGRectGetWidth(_bottomView.frame)/2-206/2, CGRectGetHeight(_bottomView.frame)-207, 206, 207);
    _startLiveButton.backgroundColor = [UIColor clearColor];
//    _startLiveButton.layer.cornerRadius = 60;
//    _startLiveButton.layer.masksToBounds = YES;
    [_startLiveButton addTarget:self action:@selector(startLive:) forControlEvents:UIControlEventTouchUpInside];
//    [_startLiveButton setTitle:[SharedLanguages CustomLocalizedStringWithKey:@"StartLive"] forState:UIControlStateNormal];
    if ([[SharedLanguages AppUsedLanguage] isEqualToString:@"en"]) {
        [_startLiveButton setImage:[UIImage imageNamed:@"startlive-en"] forState:UIControlStateNormal];

    }
    else {
        [_startLiveButton setImage:[UIImage imageNamed:@"startlive"] forState:UIControlStateNormal];
    }
//    CGFloat contentWidth3 = _startLiveButton.titleLabel.frame.size.width+_startLiveButton.imageView.frame.size.width;
//    _startLiveButton.imageEdgeInsets = UIEdgeInsetsMake(0, (_startLiveButton.frame.size.width-contentWidth3)/2+_startLiveButton.titleLabel.frame.size.width, 0, (_startLiveButton.frame.size.width-contentWidth3)/2);
//    _startLiveButton.titleEdgeInsets = UIEdgeInsetsMake(0, -_startLiveButton.imageView.frame.size.width, 0, 0);
    [_bottomView addSubview:_startLiveButton];
    
    _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(_bottomView.frame)-120)/2, CGRectGetHeight(_bottomView.frame)-20, 120, 20)];
    _versionLabel.backgroundColor = [UIColor clearColor];
    _versionLabel.textColor = [UIColor grayColor];
    _versionLabel.font = [UIFont systemFontOfSize:18];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.text = @"Version 1.3.0";
    [_bottomView addSubview:_versionLabel];

}

- (IBAction)changeAvatar:(id)sender {
    UIActionSheet *avaterSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Cancel"] destructiveButtonTitle:nil otherButtonTitles:[SharedLanguages CustomLocalizedStringWithKey:@"Camera"],[SharedLanguages CustomLocalizedStringWithKey:@"Photos"], nil];
    avaterSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [avaterSheet showInView:self.view];
}

- (IBAction)settingClick:(id)sender {
    FSSettingViewController *settingVC = [[FSSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (IBAction)shareClick:(id)sender {
    NSString *roomAddress = [[NSUserDefaults standardUserDefaults] valueForKey:@"VideoAddress"];
    
    if (!roomAddress) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Tips"] message:[SharedLanguages CustomLocalizedStringWithKey:@"NoLiveAddress"] delegate:nil cancelButtonTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Sure"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = roomAddress;
    [self showAlertWithText:[SharedLanguages CustomLocalizedStringWithKey:@"Copy"]];
    return;
}

- (IBAction)selectRoom:(id)sender {
    FSSelectRoomIdView *view = [[FSSelectRoomIdView alloc] initWithFrame:self.view.bounds];
    view.delegate = self;
    [view show];
}

- (IBAction)selectResolution:(id)sender {
    FSSelectResolutionview *view = [[FSSelectResolutionview alloc] initWithFrame:self.view.bounds];
    view.delegate = self;
    [view show];
}

- (IBAction)startLive:(id)sender {
    NSString *roomAddress = [[NSUserDefaults standardUserDefaults] valueForKey:@"RoomAddress"];
    if (!roomAddress) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Tips"] message:[SharedLanguages CustomLocalizedStringWithKey:@"TipsSelectRoom"] delegate:nil cancelButtonTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Sure"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString *resolution = [[NSUserDefaults standardUserDefaults] valueForKey:@"Resolution"];
    if (!resolution) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Tips"] message:[SharedLanguages CustomLocalizedStringWithKey:@"TipsSelectResolution"] delegate:nil cancelButtonTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Sure"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    NSLog(@"Initial reachability status:%@",@(status));
    
    if (status == RealStatusNotReachable)
    {
        [self showAlertWithText:[SharedLanguages CustomLocalizedStringWithKey:@"BadNetWork"]];
        return;
    }
    
    NSArray* array = [NSArray arrayWithObjects:@"1",@"2", nil];
    [[FSSystemPrivilegesCheck sharedInstance] checkSourceTypeArrayAvailable:array result:^(BOOL granted) {
        if (granted) {
            NSLog(@"进入直播间");
            dispatch_async(dispatch_get_main_queue(), ^{
                FSLivePlayerViewController *liveVC = [[FSLivePlayerViewController alloc] init];
                [self.navigationController pushViewController:liveVC animated:YES];
            });
        }
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FSSelectRoomIdViewDelegate
- (void)FSSelectRoomIdView:(NSString *)roomName {
    _selectRoomButton.textLabel.text = roomName;
    [_selectRoomButton resetFrame];
    _selectRoomButton.textLabel.frame = CGRectMake(0, _selectRoomButton.textLabel.frame.origin.y, _selectRoomButton.textLabel.frame.size.width, _selectRoomButton.textLabel.frame.size.height);
    _selectRoomButton.imageView.frame = CGRectMake(CGRectGetMaxX(_selectRoomButton.textLabel.frame), _selectRoomButton.imageView.frame.origin.y, _selectRoomButton.imageView.frame.size.width, _selectRoomButton.imageView.frame.size.height);
}

#pragma mark - FSSelectResolutionviewDelegate
- (void)FSSelectResolutionview:(NSString *)resolution bitrate:(NSString *)biteRate {
    _selectResolutionButton.textLabel.text = resolution;
    [_selectResolutionButton resetFrame];
    
    _codeRateNumLabel.text = [NSString stringWithFormat:@"%@K",biteRate];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
        switch (buttonIndex) {
            case 0:
            {
                [[UIApplication sharedApplication]setStatusBarHidden:YES];
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    NSString *mediaType = AVMediaTypeVideo;
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                        [self showAlertWithText:[SharedLanguages CustomLocalizedStringWithKey:@"PhotoCantUse"]];
                       
                    }
                    else {
                        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                        self.imgPickerController = imgPicker;
                        self.imgPickerController.delegate = self;
                        self.imgPickerController.allowsEditing = YES;//允许剪切
                        self.imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                        [self presentViewController:self.imgPickerController animated:YES completion:nil];
                    }
                    
                } else {
                    [self showAlertWithText:[SharedLanguages CustomLocalizedStringWithKey:@"PhotoCantUse"]];
                }
            }
                break;
            case 1:
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    int author = [ALAssetsLibrary authorizationStatus];
                    //ALAuthorizationStatus author = [ALAssetsLibraryauthorizationStatus];
                    if(author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied){
                        [self showAlertWithText:[SharedLanguages CustomLocalizedStringWithKey:@"PhotoCantUse"]];
                    }
                    else {
                        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                        self.imgPickerController = imgPicker;
                        self.imgPickerController.delegate = self;
                        self.imgPickerController.allowsEditing = YES;//允许剪切
                        self.imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        [self presentViewController:self.imgPickerController animated:YES completion:nil];
                    }
                    
                } else {
                    [self showAlertWithText:[SharedLanguages CustomLocalizedStringWithKey:@"PhotoCantUse"]];
                }
                
            }
                break;
            default:
                [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
                
                break;
        }
}

#pragma mark - UIImagePickerControllerDelegate
- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo{
    if (paramError == nil){
        NSLog(@"Image was saved successfully.");
    } else {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", paramError);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.view.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];//编辑之后（放大缩小之后）
    // 存照片
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(image, self,selectorToCall, NULL);
    }
//    image=[UIImageRound imageByScalingToSize:CGSizeMake(GTFixWidthFlaot(200), GTFixWidthFlaot(200)) img:image];
    //UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //    NSLog(@"imgSize:%@",NSStringFromCGSize(image.size));
    [_avatarButton setImage:image forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;

    [self.imgPickerController dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)showAlertWithText:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Tips"] message:message delegate:nil cancelButtonTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Sure"] otherButtonTitles: nil];
    [alert show];
}


@end
