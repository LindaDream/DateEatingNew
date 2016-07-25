//
//  XMGNavigationController.m
//  百思不得姐
//
//  Created by lanou3g on 16/5/13.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "YNavigationController.h"

@interface YNavigationController ()

@end

@implementation YNavigationController

/**
 *  当第一次使用这个类的时候回调用一次
 */
+ (void)initialize{
    
    // 设置导航栏背景图片 第二种做法appearance 这样做有个弊端，无论以后用自定义的XMGNavigationController，还是系统的UINavigationController，背景图片都是这样的。解决这个弊端的方法是下边这个猪似的
    // 当导航栏用在XMGNavigationController中，apprearance设置才会生效
    //UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:(UIBarMetricsDefault)];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.tintColor = [UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1];
    
    // 设置导航栏背景图片 第一种做法
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:(UIBarMetricsDefault)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 这个方法可以拦截所有push进来的导航控制器，统一设置左按钮为返回
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
    if (self.childViewControllers.count > 0) {// 如果push进来的不是第一个试图控制器
        
        UIButton *bankButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [bankButton setTitle:@"返回" forState:(UIControlStateNormal)];
        [bankButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:(UIControlStateNormal)];
        [bankButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:(UIControlStateHighlighted)];
        bankButton.size = CGSizeMake(70, 30);
        
        //[bankButton sizeToFit];// 使按钮大小适应文字
        
        // 控制button中文字的内容
        //bankButton.contentMode = UIViewContentModeLeft;// 内容模式 带Scale的拉伸，不带的不拉伸，具体可以点进去找。但是这个方法只对View管用，对于button来说，有专门的方法
        bankButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;// 使按钮内部的所有内容左对齐
        [bankButton setTitleColor:[UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1] forState:(UIControlStateNormal)];
        // -10是按钮上的内容向左边跑10。正数是向右边跑
        bankButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        
        [bankButton addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bankButton];
        
        // 当push到其他界面时隐藏标签栏
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    // 这个必须写,写到最后，当试图创建时候，会覆盖自定义的返回，这样就可以自己设置了用自己的，自己不设置，就用这个“返回”
    [super pushViewController:viewController animated:YES];
    
    //    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:nil action:nil];
    
}

- (void)back:(UIButton *)button{
    [self popViewControllerAnimated:YES];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
