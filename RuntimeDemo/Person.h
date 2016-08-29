//
//  Person.h
//  RuntimeDemo
//
//  Created by lmondi on 16/8/22.
//  Copyright © 2016年 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestDelegate <NSObject>

- (void)test;

@end

@interface Person : NSObject<TestDelegate>
{
    float age;
}
@property (nonatomic,copy)NSString *name;

- (void)speak;

+ (void)dance;

@end
