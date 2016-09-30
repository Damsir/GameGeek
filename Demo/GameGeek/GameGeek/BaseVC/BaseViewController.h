//
//  BaseViewController.h
//  GameGeek
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "GGApi.h"
#import "BaseNextPageVC.h"
#import "GGNewsHomeModel.h"

@interface BaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UITableView *appTableV;
//数据源数组
@property(strong,nonatomic)NSMutableArray*dataList;
//数据解析模型
@property(strong,nonatomic)GGNewsHomeModel*dataModel;

//导航栏标题
-(void)setNavigationBarTitle:(NSString *)title;
//下拉刷新 上拉加载更多
-(void)headerRefresh;
-(void)footerLoadMore;
//请求数据的封装
-(void)loadDataWithUrl:(NSString *)url andWith:(NSDictionary *)dic;

@end
