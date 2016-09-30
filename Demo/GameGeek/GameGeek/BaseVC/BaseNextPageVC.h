//
//  BaseNextPageVC.h
//  GameGeek
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"//分享


@interface BaseNextPageVC : UIViewController <UMSocialUIDelegate>

ProStr(linkTitle);
ProStr(url);
ProStr(imageUrl);
ProStr(like);

@end
