//
//  BaseViewController.m
//  GameGeek
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataList = [[NSMutableArray alloc]init];
    
    [self createTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)setNavigationBarTitle:(NSString *)title{
    UILabel *naviTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    naviTitleLab.text = title;
    naviTitleLab.textAlignment = NSTextAlignmentCenter;
    naviTitleLab.font = [UIFont boldSystemFontOfSize:21];
    naviTitleLab.textColor = FONT_TINT_COLOR;
    self.navigationItem.titleView = naviTitleLab;
}
-(void)createTableView{
    self.appTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_W, DEVICE_H) style:UITableViewStylePlain];
    self.appTableV.dataSource = self;
    self.appTableV.delegate = self;
    self.appTableV.backgroundColor = BACK_COLOR;
    [self.view addSubview:self.appTableV];
    
    //给tabkeview添加下拉刷新和上拉加载更多
    [self.appTableV addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.appTableV addFooterWithTarget:self action:@selector(footerLoadMore)];
    
}

-(void)headerRefresh{
    
}
-(void)footerLoadMore{
    
}
//请求数据
-(void)loadDataWithUrl:(NSString *)url andWith:(NSDictionary *)dic{
    __weak typeof(*&self)weakself = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:GG_LIST_NEXT_PAGE parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _dataModel = [[GGNewsHomeModel alloc]initWithData:operation.responseData error:nil];
        
        [self.appTableV headerEndRefreshing];
        [self.appTableV footerEndRefreshing];
        
        //把请求到的数据装入数组
        [weakself saveListWith:_dataModel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.appTableV headerEndRefreshing];
        [self.appTableV footerEndRefreshing];
        
    }];
}
//将model存入数组（上拉加载更多）
-(void)saveListWith:(GGNewsHomeModel *)model{
    if (model.rootList) {
        for (GGNewsHomeSecondModel *secondModel in model.rootList) {
            [_dataList addObject:secondModel];
        }
    }
    [self.appTableV reloadData];
    
}


#pragma MARK -------- tableview 的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc]init];
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
