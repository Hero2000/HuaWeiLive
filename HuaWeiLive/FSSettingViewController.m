//
//  FSSettingViewController.m
//  HuaWeiLive
//
//  Created by 王明 on 2017/2/8.
//  Copyright © 2017年 王明. All rights reserved.
//

#import "FSSettingViewController.h"
#import "SharedLanguages.h"

@interface FSSettingViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *addressField;

@end

@implementation FSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.navigationController setNavigationBarHidden:NO];
    
    self.title = [SharedLanguages CustomLocalizedStringWithKey:@"Setting"];
    
    [self initBaseUI];
}

- (void)initBaseUI {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+30, self.view.frame.size.width, 50)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 50)];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.text = [SharedLanguages CustomLocalizedStringWithKey:@"ServerAddress"];
    [textLabel sizeToFit];
    textLabel.frame = CGRectMake(20, (50-textLabel.frame.size.height)/2, textLabel.frame.size.width, textLabel.frame.size.height);
    [contentView addSubview:textLabel];
    
    _addressField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textLabel.frame)+30, 0, contentView.frame.size.width-CGRectGetMaxX(textLabel.frame)-30-20, 50)];
    _addressField.placeholder = @"rtmp://hwdic.com/live";
    _addressField.delegate = self;
    [contentView addSubview:_addressField];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(20, CGRectGetMaxY(contentView.frame)+20, self.view.frame.size.width-20*2, 50);
    saveButton.backgroundColor = [UIColor redColor];
    saveButton.layer.cornerRadius = 5;
    saveButton.layer.masksToBounds = YES;
    [saveButton setTitle:[SharedLanguages CustomLocalizedStringWithKey:@"Save"] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    
}

- (void)saveAddress {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  //  [self.navigationItem setHidesBackButton:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
