//
//  RIButtonItem.h
//  JoggersV2
//
//  Created by Jecky on 14/12/2.
//  Copyright (c) 2014年 hupu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RIButtonItem : NSObject{
    NSString *label;
    void (^action)();
}

@property (retain, nonatomic) NSString *label;
@property (copy, nonatomic) void (^action)();

+(id)item;
+(id)itemWithLabel:(NSString *)inLabel;
+(id)itemWithLabel:(NSString *)inLabel action:(void(^)(void))action;

@end
