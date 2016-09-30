//
//  GGTabVC.m
//  GameGeek
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "GGTabVC.h"

@interface GGTabVC ()

@end

@implementation GGTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.tintColor = FONT_TINT_COLOR;
    self.tabBar.barTintColor = THEME_BACK_COLOR;
    
    NSArray *titleArr = @[@"新闻",@"视频",@"攻略",@"发售表",@"设置"];
    NSArray *pictArr = @[@"news_",@"video_",@"gonglue_",@"list_",@"settings_"];
    
    int i = 0 ;
    for (UINavigationController *navi in self.viewControllers) {
        navi.tabBarItem = [[UITabBarItem alloc]initWithTitle:titleArr[i] image:[UIImage imageNamed:[NSString stringWithFormat:@"%@1",pictArr[i]]] selectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@2",pictArr[i]]]];
        i++;
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
