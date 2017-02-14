//
//  SharedLanguages.m
//  FlyShow
//
//  Created by gaochao on 15/2/3.
//  Copyright (c) 2015年 高超. All rights reserved.
//

#import "SharedLanguages.h"
#define keyAppLanguage @"appLanguage"
#define keyAppLanguageAuto @"keyAppLanguageAuto"


#define keyAppDefaultLanguage @"en" //用来屏蔽没有的语言
#define keyAppFirstLanguage @"en"    //跟随系统的第一语言


static SharedLanguages *staticLanguage;
@interface SharedLanguages()
{
    NSString *_language;
    BOOL _followSystem;
}
@end
@implementation SharedLanguages

+(instancetype)SharedLanguage
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        staticLanguage = [[SharedLanguages alloc] init];
    });
    return staticLanguage;
}
- (instancetype)init
{
    if (self = [super init]) {
        NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
        // 取得 iPhone 支持的所有语言设置
        NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
        NSLog (@"%@", languages);
        
        // 获得当前iPhone使用的语言
        NSString* currentLanguage = [languages objectAtIndex:0];
        
        // 不跟随系统
        _followSystem = [self followSystem]; // yes 跟随  no 不跟随
        _language = currentLanguage;//[[NSUserDefaults standardUserDefaults] valueForKey:keyAppLanguage];
        
        if (_language.length == 0) {// 没有设置过系统语言
            _language =  keyAppDefaultLanguage;//[[NSLocale preferredLanguages] objectAtIndex:0];
//            if([_language isEqualToString:@"zh-Hans"])
//            {
//                _language = keyAppDefaultLanguage;
//            }
        }
        [[NSUserDefaults standardUserDefaults] setValue:_language forKey:keyAppLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return self;
}
- (void)resetLanguage
{
    if(!self.followSystem)
    {
        [[NSUserDefaults standardUserDefaults] setValue:_language forKey:keyAppLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)language
{
    if(self.followSystem)
    {
        NSArray *perferredArray = [NSLocale preferredLanguages];
        if (perferredArray) {
            _language = keyAppDefaultLanguage;//[perferredArray firstObject];
        }else
        {
            _language = keyAppDefaultLanguage;
        }
        
//        if ([_language isEqualToString:@"zh-Hans"]) {
//            _language = keyAppDefaultLanguage;
//        }
        
        // 屏蔽系统语言
        _language = keyAppFirstLanguage;
    }else
    {
        NSString *currentLanage = [[NSUserDefaults standardUserDefaults]  valueForKey:keyAppLanguage];
        _language = currentLanage;
        
        if (_language.length == 0) {// 没有设置过
            _language = keyAppDefaultLanguage;//[[NSLocale preferredLanguages] objectAtIndex:0];
//            if ([_language isEqualToString:@"zh-Hans"]) {
//                _language = keyAppDefaultLanguage;
//            }
        }
    }
    
    if ([_language rangeOfString:@"en"].location != NSNotFound) {
        _language = @"en";
    }else
    {
        if ([_language rangeOfString:@"ar"].location != NSNotFound) {
            _language = @"ar";
        }
        else if ([_language rangeOfString:@"tr"].location != NSNotFound)
        {
            _language = @"tr";
        }
        else if ([_language rangeOfString:@"zh-Hans"].location != NSNotFound)
        {
            _language = @"zh-Hans";
        }
        else if ([_language rangeOfString:@"zh-Hans-CN"].location != NSNotFound)
        {
            _language = @"zh-Hans-CN";
        }
        else {
            _language = @"en";
        }
    }
    
    return _language;
}
- (void)setLanguage:(NSString *)language //手动设置语种 不跟随系统
{
    // 不跟随系统的
    _followSystem = YES;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:_followSystem] forKey:keyAppLanguageAuto];
    
    // 设置语言  当前设置和别的不同就重新设置
    if (_language != language) {
        
        _language = language;
        [self resetLanguage];
    }
}
-(void)setFollowSystem:(BOOL)followSystem //设置跟随服务器
{
    _followSystem = followSystem;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:followSystem] forKey:keyAppLanguageAuto];
}
-(BOOL)followSystem
{
    NSNumber *followSystem = [[NSUserDefaults standardUserDefaults] valueForKey:keyAppLanguageAuto];
    return [followSystem boolValue];
}
- (NSString *)CustomLocalizedStringFromTable:(NSString *)key Comment:(NSString *)comment Table:(NSString *)table
{
    
    NSString *RecoursePath;
    if (!self.followSystem) {//不跟随服务器
        RecoursePath = [[NSUserDefaults standardUserDefaults] valueForKey:keyAppLanguage];
    }else //跟随服务器
    {
        RecoursePath =  keyAppDefaultLanguage;//[[NSLocale preferredLanguages] objectAtIndex:0];
//        if ([RecoursePath isEqualToString:@"zh-Hans"]  || [RecoursePath isEqualToString:@"zh-Hans-Cn"]) {
//            RecoursePath = keyAppDefaultLanguage;
//        }
    }
    // 兼容 iOS 9.0
    if ([RecoursePath rangeOfString:@"en"].location != NSNotFound) {
        RecoursePath = @"en";
    }else if ([RecoursePath rangeOfString:@"ar"].location != NSNotFound) {
        RecoursePath = @"ar";
    }else if ([RecoursePath rangeOfString:@"tr"].location != NSNotFound) {
        RecoursePath = @"tr";
    }
    else if ([RecoursePath rangeOfString:@"zh-Hans"].location != NSNotFound) {
        RecoursePath = @"zh-Hans";
    }
    else if ([RecoursePath rangeOfString:@"zh-Hans-CN"].location != NSNotFound) {
        RecoursePath = @"zh-Hans-CN";
    }
    else
    {
        RecoursePath = @"en";
    }
    
    
    
    NSString *PathString = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",RecoursePath] ofType:@"lproj"];
    
    if (PathString.length == 0) { //没有这种语言 默认取系统偏好
        
        NSString *perferredLanguage =  keyAppDefaultLanguage; //[[NSLocale preferredLanguages] objectAtIndex:0];
//        if ([perferredLanguage isEqualToString:@"zh-Hans"]) {
//            perferredLanguage = keyAppDefaultLanguage;
//        }
        PathString = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",perferredLanguage] ofType:@"lproj"];
    }
    NSBundle * currentBundle = [NSBundle bundleWithPath:PathString];
    NSString * LoaclizedString = [currentBundle localizedStringForKey:key value:nil table:table];
    
    return LoaclizedString;
}

