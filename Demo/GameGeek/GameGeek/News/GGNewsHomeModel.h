//
//  GGNewsHomeModel.h
//  GameGeek
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//
/*
 本demo所有页面共用此model
 */
#import "JSONModel.h"


//第二层
@protocol GGNewsHomeSecondModel

@end

@interface GGNewsHomeSecondModel : JSONModel

@property (nonatomic, strong) NSNumber *TYPESETTING;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSNumber *PUBLISH;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *CTIME;
@property (nonatomic, copy) NSString *imglink;
@property (nonatomic, copy) NSString *imglink_1;
@property (nonatomic, copy) NSString *imglink_2;
@property (nonatomic, copy) NSString *imglink_3;
@property (nonatomic, strong) NSNumber *talkcount;
@property (nonatomic, strong) NSNumber *readarts;
@property (nonatomic, strong) NSNumber *sharearts;
@property (nonatomic, strong) NSNumber *DELFLAG;
@property (nonatomic, copy) NSString *sourcename;
@property (nonatomic, strong) NSNumber *likecount;
@property (nonatomic, strong) NSNumber *SORT;
@property (nonatomic, strong) NSNumber *OPENSOURCE;
@property (nonatomic, strong) NSNumber *recommond;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *content168;
@property (nonatomic, strong) NSNumber *faved;
@property (nonatomic, copy) NSString *TYPE;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *videolink;
@property (nonatomic, copy) NSString *titlespelling;

//发售表页字段
//@property (nonatomic, copy) NSString *TYPE;
@property (nonatomic, copy) NSString *gametype;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *comp;
//@property (nonatomic, copy) NSString *CTIME;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *mongodb_name;
//@property (nonatomic, strong) NSNumber *SORT;
@property (nonatomic, copy) NSString *externalid;
@property (nonatomic, copy) NSString *word;
//@property (nonatomic, strong) NSNumber *likecount;
@property (nonatomic, strong) NSNumber *shareexts;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *pdate;
//@property (nonatomic, strong) NSNumber *DELFLAG;
@property (nonatomic, strong) NSNumber *melikecount;

@end

//第一层
@interface GGNewsHomeModel : JSONModel

@property (nonatomic,strong) NSArray<GGNewsHomeSecondModel>*rootList;

@end


