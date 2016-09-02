//
//  Dog+AddProperty.m
//  RuntimeDemo
//
//  Created by lmondi on 16/9/1.
//  Copyright © 2016年 MD. All rights reserved.
//

#import "Dog+AddProperty.h"
#import <objc/runtime.h>

static char *associatedObjectKey;
@implementation Dog (AddProperty)

- (NSString *)master {
//    return objc_getAssociatedObject(self, _cmd);
    return objc_getAssociatedObject(self, associatedObjectKey);;
}



//id object给谁设置关联对象。
//
//const void *key关联对象唯一的key，获取时会用到。
//
//id value关联对象。
//
//objc_AssociationPolicy关联策略，有以下几种策略：


//OBJC_ASSOCIATION_ASSIGN
//OBJC_ASSOCIATION_RETAIN_NONATOMIC
//OBJC_ASSOCIATION_COPY_NONATOMIC
//OBJC_ASSOCIATION_RETAIN
//OBJC_ASSOCIATION_COPY

- (void)setMaster:(NSString *)master {
    //设置关联对象
//    objc_setAssociatedObject(self, @selector(master), master, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, associatedObjectKey, master, OBJC_ASSOCIATION_RETAIN_NONATOMIC); //获取关联对象
}

//注意：这里面我们把master方法的地址作为唯一的key，_cmd代表当前调用方法的地址。
@end
