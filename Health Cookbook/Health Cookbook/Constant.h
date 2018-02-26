
//
//  Constant.h
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/23.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define LOCALIZED(X) NSLocalizedString(X,nil)

#define kRecomment   @"http://zaijiawan.com/matrix_common/api/recipe/detailsbook?appname=tianjianfeishipu&hardware=iphone&os=ios&page=%ld&udid=8d29f0445de236a81b28b2598c5727e0f01bd991&version=2.1.0"
#define kClassify    @"http://zaijiawan.com/matrix_common/api/recipe/mainbook?appname=tianjianfeishipu&hardware=iphone&info_flow_ad%3Dtrue=true&os=ios&udid=8d29f0445de236a81b28b2598c5727e0f01bd991&version=2.1.0"

//列表详情
#define kClassifyDetail      @"http://zaijiawan.com/matrix_common/api/recipe/detailsbook?appname=tianjianfeishipu&hardware=iphone&mainId=%ld&os=ios&page=%ld&udid=8d29f0445de236a81b28b2598c57"

#define COLOR_title   [UIColor blackColor]//[Tools hexStringToColor:@"183b7b"]
//选中状态
#define COLOR_sTitle  [UIColor colorWithRed:28/255.0 green:159/255.0 blue:237/255.0 alpha:1]
#define COLOR_white  [UIColor whiteColor]
#define COLOR_white  [UIColor whiteColor]
#define COLOR_003  [UIColor colorWithRed:129/255.0 green:183/255.0 blue:222/255.0 alpha:1]
//#define COLOR_003  [UIColor colorWithRed:128/255.0 green:180/255.0 blue:218/255.0 alpha:1]

#define CLEARCOLOR [UIColor clearColor]


#define FONTSIZE(X)     [UIFont systemFontOfSize:X]
#define FONT_12     [UIFont systemFontOfSize:12.f]
#define FONT_15     [UIFont systemFontOfSize:15.f]


//图片资源获取
#define IMGFROMBUNDLE( X )	 [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:X ofType:@""]]
#define IMGNAMED( X )	     [UIImage imageNamed:X]

#ifdef DEBUG
#define DBLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DBLog(xx, ...)  ((void)0)
#endif


//解析字典
#define PUGetObjFromDict(__key, __dict, __class)       [PUUtil getElementForKey:__key fromDict:__dict forClass:__class]
#define PUGetIntElemForKeyFromDict(__key, __dict)      [PUUtil getIntElementForKey:__key fromDict:__dict]
#define PUGetFloatElemForKeyFromDict(__key, __dict)      [PUUtil getFloatElementForKey:__key fromDict:__dict]

#define PUGetStringElemForKeyFromDict(__key, __dict)   [PUUtil getStringElementForKey:__key fromDict:__dict]
#define PUGetBoolElemForKeyFromDict(__key, __dict)   [PUUtil getBoolElementForKey:__key fromDict:__dict]

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define heightScale SCREEN_HEIGHT/667.0f
#define widthScale SCREEN_WIDTH/375.0f

#define iPhone4 (SCREEN_MAX_LENGTH == 480.0)
#define iPhone5 (SCREEN_MAX_LENGTH == 568.0)
#define iPhone5Later (SCREEN_MAX_LENGTH >= 568.0)
#define iPhone6 (SCREEN_MAX_LENGTH == 667.0)
#define iPhone6Later (SCREEN_MAX_LENGTH >= 667.0)
#define iPhone6P (SCREEN_MAX_LENGTH == 736.0)
#define iPhone6PLater (SCREEN_MAX_LENGTH >= 736.0)

#define iOS7_OR_LATER   ( [UIDevice currentDevice].systemVersion.floatValue >= 7.0)
#define iOS8_OR_LATER   ( [UIDevice currentDevice].systemVersion.floatValue >= 8.0)
#define iOS8_3_OR_LATER   ( [UIDevice currentDevice].systemVersion.floatValue >= 8.0)
#define iOS9_OR_LATER   ( [UIDevice currentDevice].systemVersion.floatValue >= 9.0)
#define iOS10_OR_LATER   ( [UIDevice currentDevice].systemVersion.floatValue >= 10.0)


#endif /* Constant_h */
