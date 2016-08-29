//
//  Person.m
//  RuntimeDemo
//
//  Created by lmondi on 16/8/22.
//  Copyright © 2016年 MD. All rights reserved.
//

#import "Person.h"

@interface Person ()

@property (nonatomic,copy)NSString *imName;

@end

@implementation Person
{
    float imAge;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"乔布斯";
        age = 10;
        _imName = @"乔布斯二世";
        imAge = 100;
    }
    return self;
}
- (void)speak {
    NSLog(@"人：我是人");
}

+ (void)dance {
    NSLog(@"人人都会跳舞");
}

- (void)test {
    NSLog(@"test协议");
}

@end
