//
//  GGVideoCell.m
//  GameGeek
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "GGVideoCell.h"
#import "UIImageView+AFNetworking.h"


@interface GGVideoCell ()

@property (strong, nonatomic) IBOutlet UIImageView *videoImage;
@property (strong, nonatomic) IBOutlet UIImageView *shareImageV;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation GGVideoCell

-(void)setUIWith:(GGNewsHomeSecondModel *)model{
    _titleLabel.text = [NSString stringWithFormat:@" %@",model.title];
    _timeLabel.text = [NSString stringWithFormat:@" #%@/%@",model.sourcename,model.duration];
    [_videoImage setImageWithURL:[NSURL URLWithString:model.imglink] placeholderImage:[UIImage imageNamed:@"gamegeekwithword01"]];
    
    //传入分享所需链接
    self.videoUrl = model.videolink;
    self.imageUrl = model.imglink;
    self.linkTitle = model.title;
    
    _shareImageV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sharevideo:)];
    [_shareImageV addGestureRecognizer:tap];
    
}

-(void)sharevideo:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareVideoWith:andWith:andWith:)]) {
        [self.delegate shareVideoWith:self.videoUrl andWith:self.imageUrl andWith:self.linkTitle];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
