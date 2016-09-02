//
//  ViewController.m
//  RuntimeDemo
//
//  Created by lmondi on 16/8/22.
//  Copyright © 2016年 MD. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Dog.h"
#import "Cat.h"
#import "Mouse.h"
#import "Jerry.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "DDModel.h"
#import "NSObject+DDLog.h"
#import "Dog+AddProperty.h"
#import "UIView+Gesture.h"

@interface ViewController ()
{
    Person *p;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //runtime基础学习
    [self log];
    //字典转model
    [self dicToModel];
    //归档解挡
    [self keyAchive];
    //关联对象
    [self assocObject];
}
- (void)log {
    p = [[Person alloc] init];
    p.name = @"d";
    Class pCls = [Person class];
    NSLog(@"==========类与对象============");
    // 获取类的类名
    // const char * class_getName ( Class cls );
    const char *class_name = class_getName([Person class]);
    NSLog(@"class_name = %s",class_name);
    // 获取类的父类
    //Class class_getSuperclass ( Class cls );
    id super_class = class_getSuperclass([Person class]);
    NSLog(@"super_class = %@",NSStringFromClass(super_class));
    // 判断给定的Class是否是一个元类
    //BOOL class_isMetaClass ( Class cls );
    BOOL ret_Person = class_isMetaClass([Person class]);
    BOOL ret_NSObject = class_isMetaClass([NSObject class]);
    NSLog(@"%d %d",ret_Person,ret_NSObject);
    // 获取实例大小
    //size_t class_getInstanceSize ( Class cls );
    size_t size = class_getInstanceSize([Person class]);
    NSLog(@"%zu",size);
    
    NSLog(@"==========成员变量(ivars)及属性============");
    // 成员变量
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(pCls, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        
        Ivar ivar = ivars[i];
        
        NSLog(@"instance variable's name: %s at index: %d", ivar_getName(ivar), i);
        
    }
    free(ivars);
    // 获取类中指定名称实例成员变量的信息
    //Ivar class_getInstanceVariable ( Class cls, const char *name );
    Ivar name_p = class_getInstanceVariable([Person class], "_name");
    NSLog(@"name_p = %s",ivar_getName(name_p));
    
    NSLog(@"==========属性操作============");
    // 属性操作
    
    objc_property_t * properties = class_copyPropertyList(pCls, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSLog(@"property's name: %s", property_getName(property));
        
    }
    free(properties);
    objc_property_t pro_name = class_getProperty(pCls, "name");
    NSLog(@"property %s", property_getName(pro_name));

    
    NSLog(@"==========方法操作============");
    // 方法操作
    
    Method *methods = class_copyMethodList(pCls, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        
        Method method = methods[i];
        
        NSLog(@"method's signature: %@", NSStringFromSelector(method_getName(method)));
        
    }
    
    free(methods);
    
    Method method1 = class_getInstanceMethod(pCls, @selector(speak));
    NSLog(@"method1: %@", NSStringFromSelector(method_getName(method1)));
    
    IMP imp = class_getMethodImplementation(pCls, @selector(speak));
    imp();
    
    
    NSLog(@"===========协议===========");
    // 协议
    // 返回类实现的协议列表
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(pCls, &outCount);
    
    Protocol * protocol;
    
    for (int i = 0; i < outCount; i++) {
        
        protocol = protocols[i];
        
        NSLog(@"protocol name: %s", protocol_getName(protocol));
        
    }
    // 返回类是否实现指定的协议
     NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(pCls, protocol) ? @"" : @" not", protocol_getName(protocol));
    NSLog(@"==========动态创建类============");
//objc_allocateClassPair
    Class cls = objc_allocateClassPair([Person class], "Bob", 0);
    class_addMethod(cls, @selector(addMethod), (IMP)add, "v@:");
    class_replaceMethod(cls, @selector(speak), (IMP)add, "v@:");
    class_addIvar(cls, "son", sizeof(NSString *), log(sizeof(NSString *)), "@");
    objc_property_attribute_t type = {"T","@\"NSString\""};
    objc_property_attribute_t ownership = {"C",""};
    objc_property_attribute_t backingivar = {"V","_privateName"};
    objc_property_attribute_t attrs[] = {type,ownership,backingivar};
    class_addProperty(cls, "_privateName", attrs, 3);
    class_addIvar(cls, "_privateName", sizeof(NSString *), log(sizeof(NSString *)), "@");

    class_addMethod([Person class], @selector(name1), (IMP)name1Getter, "@@:");
    class_addMethod([Person class], @selector(setName1:), (IMP)name1Setter, "v@:@");
    objc_registerClassPair(cls);
    id c = [[cls alloc]init];
    [c performSelector:@selector(addMethod)];
    [c performSelector:@selector(speak)];
    NSLog(@"c name = %@",[c performSelector:@selector(name1)]);
    [c performSelector:@selector(setName1:) withObject:@"jock"];
    NSLog(@"c name = %@",[c performSelector:@selector(name1)]);
    
    NSLog(@"======================");
    Mouse *m = [[Mouse alloc] init];

    object_setClass(m, [Jerry class]);
    [m speak];
    id cc = objc_lookUpClass("Dog");
    NSLog(@"%@",cc);

}
void add(id self,SEL _cmd) {
    NSLog(@"add");
}
NSString *name1Getter(id self, SEL _cmd) {
    Ivar ivar = class_getInstanceVariable([self class], "_privateName");
    return object_getIvar(self, ivar);
}

void name1Setter(id self, SEL _cmd, NSString *newName) {
    Ivar ivar = class_getInstanceVariable([self class], "_privateName");
    id oldName = object_getIvar(self, ivar);
    if (oldName != newName) object_setIvar(self, ivar, [newName copy]);
}

/****************************字典转模型*****************************/
- (void)dicToModel {
    NSDictionary *dic = @{@"name":@"jobs",
                          @"age":@100,
                          @"farther":@"jobs's father",
                          @"girlFriend":@"😃",
                          
                          @"secondModel":@{@"mother":@"jobs's mother",
                                           @"height":@180},
                          
                          @"thirdModel":@[@{@"brother":@"jobs's brother",
                                            @"weight":@200},
                                          
                                          @{@"brother":@"jobs's brother1",
                                            @"weight":@210},
                                          
                                          @{@"brother":@"jobs's brother2",
                                            @"weight":@220}]};
    //kvc赋值
//    DDModel *dm = [DDModel modelWithDict:dic];
    //runtime赋值
    DDModel *dm = [DDModel runtime_modelWithDict:dic];
    NSLog(@"%@",dm);
    [DDModel properties1];
}

- (void)keyAchive {
    Cat *c = [[Cat alloc] init];
    c.name = @"Tom";
    c.age = 1;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"testCat"];
    [NSKeyedArchiver archiveRootObject:c toFile:filePath];
    
    Cat *aCat = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"acat.name = %@  age = %f",aCat.name,aCat.age);
}

- (void)assocObject {
    //添加属性 dog新增了分类
    Dog *d = [[Dog alloc] init];
    d.master = @"jobs";
    
    NSLog(@"%@",d.master);
    
    
    //绑定手势  新增了uiview的分类添加方法
    
    [self.view setTapActionWithBlock:^{
        NSLog(@"我是一个点击手势");
    }];
    
}


@end
