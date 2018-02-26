//
//  BaseViewController.m
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/22.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIView      *topContainerView;
@property (nonatomic, strong) UIView      *containerView;//视图容器
@property (nonatomic, strong) UIButton  *backButton;

@property (nonatomic, assign)BOOL isNavBarHidden;

@end

@implementation BaseViewController

- (void)dealloc {
    [self releaseView];
}

//the object create in viewdidload
- (void)releaseView {
    
}

#pragma mark - init
- (id)init{
    self = [super init];
    if (self) {
        self.titleColor = [UIColor blackColor];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *statusbarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [statusbarView setBackgroundColor:COLOR_white];
    [self.view addSubview:statusbarView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.containerView atIndex:0];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupInteractivePopGestureRecognizer];
}

- (void)setupInteractivePopGestureRecognizer
{
    
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;    //状态栏显示白字
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarBtnClickAction:(UIButton *)btn
{
    
}

- (void)BackTopDidClickNavBar{
    
}

#pragma mark-gestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([[touch view]isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        [gestureRecognizer requireGestureRecognizerToFail:otherGestureRecognizer];
        return YES;
    }
    
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL ok = YES;
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return ok;
    }
    if ([self.navigationController.topViewController isKindOfClass:[BaseViewController class]]) {
        if ([self.navigationController.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
            BaseViewController *VC = (BaseViewController *)self.navigationController.topViewController;
            ok = [VC gestureRecognizerShouldBegin];
        }
    }
    return ok;
}

- (BOOL)gestureRecognizerShouldBegin
{
    return YES;
}

#pragma mark - getter
- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topImageView.height, self.view.width, [[UIScreen mainScreen] bounds].size.height-self.topImageView.height)];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}

- (UIImageView *)topImageView{
    if (!_topImageView) {
        CGFloat  height = 44;
        if (iOS7_OR_LATER) {
            height = 64;
        }
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, height)];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.backgroundColor = CLEARCOLOR;
        self.topContainerView.top = height - self.topContainerView.height;
        [_topImageView addSubview:self.topContainerView];
        
        [self.view addSubview:_topImageView];
    }
    return _topImageView;
}

- (UIView *)topContainerView{
    if (!_topContainerView) {
        _topContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
        _topContainerView.userInteractionEnabled = YES;
        _topContainerView.backgroundColor = [UIColor clearColor];
        [_topContainerView addSubview:self.titleLabel];
        self.titleLabel.centerY = _topContainerView.height/2.0;
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BackTopDidClickNavBar)];
//        tap.delegate=self;
//        [_topContainerView addGestureRecognizer:tap];
    }
    return _topContainerView;
}



- (void)gotoLogoWebView {
    //would recover by subclass,just put here to avoid crash
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.userInteractionEnabled=YES;
        _titleLabel.textColor = COLOR_title;
        _titleLabel.font = FONTSIZE(18);
    }
    return _titleLabel;
}

- (UIButton *)backButton{
    if (!_backButton) {
        UIImage  *img = IMGNAMED(@"ic_back_nor");
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.exclusiveTouch = YES;
        _backButton.backgroundColor = [UIColor clearColor];
        _backButton.frame = CGRectMake(20, floorf((self.topContainerView.height-img.size.height)/2), img.size.width, img.size.height);
        [_backButton setBackgroundImage:IMGNAMED(@"ic_back_nor") forState:UIControlStateNormal];
        [_backButton setBackgroundImage:IMGNAMED(@"ic_back_nor") forState:UIControlStateSelected];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backButton;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        UIImage  *btnImg = IMGNAMED(@"nav_btn");
//        UIImage  *img = [PUUtil stretchImage:btnImg capInsets:UIEdgeInsetsMake(btnImg.size.height/2, btnImg.size.width/2, btnImg.size.height/2, btnImg.size.width/2) resizingMode:UIImageResizingModeStretch];
//        UIImage  *img1 = [PUUtil stretchImage:[UIImage imageNamed:@"nav_btn_1"] capInsets:UIEdgeInsetsMake(btnImg.size.height/2, btnImg.size.width/2, btnImg.size.height/2, btnImg.size.width/2) resizingMode:UIImageResizingModeStretch];
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setBackgroundImage:btnImg forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:btnImg forState:UIControlStateSelected];
        [_rightButton setExclusiveTouch:YES];
        [_rightButton.titleLabel setFont:FONTSIZE(16)];//12
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton setTitleColor:COLOR_title forState:UIControlStateDisabled];
        [_rightButton setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin)];
        _rightButton.frame = CGRectMake(0, 0, btnImg.size.width, btnImg.size.height);
        [_rightButton addTarget:self action:@selector(rightBarBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topContainerView addSubview:_rightButton];
    }
    return _rightButton;
}


