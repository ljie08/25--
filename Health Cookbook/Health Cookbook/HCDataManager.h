//
//  RemindDataManager.h
//  Health
//
//  Created by 魔曦 on 2017/8/15.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecommendModel.h"

@interface HCDataManager : NSObject

+ (HCDataManager *)manager;

- (NSArray *)queryRemindList;
- (BOOL)isExistModel:(RecommendModel *)model;
- (void)updateLocalRemindData:(RecommendModel *)content;
- (void)insertRemindData:(RecommendModel *)content;
- (void)removeRelationShipOfRemindContent:(RecommendModel *)content;

@end
