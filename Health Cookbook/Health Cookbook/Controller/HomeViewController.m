//
//  HomeViewController.m
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/23.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "HomeViewController.h"
#import "RecommendViewController.h"
#import "ClassifyViewController.h"
#import "FavoriteViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIView *topMenu;
@property (nonatomic, strong)UIScrollView *bottomScrollView;

@end

@implementation HomeViewController{
    NSInteger _selectIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectIndex = 100;
    [self topMenu];
    [self bottomScrollView];
    [self addChildViewControllers];
    
}

- (void)addChildViewControllers{
    
    RecommendViewController *rVC = [[RecommendViewController alloc] init];
    ClassifyViewController  *cVC = [[ClassifyViewController alloc] init];
    FavoriteViewController  *fVC = [[FavoriteViewController alloc] init];
    NSArray *arr = @[rVC,cVC,fVC];
    for (NSInteger i = 0; i < arr.count;i++ ) {
        CGRect frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, self.containerView.height);
        UIViewController *vc = arr[i];
        vc.view.frame = frame;
//        [self addChildViewController:vc];
//        if (i == 0) {
//            [self.bottomScrollView addSubview:vc.view];
//        }
        [self addController:vc View:vc.view];
    }
}

- (void)addController:(UIViewController *)childController View:(UIView *)view{
    
    [self addChildViewController:childController];
    [self.bottomScrollView addSubview:view];
    
}

-(BOOL)currentLanguageIsEnglish{
    //获取当前设备语言
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    if ([languageName rangeOfString:@"en"].location != NSNotFound) {//en-US
        return YES;
    }
    
    return NO;
    
}

#pragma mark - getter
- (UIView *)topMenu{
    if (!_topMenu) {
        _topMenu = [[UIView alloc] initWithFrame:CGRectMake(0,20, SCREEN_WIDTH, 44)];
        [self.topImageView addSubview:_topMenu];
        NSArray *titleArray = @[LOCALIZED(@"推荐"),LOCALIZED(@"分类"),LOCALIZED(@"收藏")];
        for (NSInteger i = 0; i < titleArray.count; i ++) {
            CGFloat width = [self currentLanguageIsEnglish] ? 65 : 40;
            CGFloat space = (SCREEN_WIDTH - width * 3 - 20 *2)/2.0;

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(space + (width + 20)*i, 0, width, 44)];
            label.textColor = COLOR_title;
            label.font = FONTSIZE(15);
            label.textAlignment = NSTextAlignmentCenter;
            label.text = titleArray[i];
            label.tag = 100 + i;
            [_topMenu addSubview:label];
            if (label.tag == _selectIndex) {
                [UIView animateWithDuration:0.1 animations:^{
                    label.font = FONTSIZE(18);
                }];
            }
            
            label.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topMenuDidTapped:)];
            [label addGestureRecognizer:tap];
        }
    }
    return _topMenu;
}

- (UIScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _bottomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3,self.containerView.height);
        _bottomScrollView.bounces = NO;
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        _bottomScrollView.showsVerticalScrollIndicator = NO;
        _bottomScrollView.delegate = self;
        _bottomScrollView.scrollEnabled = NO;
        [self.view addSubview:_bottomScrollView];
        
    }
    return _bottomScrollView;
}

#pragma mark - actions
- (void)topMenuDidTapped:(UIGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    
    if (label.tag != _selectIndex) {
        UILabel *lastLabel = (UILabel *)[self.topMenu viewWithTag:_selectIndex];
        [UIView animateWithDuration:0.1 animations:^{
            label.font = FONTSIZE(18);
            lastLabel.font = FONTSIZE(15);
        }];
        
        _selectIndex = label.tag;
    }
    [UIView animateWithDuration:0.5 animations:^{
//        UIViewController *vc = self.childViewControllers[label.tag - ];
        [self.bottomScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (label.tag - 100), 0)];
    }];
    
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (int)(offsetX / SCREEN_WIDTH) + 100;
    DBLog(@"offsetX = %f index = %ld",offsetX,index);
    if (index != _selectIndex) {
        UILabel *label = (UILabel *)[self.topMenu viewWithTag:index];;
        UILabel *lastLabel = (UILabel *)[self.topMenu viewWithTag:_selectIndex];
        [UIView animateWithDuration:0.1 animations:^{
            label.font = FONTSIZE(18);
            lastLabel.font = FONTSIZE(15);
        }];
        
        _selectIndex = label.tag;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
