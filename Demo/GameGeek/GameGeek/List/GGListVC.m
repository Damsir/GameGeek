//
//  GGListVC.m
//  GameGeek
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "GGListVC.h"
#import "GGListCell.h"
#import "GGListHomeModel.h"

#import "GGListNextPage.h"

@interface GGListVC ()

{
    GGListHomeModel *dataModel;//数据源
    NSMutableArray *playDataList;//加载更多的数组
    NSMutableArray *XboxDataList;
    NSInteger menuPage1;//标记加载的页数
    NSInteger menuPage2;
    BOOL isCache;
}
@end

@implementation GGListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarTitle:@"发售表"];
    self.view.backgroundColor = THEME_BACK_COLOR;
    [self createCategoryBtn];
    [self setTableView];
    [self registTableView];
    //初始化各种
    playDataList = [[NSMutableArray alloc]init];
    XboxDataList = [[NSMutableArray alloc]init];
    menuPage1 = 0;
    menuPage2 = 0;
    isCache = YES;
    
    [self loadData];
    
}
-(void)createCategoryBtn{
    NSArray *title = @[@"PlayStation",@"Xbox"];
    for (int i = 0; i<2; i++) {
        UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        categoryBtn.frame = CGRectMake(0, 64+i*50, 0.25*DEVICE_W, 50);
        categoryBtn.tag = 100+i;
        if (i==0) {
            categoryBtn.layer.borderColor = BACK_COLOR.CGColor;
            categoryBtn.layer.borderWidth = 4;
            [self buttonBeSmaller:categoryBtn];
        }else{
            [self buttonBeBigger:categoryBtn];
        }
        [categoryBtn setTitle:title[i] forState:UIControlStateNormal];
        [categoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [categoryBtn addTarget:self action:@selector(selectedCategory:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:categoryBtn];
    }
}
#pragma mark -------- 按钮字体变大变小的方法
-(void)buttonBeBigger:(UIButton *)btn{
    if (DEVICE_W==320) {
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
    }else if (DEVICE_W==375){
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
    }else{
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
    }

}
-(void)buttonBeSmaller:(UIButton *)btn{
    if (DEVICE_W==320) {
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
    }else if (DEVICE_W==375){
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
    }else{
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
    }

}
//按钮的点击事件
-(void)selectedCategory:(UIButton *)btn{
    sleep(0.9);
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:100];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
    if (btn1==btn) {
        btn2.layer.borderColor = [UIColor clearColor].CGColor;
        btn2.layer.borderWidth = 0;
        [self buttonBeBigger:btn2];
        
        btn1.layer.borderColor = BACK_COLOR.CGColor;
        btn1.layer.borderWidth = 4;
        [self buttonBeSmaller:btn1];
        isCache = YES;
    }else{
        btn1.layer.borderColor = [UIColor clearColor].CGColor;
        btn1.layer.borderWidth = 0;
        [self buttonBeBigger:btn1];
        
        btn2.layer.borderColor = BACK_COLOR.CGColor;
        btn2.layer.borderWidth = 4;
        [self buttonBeSmaller:btn2];
        isCache = NO;
    }
    //每次点击返回最上
    self.appTableV.contentOffset = CGPointMake(0, -64);
    [self headerRefresh];
}
-(void)setTableView{
    self.appTableV.frame = CGRectMake(0.25*DEVICE_W, 0, 0.75*DEVICE_W, DEVICE_H);
    self.appTableV.backgroundColor = BACK_COLOR;
    self.appTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
}
//注册cell
-(void)registTableView{
    UINib *nib = [UINib nibWithNibName:@"GGListCell" bundle:nil];
    [self.appTableV registerNib:nib forCellReuseIdentifier:@"GGListCell"];
}
#pragma mark 请求数据
-(void)headerRefresh{
    menuPage1 = 0;
    menuPage2 = 0;
    if (isCache) {
        [playDataList removeAllObjects];
    }else{
        [XboxDataList removeAllObjects];
    }
    [self loadData];
    
}
-(void)footerLoadMore{
    if (isCache) {
        menuPage1++;
//        [self loadPlayStationData];
    }else{
        menuPage2++;
//        [self loadXboxData];
    }
    [self loadData];
}
-(void)loadData{
    //?kind=PlayStation&npc=0&opc=20&sorttype=0
    //?kind=Xbox&npc=0&opc=20&sorttype=0
    NSString *page ;
    NSString *kinds;
    if (isCache) {
        page  = [NSString stringWithFormat:@"%ld",menuPage1];
        kinds = @"PlayStation";
    }else{
        page  = [NSString stringWithFormat:@"%ld",menuPage2];
        kinds = @"Xbox";
    }
    NSDictionary *dic = @{@"kind":kinds,@"npc":page,@"opc":@"20",@"sorttype":@"0"};
    __weak typeof(*&self)weakself = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:GG_LIST_HOST parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dataModel = [[GGListHomeModel alloc]initWithData:operation.responseData error:nil];
        [self.appTableV headerEndRefreshing];
        [self.appTableV footerEndRefreshing];
        //把请求到的数据装入数组
        if (isCache) {
            [weakself savePlayListWith:dataModel];
        }else{
            [weakself saveXboxListWith:dataModel];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
}
-(void)savePlayListWith:(GGListHomeModel *)model{
    for (GGNewsHomeSecondModel *info in model.rootList) {
            [playDataList addObject:info];
        }
    [self.appTableV reloadData];
    
}
-(void)saveXboxListWith:(GGListHomeModel *)model{
    for (GGNewsHomeSecondModel *info in model.rootList) {
        [XboxDataList addObject:info];
    }
    [self.appTableV reloadData];
}

#pragma mark ------- tableView的协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (isCache) {
        if (playDataList.count) {
            return playDataList.count;
        }else{
            return 1;
        }
    }else{
        if (XboxDataList.count) {
            return XboxDataList.count;
        }else{
            return 1;
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGListCell"];
    if (isCache) {
        if (playDataList.count) {
        GGNewsHomeSecondModel *model = playDataList[indexPath.section];
        [cell setUIWith:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        }else{
            return [[UITableViewCell alloc]init];
        }
    }else{
        if (XboxDataList.count) {
            GGNewsHomeSecondModel *model = XboxDataList[indexPath.section];
            [cell setUIWith:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            return [[UITableViewCell alloc]init];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (playDataList.count||XboxDataList.count) {
        return 120.0;
    }else{
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
//点击cell跳转下一界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GGListNextPage *nextListPageVC = [[GGListNextPage alloc]init];
    GGNewsHomeSecondModel *model;
    if (isCache) {
        if (playDataList.count) {
            model = playDataList[indexPath.section];
            nextListPageVC.keywordName = model.name;
            nextListPageVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:nextListPageVC animated:YES];
        }
    }else{
        if (XboxDataList.count) {
            model = XboxDataList[indexPath.section];
            nextListPageVC.keywordName = model.name;
            nextListPageVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:nextListPageVC animated:YES];
        }
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
