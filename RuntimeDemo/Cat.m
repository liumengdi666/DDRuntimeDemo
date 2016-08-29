//
//  Cat.m
//  RuntimeDemo
//
//  Created by lmondi on 16/8/22.
//  Copyright © 2016年 MD. All rights reserved.
//

#import "Cat.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation Cat

- (void)speak {
    NSLog(@"猫：我是🐱");
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        //最笨的方法
//        self.name = [coder decodeObjectForKey:@"name"];
//        self.age  = [coder decodeFloatForKey:@"age"];

        u_int count;
        Ivar *ivarList = class_copyIvarList(self.class, &count);
        
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivarList[i];
            NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
            const void *typeEncoding = ivar_getTypeEncoding(ivar);
            NSString *type = [NSString stringWithUTF8String:typeEncoding];
    
            NSString *key = [ivarName substringFromIndex:1];
            NSString * firstChar = [key substringToIndex:1].uppercaseString;
            NSString *setSelName = [NSString stringWithFormat:@"set%@%@:",firstChar,[key substringFromIndex:1]];
            if (0) {//纯runtime方法
                //这里去判断各种type类型 这里只列出了float类型的
                if ([self respondsToSelector:NSSelectorFromString(setSelName)]) {
                    if ([type isEqualToString:@"f"]) {
                        float(*action)(id,SEL,float) = (float(*)(id,SEL,float))objc_msgSend;
                        NSNumber *value = [coder decodeObjectForKey:key];
                        action(self,NSSelectorFromString(setSelName),value.floatValue);
                    }else{
                        float(*action)(id,SEL,id) = (float(*)(id,SEL,id))objc_msgSend;
                        id value = [coder decodeObjectForKey:key];
                        action(self,NSSelectorFromString(setSelName),value);
                        
                    }
                }
            }else {//second method KVC
                
                //如果用kvc的方式可以省去类型判断
                //[self valueForKey:key];
                id value = [coder decodeObjectForKey:key];
                [self setValue:value forKey:key];
            }
           
           
            
            
        }
        free(ivarList);
        
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
//    [coder encodeObject:self.name forKey:@"name"];
//    [coder encodeFloat:self.age forKey:@"age"];
    
    
    u_int count;
    Ivar *ivarList = class_copyIvarList(self.class, &count);
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        const void *typeEncoding = ivar_getTypeEncoding(ivar);
        NSString *type = [NSString stringWithUTF8String:typeEncoding];
        NSLog(@"type = %@",type);
        NSString *key = [ivarName substringFromIndex:1];
        if (0) {
            if ([self respondsToSelector:NSSelectorFromString(key)]) {
                
                if ([type isEqualToString:@"f"]) {
                    
                    //performSelector 返回类型为id 实际age为float类型，所以这里会崩
                    //                id value = [self performSelector:NSSelectorFromString(key)];
                    //                void(*action)(id,SEL) = (void(*)(id,SEL))objc_msgSend;
                    float(*action)(id,SEL) = (float(*)(id,SEL))objc_msgSend;
                    float value = action(self,NSSelectorFromString(key));
                    [coder encodeObject:@(value) forKey:key];
                }else {
                    //                id value = [self performSelector:NSSelectorFromString(key)];
                    id(*action)(id,SEL) = (id(*)(id,SEL))objc_msgSend;
                    id value = action(self,NSSelectorFromString(key));
                    
                    [coder encodeObject:value forKey:key];
                }
            }
        }
        else{
        //kvc
            id value = [self valueForKey:key];
            
            [coder encodeObject:value forKey:key];
        }
        
        }
        
         free(ivarList);
    
}
    




- (NSArray *)propertyList {
    u_int count;
    Ivar *ivarList = class_copyIvarList(self.class, &count);
    
    NSMutableArray *properNames = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        const void *typeEncoding = ivar_getTypeEncoding(ivar);
        NSString *type = [NSString stringWithUTF8String:typeEncoding];
        
        NSString *key = [ivarName substringFromIndex:1];

        [properNames addObject:key];
    }
    free(ivarList);
    return [properNames copy];
}

@end
