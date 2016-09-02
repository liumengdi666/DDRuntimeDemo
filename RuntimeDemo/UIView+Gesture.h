//
//  UIView+Gesture.h
//  RuntimeDemo
//
//  Created by lmondi on 16/9/2.
//  Copyright © 2016年 MD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Gesture)

- (void)setTapActionWithBlock:(void (^)(void))block ;

@end
