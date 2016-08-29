//
//  DDModel.m
//  RuntimeDemo
//
//  Created by lmondi on 16/8/23.
//  Copyright © 2016年 MD. All rights reserved.
//

#import "DDModel.h"
#import <objc/runtime.h>

@implementation DDModel

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    NSLog(@"key = %@",key);
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"undefinedkey = %@",key);
}
+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    DDModel *model = [[self alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
    
}


//- (NSDictionary *)arrayContainModelClass {
//    return @{@"thirdModel":@"DDThirdModel"};
//}
+ (NSDictionary *)objectClassInArray
{
    return @{@"thirdModel":@"DDThirdModel"};
}
@end
