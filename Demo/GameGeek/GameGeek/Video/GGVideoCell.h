//
//  GGVideoCell.h
//  GameGeek
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGVideoHomeModel.h"
@protocol GGVideoCellDelegate <NSObject>

-(void)shareVideoWith:(NSString *)videoU andWith:(NSString *)imageU andWith:(NSString *)title;

@end
@interface GGVideoCell : UITableViewCell

ProStr(linkTitle);
ProStr(videoUrl);
ProStr(imageUrl);

@property(strong,nonatomic)id<GGVideoCellDelegate>delegate;

-(void)setUIWith:(GGNewsHomeSecondModel *)model;

@end
