//
//  GGVideoVC.m
//  GameGeek
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "GGVideoVC.h"
#import "GGVideoCell.h"

#import "GGVideoPage.h"

#import "GGVideoCell.h"

#import "UMSocial.h"
#import "UIImageView+AFNetworking.h"

@interface GGVideoVC ()<GGVideoCellDelegate,UMSocialUIDelegate>
{
    NSInteger menuPage;//标记加载的页数
}
@end

@implementation GGVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:@"视 频"];
    self.view.backgroundColor = BACK_COLOR;
    [self registTableView];
    
    
    menuPage  =  0;
    self.appTableV.frame = CGRectMake(10, 0, DEVICE_W-20, DEVICE_H);
    [self loadData];
    
}

-(void)registTableView{
    UINib *nib = [UINib nibWithNibName:@"GGVideoCell" bundle:nil];
    [self.appTableV registerNib:nib forCellReuseIdentifier:@"GGVideoCell"];
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
#pragma mark -------- 加载数据
-(void)loadData{
    //?npc=0&opc=20&type=%E5%8E%9F%E7%94%9F&uid=36729
    NSString *page = [NSString stringWithFormat:@"%ld",menuPage];
    NSDictionary *dic = @{@"npc":page,@"opc":@"20",@"type":@"原生"};
    
    [self loadDataWithUrl:GG_VIDEO_HOST andWith:dic];
}

#pragma mark ------- cell 的代理方法
-(void)shareVideoWith:(NSString *)videoU andWith:(NSString *)imageU andWith:(NSString *)title{
    
    UIImageView *imageV = [[UIImageView alloc ] initWithFrame:self.view.bounds];
    
    [imageV setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageU]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        //获取图片后回调
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"561b59e267e58e2587001f50"
                                          shareText:[NSString stringWithFormat:@"%@%@",title,videoU]
                                         shareImage:image
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban]
                                           delegate:self];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = videoU;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = videoU;
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功");
        //        [self createTipsWith:@"分享成功"];
        
    }else if (response.responseCode == UMSResponseCodeFaild){
        NSLog(@"分享失败");
        //        [self createTipsWith:@"分享失败"];
    }
}
#pragma mark ------- tableview的代理事件
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
    GGVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGVideoCell"];
    if (self.dataList.count) {
        GGNewsHomeSecondModel *model = self.dataList[indexPath.section];
        // 设置cell的代理
        cell.delegate = self;
        [cell setUIWith:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        return [[UITableViewCell alloc]init];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataList.count) {
        return 215.0;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GGVideoPage *videoPageVC = [[GGVideoPage alloc]init];
//    GGVideoPageVC *videoPageVC = (GGVideoPageVC*)[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:model.videolink]];
    GGNewsHomeSecondModel *model = self.dataList[indexPath.section];
    videoPageVC.videoUrl = model.videolink;
    videoPageVC.view.backgroundColor = [UIColor whiteColor];
    videoPageVC.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:videoPageVC animated:YES];
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
