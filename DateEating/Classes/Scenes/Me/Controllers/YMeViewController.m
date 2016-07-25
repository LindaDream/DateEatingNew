//
//  XMGMeViewController.m
//  百思不得姐
//
//  Created by lanou3g on 16/5/6.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "YMeViewController.h"
#import "YRegisterViewController.h"
#import "YClearTableViewCell.h"
#import "YLoginViewController.h"
#import "YTabBarController.h"
#import <MessageUI/MessageUI.h>
#import "YAttentionListViewController.h"
#import "YCompleteViewController.h"
#import "YMyPublishViewController.h"
#import "YMyCollectionViewController.h"
#import "YFriendsViewController.h"
@interface YMeViewController ()<
    UITableViewDataSource,
    UITableViewDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    MFMailComposeViewControllerDelegate
>
@property(strong,nonatomic)UITableView *meTableView;
@property(strong,nonatomic)UIView *headView;
@property(strong,nonatomic)UIImageView *headImgView;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UIButton *loginButton;
@property(strong,nonatomic)UILabel *emailLabel;
@property(strong,nonatomic)UIButton *completeBtn;
@property(strong,nonatomic)UIImagePickerController *imagePicker;
// 点击设置按钮后的覆盖视图
@property(strong,nonatomic)UIView *coverView;
// 设置列表
@property(strong,nonatomic)UITableView *listTableView;
// 判断是否开启夜间模式
@property(strong,nonatomic)NSString *isNight;
// 模糊视图
@property(strong,nonatomic)UIVisualEffectView *visualView;
@property(assign,nonatomic) int tempCount;
@property(strong,nonatomic)EMConversation *conversation;
@end
// 我的界面cell标识符
static NSString *const clearCellIdentifier = @"clearCell";
// 设置列表cell标识符
static NSString *const listCellIdentifier = @"listCell";

@implementation YMeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([AVUser currentUser]) {
        self.nameLabel.text = [AVUser currentUser].username;
        self.emailLabel.text = [AVUser currentUser].email;
        [self.loginButton setTitle:@"注销" forState:(UIControlStateNormal)];
        AVFile *file = [[AVUser currentUser] objectForKey:@"avatar"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.headImgView.image = [UIImage imageWithData:data];
            });
        } progressBlock:^(NSInteger percentDone) {
            
        }];
    }else{
        self.nameLabel.text = @"未登录";
        self.headImgView.image = [UIImage imageNamed:@"head_img"];
        self.emailLabel.text = @"未登录";
        [self.loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
    }
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.unreadMessageCount = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnreadMessageCount:) name:@"unreadMessageCount" object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 接收加号按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateView:) name:@"DateButtonClicked" object:nil];
    self.isNight = @"1";
    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏右边的按钮
    UIBarButtonItem *settingButton = [UIBarButtonItem itemWithImage:@"mine-setting-icon" heightImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    UIBarButtonItem *nightModeButton = [UIBarButtonItem itemWithImage:@"mine-moon-icon" heightImage:@"mine-moon-icon-click" target:self action:@selector(nightModeClick)];
    self.navigationItem.rightBarButtonItems = @[settingButton,nightModeButton];
    [self addMeTableView];
    [self addHeadView];
}
#pragma mark--获取未读消息条数--
- (void)getUnreadMessageCount:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    self.userName = [userInfo objectForKey:@"userName"];
    self.conversation = [[EMClient sharedClient].chatManager getConversation:self.userName type:(EMConversationTypeChat) createIfNotExist:YES];
    self.tempCount = self.conversation.unreadMessagesCount;
    self.unreadMessageCount = self.tempCount;
    if (self.unreadMessageCount > 0) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",self.unreadMessageCount];
    }else{
        self.tabBarItem.badgeValue = nil;
    }

}
#pragma mark--加号按钮通知方法--
- (void)dateView:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *num = [userInfo objectForKey:@"isClicked"];
    if (num.boolValue) {
        self.meTableView.userInteractionEnabled = NO;
        [self addDateBtnAndPartyBtn];
    }else{
        self.meTableView.userInteractionEnabled = YES;
        [self removeDateBtnAndPartyBtn];
    }
}

