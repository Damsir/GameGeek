//
//  GGNewsHomeModel.m
//  GameGeek
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "GGNewsHomeModel.h"

@implementation GGNewsHomeModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper{
    JSONKeyMapper *keyMapper = [[JSONKeyMapper alloc]initWithDictionary:@{@"root.list":@"rootList"}];
    return keyMapper;
}

@end


@implementation GGNewsHomeSecondModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end