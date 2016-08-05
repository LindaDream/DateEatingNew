//
//  XMGTabBarController.m
//  DateEating
//
//  Created by user on 16/5/6.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "YTabBarController.h"
#import "YEssenceViewController.h"
#import "YFunnyViewController.h"
#import "YDateViewController.h"
#import "YMeViewController.h"
#import "YTabBar.h"
#import "YNavigationController.h"
#import "YLoginViewController.h"
#import "YRegisterViewController.h"
#import "YMeViewController.h"

@interface YTabBarController ()<EMContactManagerDelegate,EMClientDelegate>

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
    
    // 去除发布按钮上边的黑线
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
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
}

// 用户B申请加A为好友后，用户A会收到这个回调
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage{
    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
    if (!error) {
        NSLog(@"发送同意成功");
    }
    
}
/*!
 @method
 @brief 接收到好友请求时的通知
 @discussion
 @param username 发起好友请求的用户username
 @param message  收到好友请求时的say hello消息
 */
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message{
    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:username];
    if (!error) {
        NSLog(@"发送同意成功");
    }
}
/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)didLoginFromOtherDevice{
    [AVUser logOut];
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passWord"];
        YMeViewController *meVC = (YMeViewController *)[[self.childViewControllers lastObject].childViewControllers lastObject];
        [meVC.meTableView reloadData];
        [meVC addHeadView];
    }else{
        NSLog(@"%d",error.code);
    }
    NSString *date = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您的账号于%@异地被登录，是否重新登录?",date] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        YLoginViewController *loginVC = [YLoginViewController new];
        [self presentViewController:loginVC animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView addAction:doneAction];
    [alertView addAction:cancelAction];
    [self presentViewController:alertView animated:YES completion:nil];
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