#pragma mark--设置tableview--
- (void)addMeTableView{
    self.meTableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    self.meTableView.backgroundColor = [UIColor whiteColor];
    self.meTableView.delegate = self;
    self.meTableView.dataSource = self;
    [self.meTableView registerNib:[UINib nibWithNibName:@"YClearTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:clearCellIdentifier];
    [self.view addSubview:self.meTableView];
}
#pragma mark--设置头部视图--
- (void)addHeadView{
    // 设置头部视图
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    // 模糊视图
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:self.headView.frame];
    backImgView.image = [UIImage imageNamed:@"head.jpg"];
    backImgView.contentMode = UIViewContentModeScaleToFill;
    backImgView.userInteractionEnabled = YES;
    // 模糊样式
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)];
    // 根据模糊样式创建视图
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.visualView = visualView;
    visualView.frame = self.headView.frame;
    visualView.userInteractionEnabled = YES;
    [backImgView addSubview:visualView];
    
    // 设置头像
    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 25, 50, 50)];
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 25;
    self.headImgView.image = [UIImage imageNamed:@"head_img"];
    self.headImgView.userInteractionEnabled = YES;
    self.headImgView.layer.borderWidth = 2;
    self.headImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(changeAvtar)];
    [self.headImgView addGestureRecognizer:tap];
    [visualView addSubview:self.headImgView];
    
    // 设置用户名
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame) + 20, CGRectGetMinY(self.headImgView.frame), 100, 30)];
    self.nameLabel.text = @"未登录";
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor colorWithRed:0.0 green:124.99/255.0 blue:29.62/255.0 alpha:1];
    [visualView addSubview:self.nameLabel];
    
    // 设置邮箱标签
    self.emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 20, 250, 30)];
    self.emailLabel.text = @"未登录";
    self.emailLabel.backgroundColor = [UIColor clearColor];
    self.emailLabel.textColor = [UIColor colorWithRed:0.0 green:124.99/255.0 blue:29.62/255.0 alpha:1];
    [visualView addSubview:self.emailLabel];
    
    // 设置登录、注销按钮
    self.loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.loginButton.frame = CGRectMake(CGRectGetMinX(self.emailLabel.frame) + 25, CGRectGetMaxY(self.emailLabel.frame) + 20, 50, 30);
    self.loginButton.backgroundColor = [UIColor clearColor];
    [self.loginButton setTitleColor:[UIColor colorWithRed:0.0 green:124.99/255.0 blue:29.62/255.0 alpha:1] forState:(UIControlStateNormal)];
    [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
    [visualView addSubview:self.loginButton];
    
    // 完善资料
    self.completeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.completeBtn.frame = CGRectMake(self.headView.width - 90, self.loginButton.frame.origin.y, 80, 30);
    [self.completeBtn setTitle:@"完善资料" forState:(UIControlStateNormal)];
    [self.completeBtn setTitleColor:[UIColor colorWithRed:0.0 green:124.99/255.0 blue:29.62/255.0 alpha:1] forState:(UIControlStateNormal)];
    [self.completeBtn addTarget:self action:@selector(completeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [visualView addSubview:self.completeBtn];
    
    [self.headView addSubview:backImgView];
    [self.meTableView setTableHeaderView:self.headView];
}
#pragma mark--登录--
- (void)loginAction:(UIButton *)loginBtn{
    if ([loginBtn.titleLabel.text isEqualToString:@"登录"]) {
        YLoginViewController *loginVC = [YLoginViewController new];
        [self presentViewController:loginVC animated:YES completion:nil];
    }else{
        [AVUser logOut];
        [[EMClient sharedClient].options setIsAutoLogin:NO];
        [self.meTableView reloadData];
        [self addHeadView];
    }
}
#pragma mark--完善资料--
- (void)completeAction:(UIButton *)btn{
    YCompleteViewController *completeVC = [YCompleteViewController new];
    [self.navigationController pushViewController:completeVC animated:YES];
}
#pragma mark--更换头像--
- (void)changeAvtar{
    if ([AVUser currentUser]) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择图片" preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *camareAction = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
                self.imagePicker = [UIImagePickerController new];
                // 设置代理
                self.imagePicker.delegate = self;
                // 设置相机模式
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePicker animated:YES completion:nil];
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
        UIAlertAction *pictureAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            self.imagePicker = [UIImagePickerController new];
            // 创建代理
            self.imagePicker.delegate = self;
            // 允许编辑图片
            self.imagePicker.allowsEditing = YES;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertView addAction:camareAction];
        [alertView addAction:pictureAction];
        [alertView addAction:cancelAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}
#pragma mark--设置头像图片的代理方法--
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = nil;
    // 判断从哪里获取图片
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // 修改前的image
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }else{
        // 可编辑UIImagePickerControllerEditedImage(获取编辑后的图片)
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    // 设置图片
    self.headImgView.image = image;
    // 执行 CQL 语句实现更新一个 user 对象
    NSData *data = UIImageJPEGRepresentation(self.headImgView.image, 1);
    AVFile *file = [AVFile fileWithName:@"avatarNew.png" data:data];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[AVUser currentUser] setObject:file forKey:@"avatar"];
        [[AVUser currentUser] saveInBackground];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark--夜间模式--
