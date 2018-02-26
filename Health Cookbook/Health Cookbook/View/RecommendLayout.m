//
//  RecommendLayout.m
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/23.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "RecommendLayout.h"

static const NSInteger TGDefaultColumnCount = 2;
static const CGFloat TGDefaultColumnMargin = 5;
static const CGFloat TGDefaultRowMargin = 5;
static const UIEdgeInsets TGDefaultEdgeInsets = {5, 5, 5, 5};

@interface RecommendLayout()

@property (nonatomic, strong) NSMutableArray *attributesArray;
@property (nonatomic, strong) NSMutableArray *columnHeights;
@property (nonatomic, assign) CGFloat contentHeight;

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;

@end

@implementation RecommendLayout

- (CGFloat)rowMargin{
    return ([self.delegate respondsToSelector:@selector(rowMarginInLayout:)]) ? [self.delegate rowMarginInLayout:self] : TGDefaultRowMargin;
}

- (CGFloat)columnMargin{
    return ([self.delegate respondsToSelector:@selector(columnMarginInLayout:)]) ? [self.delegate columnMarginInLayout:self] : TGDefaultColumnMargin;
}

- (NSInteger)columnCount{
    return ([self.delegate respondsToSelector:@selector(columnCountInLayout:)]) ? [self.delegate columnCountInLayout:self] : TGDefaultColumnCount;
}

- (UIEdgeInsets)edgeInsets{
    return ([self.delegate respondsToSelector:@selector(edgeInsetsInLayout:)]) ? [self.delegate edgeInsetsInLayout:self] : TGDefaultEdgeInsets;
}

- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attributesArray{
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

- (void)prepareLayout{
    [super prepareLayout];
    self.contentHeight = 0;
    [self.columnHeights removeAllObjects];
    [self.attributesArray removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attrs];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    CGFloat h = [self.delegate layout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = (minColumnHeight != self.edgeInsets.top) ? self.rowMargin + minColumnHeight : minColumnHeight;
    attrs.frame = CGRectMake(x, y, w, h);
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attrs;
}

- (CGSize)collectionViewContentSize{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}


@end
