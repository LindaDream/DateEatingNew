//
//  YLoginViewController.m
//  DateEating
//
//  Created by user on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YRegisterViewController.h"
#import "YLoginViewController.h"
#import "YTabBarController.h"
@interface YRegisterViewController ()<
    UITextFieldDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate
>

@property (weak, nonatomic) IBOutlet UIImageView *userNameYesImgView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordYesImgView;
@property (weak, nonatomic) IBOutlet UIImageView *confirmYesImgView;
@property (weak, nonatomic) IBOutlet UIImageView *emailYesImgView;
@property(strong,nonatomic) UIImagePickerController *imgPicker;
@end

@implementation YRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.userNameYesImgView setHidden:YES];
    [self.passwordYesImgView setHidden:YES];
    [self.confirmYesImgView setHidden:YES];
    [self.emailYesImgView setHidden:YES];
    // 设置输入框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.userNameTF];
#pragma mark--给输入框设置键盘回收代理--
    self.userNameTF.delegate = self;
    self.passwordTF.delegate = self;
    self.confirmPasswordTF.delegate = self;
    self.emailTF.delegate = self;
// 设置头像
    [self setAvatar];
}
#pragma mark--通知--
- (void)textChange{
    if (self.userNameTF.text.length >= 4 && self.userNameTF.text.length <= 10 ) {
        self.userNameDefaultLabel.textColor = [UIColor lightGrayColor];
        [self.userNameYesImgView setHidden:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwordtextChange) name:UITextFieldTextDidChangeNotification object:self.passwordTF];
    }else if (self.userNameTF.text.length == 0){
        [self.userNameYesImgView setHidden:YES];
        self.userNameDefaultLabel.text = @"用户名长度必须满足4-10位字符";
         self.userNameDefaultLabel.textColor = [UIColor lightGrayColor];
    }else if(self.userNameTF.text.length < 4 || self.userNameTF.text.length > 10){
        [self.userNameYesImgView setHidden:YES];
        self.userNameDefaultLabel.text = @"用户名长度必须满足4-10位字符";
        self.userNameDefaultLabel.textColor = [UIColor redColor];

    }
}
- (void)passwordtextChange{
    if (self.passwordTF.text.length >= 6 && self.passwordTF.text.length <= 18) {
        self.passwordDefaultsLabel.textColor = [UIColor lightGrayColor];
        [self.passwordYesImgView setHidden:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmPasswordtextChange) name:UITextFieldTextDidChangeNotification object:self.confirmPasswordTF];
    }else if (self.passwordTF.text.length == 0){
        [self.passwordYesImgView setHidden:YES];
        self.passwordDefaultsLabel.text = @"密码长度必须满足6-18位字符";
        self.passwordDefaultsLabel.textColor = [UIColor lightGrayColor];
    }else if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 18){
        [self.passwordYesImgView setHidden:YES];
        self.passwordDefaultsLabel.text = @"密码长度必须满足6-18位字符";
        self.passwordDefaultsLabel.textColor = [UIColor redColor];
    }
}
- (void)confirmPasswordtextChange{
    if ([self.confirmPasswordTF.text isEqualToString:self.passwordTF.text]) {
        self.confirmDefaultLabel.textColor = [UIColor lightGrayColor];
        [self.confirmYesImgView setHidden:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emailtextChange) name:UITextFieldTextDidChangeNotification object:self.emailTF];
    }else if(![self.confirmPasswordTF.text isEqualToString:self.passwordTF.text]){
        self.confirmDefaultLabel.textColor = [UIColor redColor];
    }else if (self.confirmPasswordTF.text.length == 0){
        [self.confirmYesImgView setHidden:YES];
        self.confirmDefaultLabel.text = @"两次密码输入不一致";
        self.passwordDefaultsLabel.textColor = [UIColor lightGrayColor];
    }
}
- (void)emailtextChange{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if ([emailTest evaluateWithObject:self.emailTF.text]) {
        self.emailDefaultLabel.textColor = [UIColor lightGrayColor];
        [self.emailYesImgView setHidden:NO];
    }else if(![emailTest evaluateWithObject:self.emailTF.text]){
        self.emailDefaultLabel.text = @"请输入正确的邮箱";
        self.emailDefaultLabel.textColor = [UIColor redColor];
    }else if (self.emailTF.text.length == 0){
        [self.emailYesImgView setHidden:YES];
        self.emailDefaultLabel.text = @"请输入QQ、163邮或126邮箱";
        self.passwordDefaultsLabel.textColor = [UIColor lightGrayColor];
    }
}
#pragma mark--设置头像--
- (void)setAvatar{
    self.avatarImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(getPicture)];
    [self.avatarImgView addGestureRecognizer:tap];
   
}
- (void)getPicture{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择图片" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *camareAction = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
            self.imgPicker = [UIImagePickerController new];
            // 设置代理
            self.imgPicker.delegate = self;
            // 设置相机模式
            self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imgPicker animated:YES completion:nil];
        }else{
            // 创建UIAlertController
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"警告" message:@"没有相机功能" preferredStyle:(UIAlertControllerStyleAlert)];
            // 创建事件
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            // 添加事件
            [alertView addAction:okAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.imgPicker = [UIImagePickerController new];
        self.imgPicker.delegate = self;
        self.imgPicker.allowsEditing = YES;
        [self presentViewController:self.imgPicker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:camareAction];
    [alertView addAction:photoAction];
    [alertView addAction:cancelAction];
    [self presentViewController:alertView animated:YES completion:nil];

}
#pragma mark--调用相册代理方法--
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }else{
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    self.avatarImgView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark--注册按钮--
- (IBAction)registerAction:(id)sender {
#pragma mark--注册LeanCloud--
    AVUser *user = [AVUser user];
    user.username = self.userNameTF.text;
    user.password = self.passwordTF.text;
    user.email = self.emailTF.text;
    NSData *data = UIImageJPEGRepresentation(self.avatarImgView.image, 1);
    AVFile *file =  [AVFile fileWithName:@"avatar.png" data:data];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"%@",file.url);//返回一个唯一的 Url 地址
    }];
    [user setObject:file forKey:@"avatar"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功!" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
#pragma mark--注册环信--
                EMError *error = [[EMClient sharedClient] registerWithUsername:self.userNameTF.text password:self.passwordTF.text];
                if (error==nil) {
                    
                }else{
                        NSLog(@"%@",error);
                    }
                    YLoginViewController *loginVC = [YLoginViewController new];
                    [self presentViewController:loginVC animated:YES completion:nil];
                }];
                [alertView addAction:doneAction];
                [self presentViewController:alertView animated:YES completion:nil];
            }else{
                if (error.code == 202) {
                    [self.userNameYesImgView setHidden:YES];
                    self.userNameDefaultLabel.text = @"用户名已存在，请重新填写!";
                    self.userNameDefaultLabel.textColor = [UIColor redColor];
                }else if (error.code == 203){
                    [self.emailYesImgView setHidden:YES];
                    self.emailDefaultLabel.text = @"该邮箱已被占用,请更换邮箱!";
                    self.emailDefaultLabel.textColor = [UIColor redColor];
                }
            }
        }];
    });
}
#pragma mark--取消按钮--
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark--键盘回收--
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.userNameTF) {
        [self.passwordTF becomeFirstResponder];
    }else if (textField == self.passwordTF){
        [self.confirmPasswordTF becomeFirstResponder];
    }else if (textField == self.confirmPasswordTF){
        [self.emailTF becomeFirstResponder];
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
