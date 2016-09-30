//
//  GGStrategyVC.m
//  GameGeek
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "GGStrategyVC.h"
#import "GGNewsCell.h"

@interface GGStrategyVC ()

{
    NSInteger menuPage;//标记加载的页数
    
}
@end

@implementation GGStrategyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:@"攻 略"];
    [self registTableView];//注册cell
    
    menuPage = 0;
    
    [self loadData];
}

-(void)registTableView{
    UINib *nib = [UINib nibWithNibName:@"GGNewsCell" bundle:nil];
    [self.appTableV registerNib:nib forCellReuseIdentifier:@"GGNewsCell"];
}
-(void)headerRefresh{
    
    menuPage = 0;
    [self.dataList removeAllObjects];
    [self loadData];
}

-(void)footerLoadMore{
    menuPage++;
    [self loadData];
}
-(void)loadData{
    ////?npc=0&opc=20&type=%E6%94%BB%E7%95%A5&uid=36729
    NSString *page = [NSString stringWithFormat:@"%ld",menuPage];
    NSDictionary *dic = @{@"npc":page,@"type":@"攻略",@"uid":@"36729"};
    
    [self loadDataWithUrl:GG_STRATEGY_HOST andWith:dic];
}

#pragma mark---------tableview 的协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataList.count) {
        return self.dataList.count;
    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGNewsCell"];
    if (self.dataList.count) {
        GGNewsHomeSecondModel *model = self.dataList[indexPath.section];
        [cell setUIWith:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        return [[UITableViewCell alloc]init];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataList.count) {
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
    if (self.dataList.count) {
        BaseNextPageVC *nextPageVC = [[BaseNextPageVC alloc]init];
        GGNewsHomeSecondModel *model = self.dataList[indexPath.section];
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
