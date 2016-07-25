//
//  YLoginViewController.m
//  DateEating
//
//  Created by user on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YLoginViewController.h"
#import "YTabBarController.h"
@interface YLoginViewController ()<UITextFieldDelegate>

@end

@implementation YLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 键盘回收
    self.userNameTF.delegate = self;
    self.passwordTF.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark--登录按钮--
- (IBAction)loginAction:(id)sender {
    [AVUser logInWithUsernameInBackground:self.userNameTF.text password:self.passwordTF.text block:^(AVUser *user, NSError *error) {
        if (nil != user) {
            [[EMClient sharedClient] loginWithUsername:self.userNameTF.text password:self.passwordTF.text];
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            [[NSUserDefaults standardUserDefaults] setObject:self.userNameTF.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setObject:self.passwordTF.text forKey:@"passWord"];
            YTabBarController *tabBarVC = [YTabBarController new];
            [self presentViewController:tabBarVC animated:YES completion:nil];
        } else if(error.code == 210){
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名与密码不匹配!" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                //[self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertView addAction:doneAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }];
}
#pragma mark--取消按钮--
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark--找回密码--
- (IBAction)resetPasswordAction:(id)sender {
    
}
#pragma mark--键盘回收--
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.userNameTF) {
        [self.userNameTF becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
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
