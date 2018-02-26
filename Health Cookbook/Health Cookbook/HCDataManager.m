//
//  RemindDataManager.m
//  Health
//
//  Created by 魔曦 on 2017/8/15.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#import "HCDataManager.h"
#import <FMDB.h>

@interface HCDataManager()

@property (nonatomic, strong)FMDatabaseQueue *dbQueue;

@property (nonatomic, strong)NSMutableDictionary *allTopicCache;//存储所有帖子
@property (nonatomic, strong)NSMutableDictionary *topicCacheForModules;//各个模块的缓存

@end

@implementation HCDataManager

+ (HCDataManager *)manager{
    static HCDataManager *manager = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
       
        manager = [[HCDataManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self createTables];
    }
    return self;
}

- (NSString *)dbPath
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path   = [docsPath stringByAppendingPathComponent:@"RecommendDB.sqlite"];
    
    return path;
}

- (FMDatabaseQueue *)dbQueue
{
    if (!_dbQueue) {
        NSString *dbPath   = [self dbPath];
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    }
    return _dbQueue;
}

- (void)clearTables //清除表数据
{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"drop TABLE t_favorite"];//帖子实体列表
        
    }];
}

- (void)createTables{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if (db) {
            BOOL result = [db executeUpdate:@"create table if not exists t_favorite (rId integer , title text ,img_url text, page_url text ,desContent text)"];
            if (result) {
                NSLog(@"创建提醒实体表成功");
            }
        }
    }];
}

//查询
- (NSArray *)queryRemindList{
    __block  NSMutableArray *list = [[NSMutableArray alloc] init];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
      FMResultSet *result = [db executeQuery:@"select * from t_favorite"];
        while ([result next]) {
            RecommendModel *content = [[RecommendModel alloc] init];
            content.rId = [result intForColumn:@"rId"];
            content.title = [result stringForColumn:@"title"];
            content.img_url = [result stringForColumn:@"img_url"];
            content.page_url = [result stringForColumn:@"page_url"];
            content.desContent = [result stringForColumn:@"desContent"];
            [list addObject:content];
        }
        NSLog(@"");
    }];
    
    
    return list;
}

- (BOOL)isExistModel:(RecommendModel *)model{
    __block BOOL isExist = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select * from t_favorite where rId = %ld",model.rId];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            NSLog(@"存在");
            isExist = YES;
        }
    }];
    
    return isExist;
}

- (void)updateLocalRemindData:(RecommendModel *)content{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            NSString *title = content.title ? content.title: @"";
            NSString *img_url = content.img_url ?content.img_url: @"";
            NSString *page_url = content.page_url ?content.page_url: @"";
            NSString *desContent = content.desContent ? content.desContent : @"";
            NSNumber *rId = [NSNumber numberWithInteger:content.rId];
            NSString *sql = @"update t_favorite set title = ? ,img_url = ? ,page_url = ? desContent = ? where rId = ?";
            BOOL updateResult = [db executeUpdate:sql,title,img_url,page_url,desContent,rId];
            if (updateResult) {
                NSLog(@"更新成功");
            }
        }];
        
    });
}

//插入数据
- (void)insertRemindData:(RecommendModel *)content{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = @"insert into t_favorite (rId ,title ,img_url ,page_url ,desContent) values (?,?,?,?,?)";
            NSString *title = content.title ? content.title: @"";
            NSString *img_url = content.img_url ?content.img_url: @"";
            NSString *page_url = content.page_url ?content.page_url: @"";
            NSString *desContent = content.desContent ? content.desContent : @"";
            NSNumber *rId = [NSNumber numberWithInteger:content.rId];
            NSArray *argArray = @[rId,title,img_url,page_url,desContent];
            BOOL insertResult = [db executeUpdate:sql withArgumentsInArray:argArray];
            if (insertResult) {
                NSLog(@"新增成功");
            }
        }];
        
    });
    
//    return insertResult;
}

- (void)removeRelationShipOfRemindContent:(RecommendModel *)content{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            [self removeRelationShipOfRemindId:content.rId fromDataBase:db];
            
        }];
        
    });
}

//删除数据
- (void)removeRelationShipOfRemindId:(NSInteger)remindId fromDataBase:(FMDatabase *)db{
    
    NSString *sql = [NSString stringWithFormat:@"delete from t_favorite where rId = %ld",remindId];
    BOOL result = [db executeUpdate:sql];
    if (result) {
        NSLog(@"删除成功");

    }
}


@end


























