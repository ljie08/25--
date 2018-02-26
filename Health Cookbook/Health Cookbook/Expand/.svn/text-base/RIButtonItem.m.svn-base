//
//  RIButtonItem.m
//  JoggersV2
//
//  Created by Jecky on 14/12/2.
//  Copyright (c) 2014年 hupu. All rights reserved.
//

#import "RIButtonItem.h"

@implementation RIButtonItem
@synthesize label;
@synthesize action;

+(id)item{
    return [[self alloc] init];
}

+(id)itemWithLabel:(NSString *)inLabel
{
    RIButtonItem *newItem = [self item];
    [newItem setLabel:inLabel];
    return newItem;
}

+(id)itemWithLabel:(NSString *)inLabel action:(void(^)(void))action
{
    RIButtonItem *newItem = [self itemWithLabel:inLabel];
    [newItem setAction:action];
    return newItem;
}

@end
