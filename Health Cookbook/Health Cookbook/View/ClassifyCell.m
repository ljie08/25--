//
//  ClassifyCell.m
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/25.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "ClassifyCell.h"
#import <UIImageView+WebCache.h>

@interface ClassifyCell ()

@property (nonatomic,strong) UIImageView *leftImage;
@property (nonatomic,strong) UILabel *lab_title;

@end

@implementation ClassifyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self leftImage];
//        [self lab_title];
    }
    return self;
}

- (void)setModel:(ClassifyModel *)model{
    _model = model;
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
//    self.lab_title.text = model.title;
}

#pragma mark -- Private Method

-(UIImageView *)leftImage{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 180)];
        _leftImage.contentMode = UIViewContentModeScaleAspectFit;
        _leftImage.layer.masksToBounds = YES;
        [_leftImage setUserInteractionEnabled:YES];
        [self.contentView addSubview:_leftImage];
    }
    return _leftImage;
}

-(UILabel *)lab_title{
    if (!_lab_title) {
        _lab_title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        _lab_title.center = self.contentView.center;
        [_lab_title setFont:FONTSIZE(20)];
        [_lab_title setTextColor:COLOR_title];
        _lab_title.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        _lab_title.textAlignment = NSTextAlignmentCenter;
        [_lab_title setUserInteractionEnabled:YES];
        [self.contentView addSubview:_lab_title];
        
    }
    return _lab_title;
}

@end
