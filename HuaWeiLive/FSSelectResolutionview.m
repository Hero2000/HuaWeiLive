//
//  FSSelectResolutionview.m
//  HuaWeiLive
//
//  Created by 王明 on 2017/2/9.
//  Copyright © 2017年 王明. All rights reserved.
//

#import "FSSelectResolutionview.h"
#import "SharedLanguages.h"

@interface FSSelectResolutionview()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *resolutionArray;
@property (nonatomic, strong) NSArray *biteRateArray;

@end


@implementation FSSelectResolutionview

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        if ([[SharedLanguages AppUsedLanguage] isEqualToString:@"en"]) {
            _resolutionArray = @[@"960x540",@"640x360(normal)",@"640x360(low)"];
        }
        else {
            _resolutionArray = @[@"960x540",@"640x360(标)",@"640x360(低)"];
        }
        _biteRateArray = @[@"1200",@"800",@"400"];
        
        [self initBaseUI];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)initBaseUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake((self.frame.size.width-220)/2, (self.frame.size.height-120)/2, 220, 120) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor grayColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.cornerRadius = 5;
    _tableView.layer.masksToBounds = YES;
    _tableView.scrollEnabled = NO;
    [self addSubview:_tableView];
    
}



- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    [window addSubview:self];
    
    NSString *resolution = [[NSUserDefaults standardUserDefaults] valueForKey:@"Resolution"];
    if (resolution) {
        NSUInteger index = [_resolutionArray indexOfObject:resolution];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Done"]];
        cell.accessoryView = imageView;
    }
}

- (void)hiddenView {
    [self removeFromSuperview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = [_resolutionArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resolutionArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if ([self.delegate respondsToSelector:@selector(FSSelectResolutionview:bitrate:)]) {
        [self.delegate FSSelectResolutionview:[_resolutionArray objectAtIndex:indexPath.row] bitrate:[_biteRateArray objectAtIndex:indexPath.row]];
    }
    [[NSUserDefaults standardUserDefaults] setValue:[_resolutionArray objectAtIndex:indexPath.row] forKey:@"Resolution"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self hiddenView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Done"]];
    cell.accessoryView = imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(_tableView.frame, point)) {
        return NO;
    }
    
    return YES;
}


@end
