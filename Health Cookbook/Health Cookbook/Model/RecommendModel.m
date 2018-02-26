//
//  RecommendModel.m
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/23.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "RecommendModel.h"

/*
 t
 *description;
 *img_url;
 *page_url;
 *title;
 ger id;
 */

@implementation RecommendModel

- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.desContent = dictionary[@"description"];
        self.img_url = dictionary[@"img_url"];
        self.page_url = dictionary[@"page_url"];
        self.title = dictionary[@"title"];
        self.rId = [dictionary[@"id"] integerValue];

    }
    return self;
}

@end
