//
//  FavoriteViewController.m
//  Health Cookbook
//
//  Created by 魔曦 on 2017/8/24.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "FavoriteViewController.h"
#import "DetailViewController.h"
#import "RecommendCell.h"
#import "RecommendModel.h"

@interface FavoriteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *reCollectionView;//推荐

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)HCDataManager *dataManager;

@end

@implementation FavoriteViewController

- (void)viewWillAppear:(BOOL)animated{
    [self queryLocalData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reCollectionView];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)queryLocalData{
    
    self.dataManager = [HCDataManager manager];

    NSArray *arr = [self.dataManager queryRemindList];
    if (arr.count) {
        if (self.dataArray.count) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:arr];
        [self.reCollectionView reloadData];
         
    }
}

#pragma mark - getter

-(UICollectionView *)reCollectionView{//190
    if (!_reCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (SCREEN_WIDTH - 40)/2.0;
        layout.itemSize = CGSizeMake(width, 205 + 10);//
        layout.minimumLineSpacing =10;
        layout.minimumInteritemSpacing = 5;
        
        _reCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:layout];
        _reCollectionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];//[[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        [self.view addSubview:_reCollectionView];
        _reCollectionView.showsVerticalScrollIndicator = NO;
        _reCollectionView.dataSource = self;
        _reCollectionView.delegate = self;
        [_reCollectionView registerClass:[RecommendCell class] forCellWithReuseIdentifier:@"RecommendCellId"];
        
    }
    return _reCollectionView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