+ (NSString *)CustomLocalizedStringWithKey:(NSString *)key
{
    return  [[SharedLanguages SharedLanguage] CustomLocalizedStringFromTable:key Comment:nil Table:keyLanguageTable];
}
+ (NSString *)AppUsedLanguage //当前使用的语言
{
    return [[SharedLanguages SharedLanguage] language];
}
+ (NSString *)AppUsedFullLanguage
{
    if ([[SharedLanguages SharedLanguage] followSystem]) {
        return @"Auto";
    }else
    {
        if ([[SharedLanguages AppUsedLanguage] isEqualToString:@"ar"]) {
            return [SharedLanguages CustomLocalizedStringWithKey:@"عربي"];
        }
        else if ([[SharedLanguages AppUsedLanguage] isEqualToString:@"tr"]) {
            return [SharedLanguages CustomLocalizedStringWithKey:@"Türkçe"];
        }
        else if ([[SharedLanguages AppUsedLanguage] isEqualToString:@"zh-Hans"] || [[SharedLanguages AppUsedLanguage] isEqualToString:@"zh-Hans-CN"]) {
            return @"中文";
        }
        else
        {
            return @"English";
        }
    }
}
+ (NSString *)AppLanguageId
{
    if ([[SharedLanguages SharedLanguage].language rangeOfString:@"en"].location != NSNotFound)
    {
        return @"1";
    }else if ([[SharedLanguages SharedLanguage].language rangeOfString:@"tr"].location != NSNotFound)
    {
        return @"3";
    }
    else if ([[SharedLanguages SharedLanguage].language rangeOfString:@"zh-Hans"].location != NSNotFound || [[SharedLanguages SharedLanguage].language rangeOfString:@"zh-Hans-CN"].location != NSNotFound)
    {
        return @"4";
    }else
    {
        return @"2";
    }
}
@end
