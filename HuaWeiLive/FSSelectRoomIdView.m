//
//  FSSelectRoomIdView.m
//  HuaWeiLive
//
//  Created by 王明 on 2017/2/9.
//  Copyright © 2017年 王明. All rights reserved.
//

#import "FSSelectRoomIdView.h"
#import "SharedLanguages.h"

@interface FSSelectRoomIdView()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *roomNameArray;
@property (nonatomic, strong) NSArray *roomAddressArray;
@property (nonatomic, strong) NSArray *videoAddressArray;

@end

@implementation FSSelectRoomIdView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        if ([[SharedLanguages AppUsedLanguage] isEqualToString:@"en"]) {
            _roomNameArray = @[@"Room1",@"Room2",@"Room3",@"Room4",@"Room5",@"Room6",@"Room7",@"Room8",@"Room9"];
        }
        else {
            _roomNameArray = @[@"房间1",@"房间2",@"房间3",@"房间4",@"房间5",@"房间6",@"房间7",@"房间8",@"房间9"];
        }
        
        _roomAddressArray = @[@"rtmp://ingress.7nujoom.com/live/stream_huawei_101",
                              @"rtmp://ingress.7nujoom.com/live/stream_huawei_102",
                              @"rtmp://ingress.7nujoom.com/live/stream_huawei_103",
                              @"rtmp://ingress.7nujoom.com/live/stream_huawei_104",
                              @"rtmp://ingress.7nujoom.com/live/stream_huawei_105",
                              @"rtmp://ingress.7nujoom.com/live/stream_huawei_106",
                              @"rtmp://ingress.7nujoom.com/live/stream_huawei_107",
                              @"rtmp://ingress.7nujoom.com/live/stream_huawei_108",
                              @"rtmp://ingress.7nujoom.com/live/stream_huawei_109"];
        
        _videoAddressArray = @[@"http://117.78.36.50/huawei/show.html?n=101",
                              @"http://117.78.36.50/huawei/show.html?n=102",
                              @"http://117.78.36.50/huawei/show.html?n=103",
                              @"http://117.78.36.50/huawei/show.html?n=104",
                              @"http://117.78.36.50/huawei/show.html?n=105",
                              @"http://117.78.36.50/huawei/show.html?n=106",
                              @"http://117.78.36.50/huawei/show.html?n=107",
                              @"http://117.78.36.50/huawei/show.html?n=108",
                              @"http://117.78.36.50/huawei/show.html?n=109"];
        
        [self initBaseUI];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)initBaseUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake((self.frame.size.width-220)/2, (self.frame.size.height-300)/2, 220, 300) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor grayColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.cornerRadius = 5;
    _tableView.layer.masksToBounds = YES;
    [self addSubview:_tableView];
    
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    [window addSubview:self];
    
    NSString *roomAddress = [[NSUserDefaults standardUserDefaults] valueForKey:@"RoomAddress"];
    if (roomAddress) {
        NSUInteger index = [_roomAddressArray indexOfObject:roomAddress];
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
    cell.textLabel.text = [_roomNameArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _roomNameArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Done"]];
    cell.accessoryView = imageView;
    if ([self.delegate respondsToSelector:@selector(FSSelectRoomIdView:)]) {
        [self.delegate FSSelectRoomIdView:[_roomNameArray objectAtIndex:indexPath.row]];
    }
    [[NSUserDefaults standardUserDefaults] setValue:[_roomAddressArray objectAtIndex:indexPath.row] forKey:@"RoomAddress"];
    [[NSUserDefaults standardUserDefaults] setValue:[_videoAddressArray objectAtIndex:indexPath.row] forKey:@"VideoAddress"];
    [[NSUserDefaults standardUserDefaults] setValue:[_roomNameArray objectAtIndex:indexPath.row] forKey:@"RoomName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self hiddenView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
