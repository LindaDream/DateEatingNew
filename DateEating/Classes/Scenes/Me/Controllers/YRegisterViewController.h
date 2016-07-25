//
//  YLoginViewController.h
//  DateEating
//
//  Created by user on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameDefaultLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordDefaultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmDefaultLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailDefaultLabel;

@end
