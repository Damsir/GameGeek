//
//  GGNewsCell.m
//  GameGeek
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "GGNewsCell.h"

#import "UIImageView+AFNetworking.h"

@interface GGNewsCell ()

@property (strong, nonatomic) IBOutlet UILabel *titelLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *recommendLab;
@property (strong, nonatomic) IBOutlet UIButton *eyeBtn;
@property (strong, nonatomic) IBOutlet UIButton *messageBtn;

@end

@implementation GGNewsCell


-(void)setUIWith:(GGNewsHomeSecondModel *)info{
    _titelLabel.text = [NSString stringWithFormat:@" %@",info.title];
    [_imageV setImageWithURL:[NSURL URLWithString:info.imglink] placeholderImage:[UIImage imageNamed:@"gamegeekwithword01"]];
    if (info.sharearts) {
        _recommendLab.text = [NSString stringWithFormat:@"  %@人推荐",info.sharearts];
    }
    
    _eyeBtn.tintColor = FONT_TINT_COLOR;
    _messageBtn.tintColor = FONT_TINT_COLOR;
    [_eyeBtn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    if (info.readarts) {
        [_eyeBtn setTitle:[NSString stringWithFormat:@"  %@",info.readarts] forState:UIControlStateNormal];
    }
    
    [_messageBtn setImage:[UIImage imageNamed:@"message_mini"] forState:UIControlStateNormal];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
