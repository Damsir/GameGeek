//
//  GGListCell.m
//  GameGeek
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "GGListCell.h"
#import "UIImageView+AFNetworking.h"

@interface GGListCell()
@property (strong, nonatomic) IBOutlet UIImageView *GGListImageV;
@property (strong, nonatomic) IBOutlet UILabel *GGListNameLab;
@property (strong, nonatomic) IBOutlet UILabel *GGListTimeLab;
@property (strong, nonatomic) IBOutlet UILabel *GGListTypeLab;
@property (strong, nonatomic) IBOutlet UILabel *GGListCompLab;


@end
@implementation GGListCell

-(void)setUIWith:(GGNewsHomeSecondModel *)model{
    [_GGListImageV setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"gamegeekwithword01"]];
    _GGListNameLab.text = model.name;
    _GGListTimeLab.text = [NSString stringWithFormat:@"发行日期: %@",model.CTIME];
    _GGListTypeLab.text = [NSString stringWithFormat:@"游戏类型: %@",model.gametype];
    _GGListCompLab.text = [NSString stringWithFormat:@"制作发行: %@",model.comp];
    
   
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
