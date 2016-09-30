//
//  BaseNextPageVC.m
//  GameGeek
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "BaseNextPageVC.h"
#import "CustomToolBar.h"
#import "FMDatabase.h"//数据库第三方库

//#import <TencentOpenAPI/QQApiInterface.h>

#import "UIImageView+AFNetworking.h"
@interface BaseNextPageVC ()
{
    CustomToolBar *toolBar;
    //是否收藏
    NSString *isCache;
    //存储路径
    NSString *savePath;
}

@end
@implementation BaseNextPageVC 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //推出的时候隐藏tabbar
    self.hidesBottomBarWhenPushed = YES;
    //创建webview
    [self createWebView];
    //创建自定义toolbar
    [self createCustomToolBar];
    //创建数据库
    [self createTheDataBase];
    //创建表
    [self createTheTables];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //显示导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)createWebView{
    UIWebView *myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0, DEVICE_W, DEVICE_H-ToolBar_H)];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.url]];
    myWebView.backgroundColor = [UIColor whiteColor];
    //去掉滚动条
    myWebView.scrollView.showsVerticalScrollIndicator = NO;
    
    [myWebView loadRequest:request];

    [self.view addSubview:myWebView];
}

-(void)createCustomToolBar{
    toolBar = [[[NSBundle mainBundle] loadNibNamed:@"CustomToolBarX" owner:nil options:nil] firstObject];
    toolBar.frame = CGRectMake(0, DEVICE_H-ToolBar_H, DEVICE_W, ToolBar_H);
    toolBar.backgroundColor = THEME_BACK_COLOR;
    [self.view addSubview:toolBar];

    [toolBar.backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    if (![self.like isEqual:@"0"]) {
        [toolBar.likeBtn setTitle:self.like forState:UIControlStateNormal];
        [toolBar.likeBtn setTitleColor:FONT_TINT_COLOR forState:UIControlStateNormal];
    }
    //判断页面收藏状态
    [self chooseTheSaveStatement];
    
    if ([isCache isEqualToString:@"1"]) {
        [toolBar.saveBtn setImage:[UIImage imageNamed:@"收藏_p"] forState:UIControlStateNormal];
    }else{
        [toolBar.saveBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    }

    [toolBar.likeBtn addTarget:self action:@selector(clickLike:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar.saveBtn addTarget:self action:@selector(clickSave:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar.shareBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark  ------ 判断页面收藏状态
-(void)chooseTheSaveStatement{
    savePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/GGSave.db"];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:savePath];
    NSString *sql = @"SELECT *FROM GGSaveTables WHERE url = ?;";
    if ([dataBase open])
    {
        FMResultSet *set = [dataBase executeQuery:sql,self.url];
        while ([set next])
        {
            [dataBase close];
            isCache = @"1";
        }
    }
    else
    {
        NSLog(@"数据库打开失败");
    }
    [dataBase close];
    if (![isCache isEqualToString:@"1"]) {
        isCache = @"0";
    }
}
#pragma mark  ------ 数据库的相关操作
//数据库的创建
-(void)createTheDataBase{
    savePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/GGSave.db"];
    NSLog(@"%@",savePath);
    // 下面这句话：1.判断该路径下有没有名为GGSave的数据库 2.如果有就指向，没有的话就重新创建一个
    FMDatabase *dataBase = [FMDatabase databaseWithPath:savePath];
    if ([dataBase open]) {
        NSLog(@"数据库打开成功");
    }else {
        NSLog(@"数据库打开失败");
    }
    [dataBase close];
}
//创建表
-(void)createTheTables{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:savePath];
     NSString *sql = @"CREATE TABLE GGSaveTables (id INTEGER PRIMARY KEY AUTOINCREMENT,saveCache VARCHAR(20),url VARCHAR(20),imageUrl VARCHAR(20),linkTitle VARCHAR(20));";
    if ([dataBase open])
    {
        [dataBase executeUpdate:sql];
    }
    else
    {
        NSLog(@"打开数据库成功");
    }
    [dataBase close];
}
//插入数据
-(void)insertDataToTables{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:savePath];
    NSString *sql = @"INSERT INTO GGSaveTables(saveCache,url,imageUrl,linkTitle) VALUES(?,?,?,?);";
    if ([dataBase open]) {
//        NSLog(@"网址：%@",self.url);
//        NSLog(@"图片:%@",self.imageUrl);
//        NSLog(@"标题:%@",self.linkTitle);
        if (![self isHas:self.url]) {
            [dataBase executeUpdate:sql,isCache,self.url,self.imageUrl,self.linkTitle];
        }else{
            NSLog(@"已插入");
        }
    }else{
        NSLog(@"数据库打开失败");
    }
    [dataBase close];
}
//判断是否插入
-(BOOL)isHas:(NSString *)url{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:savePath];
    NSString *sql = @"SELECT *FROM GGSaveTables WHERE url = ?;";
    
    if ([dataBase open])
    {
        FMResultSet *set = [dataBase executeQuery:sql,url];
        while ([set next])
        {
            [dataBase close];
            return YES;
        }
    }
    else
    {
        NSLog(@"数据库打开失败");
    }
    [dataBase close];
    return NO;
}
//删除数据
-(void)deleteDataTables{
    FMDatabase *database = [FMDatabase databaseWithPath:savePath];
    NSString *sql =[NSString stringWithFormat:@"DELETE FROM GGSaveTables WHERE url = '%@';",self.url];
    if ([database open]) {
        [database executeUpdate:sql];
       
    }else{
        NSLog(@"数据库打开失败");

    }
    [database close];
}
#pragma mark  ------ TOOLBAR按钮的点击事件
//返回上一页
-(void)clickBack:(id)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
//喜欢
-(void)clickLike:(UIButton*)btn{
    NSLog(@"like");
}
//收藏
-(void)clickSave:(id)btn{
    if ([isCache isEqualToString:@"1"]) {
        isCache = @"0";
    }else{
        isCache = @"1";
    }
    if ([isCache isEqualToString:@"1"]) {
        [toolBar.saveBtn setImage:[UIImage imageNamed:@"收藏_p"] forState:UIControlStateNormal];
        //插入数据库
        [self insertDataToTables];
         NSLog(@"收藏");
    }else{
        [toolBar.saveBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        //从数据库中删除
        [self deleteDataTables];
         NSLog(@"取消收藏");
    }
   
}
//分享
-(void)clickShare:(id)btn{
    NSLog(@"share");
    UIImageView *imageV = [[UIImageView alloc ] initWithFrame:self.view.bounds];
        [imageV setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.imageUrl  ]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"561b59e267e58e2587001f50"
                                              shareText:[NSString stringWithFormat:@"%@%@",self.linkTitle,self.url]
                                             shareImage:[NSString stringWithFormat:@"%@%@",self.linkTitle,self.url]
                                        shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban]
                                               delegate:self];
//            [UMSocialData defaultData].extConfig.wechatSessionData.url = self.url;
//            [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.url;
//            //获取图片后回调
//            [UMSocialSnsService presentSnsIconSheetView:self appKey:@"561b59e267e58e2587001f50" shareText:[NSString stringWithFormat:@"%@%@",self.linkTitle,self.url] shareImage:image shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToDouban,UMShareToLine,UMShareToTumblr,UMShareToTwitter,UMShareToQQ] delegate:self];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功");
    }else if (response.responseCode == UMSResponseCodeFaild){
        NSLog(@"分享失败");

    }
}


@end
