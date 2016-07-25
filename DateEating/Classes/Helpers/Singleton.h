//
//  Singleton.h
//  DouBanProject
//
//  Created by lanou3g on 16/5/9.
//  Copyright © 2016年 春晓. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

// 宏单例
// 单例声明  "\"连接两行代码使用  className是传进来什么类名，就可以创建什么类的单例  ##用于拼接参数
#define singleton_interface(className)\
+ (instancetype)shared##className

// 单例得实现
#define singleton_implementaton(className)\
static className *manager;\
+ (instancetype)shared##className{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        manager = [[[self class] alloc] init];\
    });\
    return manager;\
}


#endif /* Singleton_h */
