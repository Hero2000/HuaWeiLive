//
//  SharedLanguages.h
//  FlyShow
//
//  Created by gaochao on 15/2/3.
//  Copyright (c) 2015年 高超. All rights reserved.
//

#import <Foundation/Foundation.h>
//      创建的语言表的名称
#define keyLanguageTable @"HuaWEiLive_CN"

@interface SharedLanguages : NSObject
// 语言
@property(nonatomic,strong)NSString *language;
// 跟随系统
@property(nonatomic,assign)BOOL followSystem;
+(instancetype)SharedLanguage;
// 获得换回的字符串
+ (NSString *)CustomLocalizedStringWithKey:(NSString *)key;
//当前使用的语言
+ (NSString *)AppUsedLanguage;

//FullLangue
+ (NSString *)AppUsedFullLanguage;

+ (NSString *)AppLanguageId;

+ (BOOL)systemIsArbicLanguage;
@end
