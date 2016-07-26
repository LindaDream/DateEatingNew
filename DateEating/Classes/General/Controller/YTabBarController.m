//
//  XMGTabBarController.m
//  百思不得姐
//
//  Created by lanou3g on 16/5/6.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "YTabBarController.h"
#import "YEssenceViewController.h"
#import "YFunnyViewController.h"
#import "YDateViewController.h"
#import "YMeViewController.h"
#import "YTabBar.h"
#import "YNavigationController.h"

@interface YTabBarController ()<EMContactManagerDelegate>

@end

@implementation YTabBarController

+ (void)initialize{

#pragma mark -- 通过appearance集体设置item文字样式
    // 方法后面带有UI_APPEARANCE_SELECTOR的方法，都可以通过appearance对象来统一设置
    // 未选中的样式字典
    NSMutableDictionary *attrs = [NSMutableDictionary new];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // 选中后的样式字典
    NSMutableDictionary *selectAttrs = [NSMutableDictionary new];
    selectAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:(UIControlStateNormal)];
    [item setTitleTextAttributes:selectAttrs forState:(UIControlStateSelected)];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
#pragma mark -- 添加子控制器
    [self setupChildVc:[[YEssenceViewController alloc] init] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    [self setupChildVc:[[YFunnyViewController alloc] init] title:@"趣事" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    [self setupChildVc:[[YDateViewController alloc] init] title:@"约会" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    [self setupChildVc:[[YMeViewController alloc] init] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    

   
    [self setValue:[[YTabBar alloc] init] forKey:@"tabBar"];
    
    
}


#pragma mark -- 初始化子控制器
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{

    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    YNavigationController *navc = [[YNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:navc];
    
    // 设置图片不需要蓝色渲染，保持原有颜色 代码繁琐
    //    UIImage *image = [UIImage imageNamed:@"tabBar_essence_click_icon"];
    //    image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];

}

// 用户B申请加A为好友后，用户A会收到这个回调
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage{
    NSLog(@"%@添加我为好友",aUsername);
    
    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
    if (!error) {
        NSLog(@"发送同意成功");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
