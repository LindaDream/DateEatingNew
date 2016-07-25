//
//  YOpenViewController.m
//  DateEating
//
//  Created by user on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YOpenViewController.h"
#import "YLoginViewController.h"
#import "YRegisterViewController.h"
@interface YOpenViewController ()

@end

@implementation YOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark--登录--
- (IBAction)loginAction:(id)sender {
    YLoginViewController *loginVC = [YLoginViewController new];
    [self presentViewController:loginVC animated:YES completion:nil];
}
#pragma mark--注册--
- (IBAction)registerAction:(id)sender {
    YRegisterViewController *registerVC = [YRegisterViewController new];
    [self presentViewController:registerVC animated:YES completion:nil];
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
