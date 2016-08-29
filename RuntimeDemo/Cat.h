//
//  Cat.h
//  RuntimeDemo
//
//  Created by lmondi on 16/8/22.
//  Copyright © 2016年 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cat : NSObject<NSCoding>

@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)float age;

- (void)speak;

@end