- (void)nightModeClick{
    if ([AVUser currentUser]) {
        // 发送通知
        // 变为夜间模式
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNight" object:nil userInfo:@{@"isNight":self.isNight}];
        if ([self.isNight isEqualToString:@"1"]) {
            [self changeToNight];
            self.visualView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            [self.meTableView reloadData];
            self.isNight = @"0";
        }else{
            [self changeToDay];
            self.visualView.backgroundColor = [UIColor clearColor];
            self.isNight = @"1";
        }
    }else{
        YLoginViewController *loginVC = [YLoginViewController new];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
#pragma mark--设置--
- (void)settingClick{
    if ([AVUser currentUser]) {
        self.coverView = [[UIView alloc] initWithFrame:self.meTableView.frame];
        self.coverView.backgroundColor = [UIColor blackColor];
        self.coverView.alpha = 0.5;
        [self.meTableView addSubview:self.coverView];
        [UIView animateWithDuration:0.5 animations:^{
            // 设置view的背景图片
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MineBackGround.jpg"]]];
            self.navigationController.navigationBarHidden = YES;
            self.meTableView.frame = CGRectMake(-self.meTableView.frame.size.width / 2.0 - 50, 100, kScreenWidth, kScreenHeight);
            // 偏移之后添加手势恢复
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
            [pan addTarget:self action:@selector(panAction:)];
            [self.meTableView addGestureRecognizer:pan];
        }];
        // 添加设置列表
        self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.meTableView.frame) + 50, CGRectGetMinY(self.meTableView.frame) + 100, 150, 250) style:(UITableViewStylePlain)];
        self.listTableView.backgroundColor = [UIColor clearColor];
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:listCellIdentifier];
        [self.view addSubview:self.listTableView];
    }else if(nil == [AVUser currentUser]){
        YLoginViewController *loginVC = [YLoginViewController new];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
- (void)panAction:(UIPanGestureRecognizer *)pan{
    [UIView animateWithDuration:0.5 animations:^{
        self.meTableView.frame = self.view.frame;
        [self.coverView removeFromSuperview];
        self.navigationController.navigationBarHidden = NO;
        [self.listTableView removeFromSuperview];
    }];
}
#pragma mark--tableView代理方法--
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.meTableView) {
        return 1;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.meTableView) {
        return 5;
    }
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.meTableView) {
        YClearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:clearCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.imgView.image = [UIImage imageNamed:@"mine_about"];
            cell.cellNameLabel.text = @"我的收藏";
        }else if (indexPath.row == 1) {
            cell.imgView.image = [UIImage imageNamed:@"mine_committed"];
            cell.cellNameLabel.text = @"我发起的";
        }else if (indexPath.row == 2) {
            cell.imgView.image = [UIImage imageNamed:@"mine_save"];
            cell.cellNameLabel.text = @"我的关注";
        }else if (indexPath.row == 3) {
            cell.imgView.image = [UIImage imageNamed:@"message"];
            cell.cellNameLabel.text = @"我的消息";
        }else{
            cell.imgView.image = [UIImage imageNamed:@"mine_clear"];
            cell.cellNameLabel.text = @"清除缓存";
            float size = [self folderSizeAtPath:kCachesPath];
            cell.cacheLabel.text = [NSString stringWithFormat:@"%.2fM",size];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"免责声明";
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"意见反馈";
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"当前版本";
        }else if(indexPath.row == 3){
            cell.textLabel.text = @"关于我们";
        }else{
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(25, 10, 50, 30);
            [button setTitle:@"退出" forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [button setBackgroundColor:[UIColor redColor]];
            [button addTarget:self action:@selector(exitAction) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.contentView addSubview:button];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.meTableView) {
        if (indexPath.row == 0) {
            if ([AVUser currentUser]) {
                YMyCollectionViewController *collectVC = [YMyCollectionViewController new];
                [self.navigationController pushViewController:collectVC animated:YES];
            }else{
                YLoginViewController *loginVC = [YLoginViewController new];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
        }else if (indexPath.row == 1) {
            if ([AVUser currentUser]) {
                YMyPublishViewController *publishListVC = [YMyPublishViewController new];
                [self.navigationController pushViewController:publishListVC animated:YES];
            }else{
                YLoginViewController *loginVC = [YLoginViewController new];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
        }else if (indexPath.row == 2) {
            if ([AVUser currentUser]) {
                YAttentionListViewController *attentionListVC = [YAttentionListViewController new];
                [self.navigationController pushViewController:attentionListVC animated:YES];
            }else{
                YLoginViewController *loginVC = [YLoginViewController new];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
        }else if (indexPath.row == 3) {
            if ([AVUser currentUser]) {
                YFriendsViewController *friendsVC = [YFriendsViewController new];
                self.tabBarItem.badgeValue = nil;
                self.tempCount = 0;
                [self.conversation markAllMessagesAsRead];
                [self.navigationController pushViewController:friendsVC animated:YES];
            }else{
                YLoginViewController *loginVC = [YLoginViewController new];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
        }else{
            __weak typeof(self)mySelf = self;
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认清楚缓存?" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [mySelf clearCache:kCachesPath];
                [mySelf.meTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:4 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
            [alertView addAction:doneAction];
            [alertView addAction:cancelAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }else{
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            // 发送邮件进行反馈
            
            // 创建一个MFMailComposeViewController视图控制器
            MFMailComposeViewController *mcVC = [MFMailComposeViewController new];
            // 设置代理
            mcVC.mailComposeDelegate = self;
            // 判断当前是否支持发送邮件
            if ([MFMailComposeViewController canSendMail]) {
                // 设置收件人
                [mcVC setToRecipients:@[@"2696380320@qq.com"]];
                // 设置抄送
                [mcVC setCcRecipients:@[@"2696380320@qq.com"]];
                [mcVC setSubject:@"意见反馈"];
                // 邮件正文
                NSString *mailBody = [NSString stringWithFormat:@"约起来,感谢你宝贵的反馈,我们会不断完善"];
                [mcVC setMessageBody:mailBody isHTML:NO];
                [self presentViewController:mcVC animated:YES completion:nil];
            }else{
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前设备不支持发送邮件功能" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:(UIAlertActionStyleCancel) handler:nil];
                [alertView addAction:cancelAction];
                [self presentViewController:alertView animated:YES completion:nil];
            }
        }else if (indexPath.row == 2){
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前版本是1.0!" preferredStyle:(UIAlertControllerStyleAlert)];
            [self presentViewController:alertView animated:YES completion:nil];
            // 实现0.3秒回收
            [self performSelector:@selector(actionDismissAlertView:) withObject:alertView afterDelay:0.1];
        }else if (indexPath.row == 3){
            
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.meTableView) {
        return 46;
    }
    return 50;
}

// 回收当前版本alertView
- (void)actionDismissAlertView:(UIAlertController *)alertView{
    [alertView dismissViewControllerAnimated:YES completion:nil];
}

// 退出按钮
- (void)exitAction{
    [AVUser logOut];
    [[EMClient sharedClient].options setIsAutoLogin:NO];
    YTabBarController *tabBarVC = [YTabBarController new];
    [self presentViewController:tabBarVC animated:YES completion:nil];
}

// 计算文件大小
- (float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize] /1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

// 计算单个文件
- (float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}
// 清理缓存文件
- (void)clearCache:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childFile = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childFile) {
            NSString *absolutedPath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutedPath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
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
