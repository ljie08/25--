//
//  RecommendLayout.h
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/23.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecommendLayout;

@protocol RecommendLayoutDelegate <NSObject>
@required
- (CGFloat)layout:(RecommendLayout *)layout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInLayout:(RecommendLayout *)layout;
- (CGFloat)columnMarginInLayout:(RecommendLayout *)layout;
- (CGFloat)rowMarginInLayout:(RecommendLayout *)layout;
- (UIEdgeInsets)edgeInsetsInLayout:(RecommendLayout *)layout;
@end


@interface RecommendLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<RecommendLayoutDelegate> delegate;


@end
