//
//  DDModel.h
//  RuntimeDemo
//
//  Created by lmondi on 16/8/23.
//  Copyright © 2016年 MD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSecondModel.h"
#import "DDThirdModel.h"
#import "NSObject+DDLog.h"


@interface DDModel : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)int     age;
@property (nonatomic,copy)NSString *father;
@property (nonatomic,strong)DDSecondModel *secondModel;
@property (nonatomic,strong)NSArray <DDThirdModel *> *thirdModel;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
