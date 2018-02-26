//
//  ClassifyModel.m
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/25.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "ClassifyModel.h"

@implementation ClassifyModel

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.img_url = dictionary[@"img_url"];
        self.title = dictionary[@"title"];
        self.mainId = [dictionary[@"mainId"] integerValue];
        
    }
    return self;
}

@end
