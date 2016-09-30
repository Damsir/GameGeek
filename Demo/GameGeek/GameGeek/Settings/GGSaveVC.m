//
//  GGSaveVC.m
//  GameGeek
//
//  Created by qianfeng on 15/10/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "GGSaveVC.h"

#import "FMDatabase.h"
#import "GGNewsHomeModel.h"
#import "UIImageView+AFNetworking.h"

@interface GGSaveVC ()
{
    NSString *savePath;
}
@end

@implementation GGSaveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:@"收 藏"];
    [self setNavigationBarButton];
    
    [self registTableView];
    [self loadData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //刷新删除后收藏界面
    if (self.dataList.count) {
        [self.dataList removeAllObjects];
    }
    [self loadData];
    [self.appTableV reloadData];
}
//自定义导航栏左按钮
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
//注册cell
-(void)registTableView{
    [self.appTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GGSaveCell"];
}
#pragma mark --------从数据库中获取数据
-(void)loadData{
    savePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/GGSave.db"];
    NSString *sql =@"SELECT *FROM GGSaveTables WHERE id >0";
    FMDatabase *dataBase = [FMDatabase databaseWithPath:savePath];
    if ([dataBase open]) {
        //查询结果是一个集合
        FMResultSet *set = [dataBase executeQuery:sql];
        //遍历查询到的结果
        while ([set next]) {
            NSString *webUrl = [set stringForColumn:@"url"];
            NSString *imageUrl = [set stringForColumn:@"imageUrl"];
            NSString *titleName = [set stringForColumn:@"linkTitle"];
            //            NSLog(@"ID=%@ name=%@ age=%@",webID,imageUrl,webUrl);
            GGNewsHomeSecondModel *infoModel = [[GGNewsHomeSecondModel alloc]init];
            infoModel.url = webUrl;
            infoModel.imglink = imageUrl;
            infoModel.title = titleName;
            [self.dataList addObject:infoModel];
        }
    }else{
        NSLog(@"数据库打开失败");
    }
    [dataBase close];
    [self.appTableV reloadData];
}
#pragma mark ----------tableview的协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataList.count) {
        return self.dataList.count;
    }else{
        return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGSaveCell"];
    if (self.dataList.count>indexPath.section)
    {
        GGNewsHomeSecondModel *infoModel = self.dataList[indexPath.section];
        cell.textLabel.text = infoModel.title;
        [cell.imageView setImageWithURL:[NSURL URLWithString:infoModel.imglink] placeholderImage:[UIImage imageNamed:@"gamegeekwithword01"]];
    }
    
    cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataList.count) {
        return 80;
    }
    return DEVICE_H;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  5.0;
}
-(CGFloat)tableView:(UITableView *)tableView footerForHeaderInSection:(NSInteger)section{
    return  5.0;
}
//点击进入下一个页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataList.count>indexPath.section)
    {
        BaseNextPageVC *nextPageVC = [[BaseNextPageVC alloc] init];
        GGNewsHomeSecondModel *infoModel = self.dataList[indexPath.section];
        nextPageVC.url = infoModel.url;
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
