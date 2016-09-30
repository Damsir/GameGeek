//
//  GGListNextPage.m
//  GameGeek
//
//  Created by qianfeng on 15/10/11.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "GGListNextPage.h"
#import "GGListHomeModel.h"
#import "GGNewsCell.h"//和news的cell同款

#import "BaseNextPageVC.h"

@interface GGListNextPage ()
{
   
    GGListHomeModel *dataModel;//数据源
    NSMutableArray *dataList;//加载更多的数组
    NSInteger menuPage;//标记加载的页数
        
    
}
@end

@implementation GGListNextPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:self.keywordName];
    [self setNavigationBarButton];
    
    [self registTableView];//注册cell
    
    dataList = [[NSMutableArray alloc]init];
    menuPage = 0;
    
    [self loadData];
}
-(void)setNavigationBarButton{
    UIButton *naviBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    naviBackBtn.frame = CGRectMake(0, 5, 25, 25);
    [naviBackBtn setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [naviBackBtn addTarget:self action:@selector(backToPreciew:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:naviBackBtn];
}
-(void)backToPreciew:(id)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)registTableView{
    UINib *nib = [UINib nibWithNibName:@"GGNewsCell" bundle:nil];
    [self.appTableV registerNib:nib forCellReuseIdentifier:@"GGNewsCell"];
}
-(void)headerRefresh{
    menuPage = 0;
    [dataList removeAllObjects];
    [self loadData];
}
-(void)footerLoadMore{
    menuPage++;
    [self loadData];
}
//加载数据
-(void)loadData{
    //?keyword=%E9%BB%91%E6%9A%97%E4%B9%8B%E9%AD%823&npc=0&opc=20&uid=36729
    NSString *page = [NSString stringWithFormat:@"%ld",menuPage];
    NSDictionary *dic = @{@"keyword":self.keywordName,@"npc":page,@"uid":@"36729"};
    
    __weak typeof(*&self)weakself = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:GG_LIST_NEXT_PAGE parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dataModel = [[GGListHomeModel alloc]initWithData:operation.responseData error:nil];
        
        [self.appTableV headerEndRefreshing];
        [self.appTableV footerEndRefreshing];
        
        //把请求到的数据装入数组
        [weakself saveListWith:dataModel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}
-(void)saveListWith:(GGListHomeModel *)model{
    for (GGNewsHomeSecondModel *info in model.rootList) {
        [dataList addObject:info];
    }
    [self.appTableV reloadData];
}

#pragma mark ------tableview的协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (dataList.count) {
        return dataList.count;
    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGNewsCell"];
    if (dataList.count) {
        GGNewsHomeSecondModel *model = dataList[indexPath.section];
        [cell setUIWith:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        return [[UITableViewCell alloc]init];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataList.count) {
        return 320.0;
    }else {
        return DEVICE_H;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.001;
    }else{
        return 10.0;
    }
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 5.0;
//}
//点击cell跳转下一个界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.section);
    if (dataList.count) {
        BaseNextPageVC *nextPageVC = [[BaseNextPageVC alloc]init];
        GGNewsHomeSecondModel *model = dataList[indexPath.section];
        nextPageVC.url = model.url;
        nextPageVC.imageUrl = model.imglink;
        nextPageVC.linkTitle = model.title;
        nextPageVC.like = [NSString stringWithFormat:@"%@",model.likecount];
        nextPageVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:nextPageVC animated:YES];
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
