//
//  RecommendModel.h
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/23.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendModel : NSObject

@property (nonatomic, copy)NSString *desContent;
@property (nonatomic, copy)NSString *img_url;
@property (nonatomic, copy)NSString *page_url;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)NSInteger rId;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)getCurrentLanguageTextSourceString:(NSString *)sourceStr  block:(void (^)(NSString *))block;
@end
