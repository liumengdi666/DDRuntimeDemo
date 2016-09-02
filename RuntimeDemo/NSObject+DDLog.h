//
//  NSObject+DDLog.h
//  RuntimeDemo
//
//  Created by lmondi on 16/8/23.
//  Copyright © 2016年 MD. All rights reserved.
//

#import <Foundation/Foundation.h>


//@protocol MJKeyValue <NSObject>
//
//+ (NSDictionary *) objectClassInArray;
//
//@end

@interface NSObject (DDLog)


+ (instancetype)runtime_modelWithDict:(NSDictionary *)dict;
+ (NSArray *)properties1;
@end
