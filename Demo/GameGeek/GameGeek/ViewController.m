//
//  ViewController.m
//  GameGeek
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import "GGNewsCell.h"
#import "GGNewsHomeModel.h"
#define PATH @"/Users/qianfeng/Library/Developer/CoreSimulator/Devices/35CB737F-9F59-4526-8E6F-2B5BBE3D7DEA/data/Containers/Data/Application/02FD7226-B781-4677-8737-B85CA3A89709"

@interface ViewController ()

{
    NSInteger menuPage;//标记加载的页数
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setNavigationBarTitle:@"新 闻"];
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
    //?keyword=&npc=0&opc=20&type=%E6%9C%80%E6%96%B0%E9%B2%9C&uid=36729
    NSString *page = [NSString stringWithFormat:@"%ld",menuPage];
    NSDictionary *dic = @{@"npc":page,@"opc":@"20",@"type":@"最新鲜",@"uid":@"36729"};
    
    [self loadDataWithUrl:GG_NEWS_HOST andWith:dic];
}

#pragma mark ----- tableView 协议

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataList.count) {
        return [self.dataList count];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.001;
    }else{
    return 10.0;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    if (section==(self.dataList.count-1)) {
//        return 0.0001;
//    }else{
//        return 5;
//    }
//
//    
//}

//点击cell跳转下一个界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.section);
    if (self.dataList.count) {
        BaseNextPageVC *nextPageVC = [[BaseNextPageVC alloc]init];
        GGNewsHomeSecondModel *model = self.dataList[indexPath.section];
        nextPageVC.url = model.url;
        nextPageVC.imageUrl = model.imglink;
        nextPageVC.linkTitle = model.title;
        nextPageVC.like = [NSString stringWithFormat:@"%@",model.likecount];
        NSLog(@"%@",nextPageVC.like);
        nextPageVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:nextPageVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
