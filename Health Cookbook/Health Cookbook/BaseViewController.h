//
//  BaseViewController.h
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/22.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong, readonly) UIImageView *topImageView;
@property (nonatomic, strong, readonly) UIView      *topContainerView;

@property (nonatomic, strong, readonly) UIView      *containerView;//视图容器
@property (nonatomic, strong) UIColor     *titleColor;//设置titleColor

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, copy) NSString     *titleText;//设置title
@property (nonatomic, assign, readonly)BOOL isNavBarHidden;
/*
 * Should be reseted by subclass if subclass wants to implement custom back button item
 *eg: [self.topContainerView addSubview:self.backButton];
 */
@property (nonatomic, strong, readonly) UIButton  *backButton;

/*
 * Should be reseted by subclass if subclass wants to implement custom button item
 *eg1: self.rightBarButtonTitle = @"XXXXXXX";
 *eg2: self.rightButton.frame = CGRect;
 */
@property (nonatomic, strong) UIButton         *rightButton;
@property (nonatomic, copy) NSString         *rightBarButtonTitle;


//返回，如果子类返回时，需要作特殊的操作，需要重写该方法
- (void)back;
- (void)rightBarBtnClickAction:(UIButton *)btn;
- (void)BackTopDidClickNavBar;//点击导航栏返回顶部
//=<end

- (BOOL)isDisplayed;

- (void)setNavBarHidden:(BOOL)hidden animate:(BOOL)animate;
- (void)setNavBarHidden:(BOOL)hidden;

- (void)setNavBarHiddenToStatusBar:(BOOL)hidden animate:(BOOL)animate;

- (BOOL)gestureRecognizerShouldBegin;


@end
