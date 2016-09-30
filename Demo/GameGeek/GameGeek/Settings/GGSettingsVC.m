//
//  GGSettingsVC.m
//  GameGeek
//
//  Created by qianfeng on 15/10/12.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "GGSettingsVC.h"
//#import "ParallaxHeaderView.h"
#import "takePhoto.h"
#import "GGSaveVC.h"

@interface GGSettingsVC ()<UIAlertViewDelegate>
{
    UIAlertView *setAlert;
    UIAlertView *alert;
}
@property (strong, nonatomic) IBOutlet UILabel *settingsLab1;
@property (strong, nonatomic) IBOutlet UILabel *settingsLab2;
@property (strong, nonatomic) IBOutlet UILabel *settingsLab3;
@property (strong, nonatomic) IBOutlet UILabel *settingsLab4;
@property (strong, nonatomic) IBOutlet UIImageView *settingsBackImageV;
@property (strong, nonatomic) IBOutlet UILabel *cacheFile;

@property(strong,nonatomic)NSString *cacheSize;

@end

@implementation GGSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    [self setGesture];
    
    
}
-(void)setNavigationBar{
    UILabel *naviTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    naviTitleLab.text = @"设 置";
    naviTitleLab.textAlignment = NSTextAlignmentCenter;
    naviTitleLab.font = [UIFont boldSystemFontOfSize:21];
    naviTitleLab.textColor = FONT_TINT_COLOR;
    self.navigationItem.titleView = naviTitleLab;
}
-(void)setGesture{
    NSArray *array = @[self.settingsLab1,self.settingsLab2,self.settingsLab3,self.settingsLab4];
    for (int i = 0; i<4; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressSettings:)];
        [array[i] addGestureRecognizer:tap];
    }
}
-(void)setViewInfo{
    //加载背景图片
    NSUserDefaults *backImage = [NSUserDefaults standardUserDefaults];
    if ([backImage objectForKey:@"backImage"]) {
        NSData* imageData = [backImage objectForKey:@"backImage"];
        UIImage* image = [UIImage imageWithData:imageData];
        self.settingsBackImageV.image =image;
    }else{
        self.settingsBackImageV.image = nil;
    }
    
    //设置缓存数据
    UILabel *cacheLabel = (UILabel *)[self.view viewWithTag:305];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *cachesPath = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches/com.WuhanApp.WuHan/fsCachedData"];
    NSLog(@"%@",cachesPath);
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *dict = [fm attributesOfItemAtPath:cachesPath error:nil];
    //获得文件的大小
    NSNumber *size = [dict objectForKey:@"NSFileSize"];
    NSLog(@"size = %@",size);
    NSString *fileSize = [NSString stringWithFormat:@"%@",size];
    float fileSize2 = [fileSize floatValue];
    float fileSize3 = fileSize2/1024.0;
    self.cacheSize = [NSString stringWithFormat:@"%.2f",fileSize3];
    cacheLabel.text = [NSString stringWithFormat:@"%@ M",self.cacheSize];
    [self.view bringSubviewToFront:cacheLabel];
}
-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
    [self setViewInfo];
}
#pragma mark 各种响应事件
-(void)pressSettings:(UITapGestureRecognizer *)tap{
    UILabel *label1 =(UILabel *)[self.view viewWithTag:301];
    UILabel *label2 =(UILabel *)[self.view viewWithTag:302];
    UILabel *label3 =(UILabel *)[self.view viewWithTag:303];
    UILabel *label4 =(UILabel *)[self.view viewWithTag:304];
    
    if (tap.view == label1) {
        NSLog(@"1");
        [self chooseWhichToSet];
        
    }else if (tap.view == label2){
        [self getIntoSavePage];
        NSLog(@"2");
    }else if (tap.view == label3){
        NSLog(@"3");
        setAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要恢复设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
       
        [setAlert show];
    }else if(tap.view == label4){
        NSLog(@"4");
        [self createAlertView];
    }
}
//设置头像
-(void)chooseWhichToSet{
    [takePhoto sharePicture:^(UIImage *image) {
        NSLog(@"%@",image);
        //UIImagePNGRepresentation //存储为png 带一个参数
        //UIImageJPEGRepresentation //存储为jpg 带两个参数，第二个参数为压缩系数
        NSUserDefaults *backImage = [NSUserDefaults standardUserDefaults];
        [backImage setObject:UIImageJPEGRepresentation(image, 1.0) forKey:@"backImage"];
        [backImage synchronize];
        [self setBackImageV];
      
    }];
}
-(void)setBackImageV{
    NSUserDefaults *backImage = [NSUserDefaults standardUserDefaults];
    NSData* imageData = [backImage objectForKey:@"backImage"];
    UIImage* image = [UIImage imageWithData:imageData];
      self.settingsBackImageV.image = image;
}
//推到收藏页面
-(void)getIntoSavePage{
    GGSaveVC *saveVC = [[GGSaveVC alloc]init];
    saveVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:saveVC animated:YES];
}
//清除缓存
-(void)createAlertView{
   alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要清除缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
#pragma mark -- AlertView的代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == alert) {
        if (buttonIndex == 0) {
            NSLog(@"不清除");
        }else if (buttonIndex == 1){
            NSLog(@"清除");
            
        }

    }else {
        if (buttonIndex == 0) {
            NSLog(@"不恢复");
        }
        else if (buttonIndex == 1){
            NSLog(@"恢复");
            NSUserDefaults *backImage = [NSUserDefaults standardUserDefaults];
            if ([backImage objectForKey:@"backImage"]) {
                [backImage removeObjectForKey:@"backImage"];
                self.settingsBackImageV.image =nil;
            }
            else{
                self.settingsBackImageV.image = nil;
            }
        }

    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView == alert) {
        if (buttonIndex==1) {
            //删除路径下的缓存文件
            NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *cachesPath = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches/com.WuhanApp.WuHan/fsCachedData"];
            NSLog(@"%@",cachesPath);
            NSFileManager *fm = [NSFileManager defaultManager];
            //获取目录下的文件名
            NSArray *cachesFiles = [fm contentsOfDirectoryAtPath:cachesPath error:nil];
            NSLog(@"%@",cachesFiles);
            
            for (NSString * fileName in cachesFiles) {
                NSString *removePath = [cachesPath stringByAppendingPathComponent:fileName];
                NSLog(@"%@",removePath);
                BOOL ret = [fm removeItemAtPath:removePath error:nil];
                if (!ret) {
                    NSLog(@"清除失败");
                }
            }
            NSDictionary *dict = [fm attributesOfItemAtPath:cachesPath error:nil];
            //获得文件的大小
            NSNumber *size = [dict objectForKey:@"NSFileSize"];
            if (size) {
                NSLog(@"清除成功");
                UILabel *cacheLabel = (UILabel *)[self.view viewWithTag:305];
                cacheLabel.text =@"已清空";
            }else{
                NSLog(@"清除失败");
            }
            
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
