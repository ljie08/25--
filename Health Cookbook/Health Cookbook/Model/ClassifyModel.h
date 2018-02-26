//
//  ClassifyModel.h
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/25.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifyModel : NSObject

@property (nonatomic, copy)NSString *img_url;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)NSInteger mainId;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