#pragma mark - getter
- (void)setRightBarButtonTitle:(NSString *)rightBarButtonTitle
{
    if(_rightBarButtonTitle != rightBarButtonTitle){
        _rightBarButtonTitle = rightBarButtonTitle;
        
        [self.rightButton setTitle:rightBarButtonTitle forState:UIControlStateNormal];
        CGRect frame = [self.rightButton frame];
        [self.rightButton sizeToFit];
        CGRect frameNew = [self.rightButton frame];
        float addWidth = frameNew.size.width - frame.size.width;
        float w = frame.size.width + (addWidth > 0 ? ( addWidth + 12 ) : 0 );
        
        [self.rightButton setFrame:CGRectMake(self.topContainerView.bounds.size.width-w-5, floorf((self.topContainerView.bounds.size.height-frame.size.height)/2), w, frame.size.height)];
        
    }
}

- (void)setTitleText:(NSString *)titleText{
    
    if ([titleText length]<=0) {
        self.titleLabel.text = @"";
    }else{
        if(_titleText != titleText){
            _titleText = titleText;
        }
        [self.titleLabel setText:titleText];
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX,self.titleLabel.height)];
        CGRect  frame = self.titleLabel.frame;
        frame.size.width = size.width;
        if (iPhone4) {
            frame.size.height=size.height;
            frame.origin.y=7;
        }
        self.titleLabel.frame = frame;
        self.titleLabel.centerX = self.view.width/2;
    }
    
}

- (BOOL)isDisplayed
{
    return (self.isViewLoaded && self.view.window != nil);
}

- (void)setNavBarHidden:(BOOL)hidden
{
    [self setNavBarHidden:hidden animate:NO];
}

- (void)setNavBarHidden:(BOOL)hidden animate:(BOOL)animate
{
    if (self.isNavBarHidden) {
        if (!hidden) {
            self.topImageView.backgroundColor = COLOR_white;
            self.topImageView.hidden = NO;
            self.isNavBarHidden = NO;
            self.containerView.frame = CGRectMake(0, self.topImageView.height, self.view.width, [[UIScreen mainScreen] bounds].size.height-64);
        }
    }
    else
    {
        if (hidden) {
            self.topImageView.backgroundColor = [UIColor clearColor];
            self.topImageView.hidden = YES;
            self.isNavBarHidden = YES;
            self.containerView.frame = CGRectMake(0, 0, self.view.width, [UIScreen mainScreen].bounds.size.height);
        }
    }
}

- (void)setNavBarHiddenToStatusBar:(BOOL)hidden animate:(BOOL)animate
{
    if (self.isNavBarHidden) {
        if (!hidden) {
            self.isNavBarHidden = NO;
            
            CGFloat time = 0.0;
            if (animate) {
                time = 0.3;
            }
            
            [UIView animateWithDuration:time animations:^{
                CGFloat  height = 44;
                if (iOS7_OR_LATER) {
                    height = 64;
                }
                self.topImageView.frame = CGRectMake(0, 0, self.view.width, height);
                self.containerView.frame = CGRectMake(0, self.topImageView.height, self.view.width, [[UIScreen mainScreen] bounds].size.height-64);
                
            } completion:^(BOOL finished) {
                self.topContainerView.hidden = NO;
            }];
            
        }
    }
    else
    {
        if (hidden) {
            self.isNavBarHidden = YES;
            
            CGFloat time = 0.0;
            if (animate) {
                time = 0.3;
            }
            [UIView animateWithDuration:time
                             animations:^{
                                 self.topImageView.bottom = 20;
                                 self.containerView.frame = CGRectMake(0, self.topImageView.bottom, self.view.width, [UIScreen mainScreen].bounds.size.height - self.topImageView.bottom);
                             }
                             completion:^(BOOL finished) {
                                 self.topContainerView.hidden = YES;
                             }];
        }
    }
}


@end
