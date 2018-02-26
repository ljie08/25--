//
//  RecommendCell.m
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/23.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "RecommendCell.h"
#import <UIImageView+WebCache.h>

@interface RecommendCell()

@property (nonatomic,strong) UIImageView *leftImage;
@property (nonatomic,strong) UILabel *lab_title;
@property (nonatomic,strong) UILabel *lab_tip;
@property (nonatomic,strong) UIView  *lineView;
@property (nonatomic,strong) UIView  *bgView;

@end

@implementation RecommendCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = COLOR_white;
        
        [self leftImage];
        [self lab_title];
        [self lineView];
        [self lab_tip];
    }
    return self;
}

- (void)setModel:(RecommendModel *)model{
    _model = model;
    if (model.img_url.length > 0) {
    
        [self.leftImage sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
    }
//    [self getCurrentLanguageTextSourceString:model.title block:^(NSString * dst) {
//        model.title = dst;
//        self.lab_title.text = dst;
//    }];
//    [self getCurrentLanguageTextSourceString:model.desContent block:^(NSString * dst) {
//        model.desContent = dst;
//        self.lab_tip.text = dst;
//    }];
    
    self.lab_title.text = model.title;
    self.lab_tip.text = model.desContent;
    [self layoutSubviews];
}

-(BOOL)currentLanguageIsEnglish{
    //获取当前设备语言
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    if ([languageName isEqualToString:@"en"]) {
        return YES;
    }
    
    return NO;
    
}

#define kBaiDuApi   @"http://api.fanyi.baidu.com/api/trans/vip/translate"
#define kAPPID      @"20170824000076600"
#define kSecretKey  @"LRiLlYyX5Dw9CJlvHYYm"

- (void)getCurrentLanguageTextSourceString:(NSString *)sourceStr  block:(void (^)(NSString *))block{
    if (![self currentLanguageIsEnglish]) {
        block(sourceStr);
        return ;
    }
    NSInteger count = random();
    NSString *queryStr = [sourceStr stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLPathAllowedCharacterSet];
    NSString *sign = [NSString stringWithFormat:@"%@%@%ld%@",kAPPID,sourceStr,count,kSecretKey];
    NSString *urlStr = [NSString stringWithFormat:@"http://api.fanyi.baidu.com/api/trans/vip/translate?q=%@&from=%s&to=%s&appid=%@&salt=%ld&sign=%@",queryStr,[@"zh"UTF8String],[@"en" UTF8String],kAPPID,count,[sign stringFromMD5]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration ] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask  *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *j = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArr = j[@"trans_result"];
        NSDictionary *dataDict = dataArr[0];

//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *dst = dataDict[@"dst"];
//                block(dst);
//
//        });
        block(dataDict[@"dst"]);
    }];
    
    [dataTask resume];
}

#pragma mark -- Private Method

-(UIImageView *)leftImage{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, 150)];
        _leftImage.contentMode = UIViewContentModeScaleAspectFill;
        _leftImage.layer.masksToBounds = YES;
        [_leftImage setUserInteractionEnabled:YES];
        [self.contentView addSubview:_leftImage];
    }
    return _leftImage;
}

-(UILabel *)lab_title{
    if (!_lab_title) {
        _lab_title = [[UILabel alloc]initWithFrame:CGRectMake(5, self.leftImage.bottom + 5, self.contentView.width - 10, 20)];
        [_lab_title setFont:FONTSIZE(16)];
        [_lab_title setTextColor: COLOR_title];
        [_lab_title setUserInteractionEnabled:YES];
        [self.contentView addSubview:_lab_title];
        
    }
    return _lab_title;
}

-(UILabel *)lab_tip{
    if (!_lab_tip) {
        _lab_tip = [[UILabel alloc]initWithFrame:CGRectMake(5, self.lineView.bottom + 5, self.contentView.width - 10, 25)];
        [_lab_tip setFont:FONTSIZE(14)];
        [_lab_tip setTextColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1.0]];
        [_lab_tip setUserInteractionEnabled:YES];
        [self.contentView addSubview:_lab_tip];
        
    }
    return _lab_tip;
}

- (UIView *)lineView{
    if (!_lineView) {
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lab_title.bottom + 7, self.contentView.width, 1)];
        _lineView.backgroundColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:0.2];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}



@end
