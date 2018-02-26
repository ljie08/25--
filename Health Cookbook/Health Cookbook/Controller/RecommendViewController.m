//
//  RecommendViewController.m
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/24.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "RecommendViewController.h"
#import "DetailViewController.h"
#import "RecommendCell.h"
#import "RecommendModel.h"

@interface RecommendViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *reCollectionView;//推荐

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation RecommendViewController
{
    NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.classifyModel) {
        self.titleText = self.classifyModel.title;
        [self.topContainerView addSubview:self.backButton];
    }
    [self reCollectionView];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self requestData];
    self.automaticallyAdjustsScrollViewInsets = YES;
    _page = 1;
    
}


- (void)requestData{
    
    if (_page == 0) {
        [self.dataArray removeAllObjects];
    }
    NSURL *url;
    if (self.classifyModel) {
        
        url = [NSURL URLWithString:[NSString stringWithFormat:kClassifyDetail,self.classifyModel.mainId,_page]];
    }else{
       url = [NSURL URLWithString:[NSString stringWithFormat:kRecomment,_page]];

    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud showAnimated:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration ] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask  *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [hud hideAnimated:YES];
        NSDictionary *j = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDict = j[@"data"];
        NSArray *arr = dataDict[@"recipes"];
        for (NSDictionary *dict in arr) {
            RecommendModel *model = [[RecommendModel alloc] initWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        [self.reCollectionView reloadData];
    }];
    [dataTask resume];
}

#pragma mark - getter

-(UICollectionView *)reCollectionView{//190
    if (!_reCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (SCREEN_WIDTH - 40)/2.0;
        layout.itemSize = CGSizeMake(width, 205 + 10);//
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 5;
        
        CGFloat y = self.classifyModel ? 64 : 0;
        _reCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,y,SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:layout];
        _reCollectionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];//[[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        [self.view addSubview:_reCollectionView];
        _reCollectionView.showsVerticalScrollIndicator = NO;
        _reCollectionView.dataSource = self;
        _reCollectionView.delegate = self;
        [_reCollectionView registerClass:[RecommendCell class] forCellWithReuseIdentifier:@"RecommendCellId"];
        
        _reCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 0;
            [self requestData];
            // 这个地方是网络请求的处理
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_reCollectionView.mj_header endRefreshing];
            });
        }];
        _reCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page ++;
            [self requestData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_reCollectionView.mj_footer endRefreshing];
            });
        }];
        
    }
    return _reCollectionView;
}


#pragma mark - collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.reCollectionView.mj_footer.hidden = self.dataArray.count == 0;
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendCellId" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.model = self.dataArray[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [cell.layer addAnimation:scaleAnimation forKey:@"transform"];
}



@end
