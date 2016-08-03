//
//  YChatViewController.m
//  DateEating
//
//  Created by lanou3g on 16/7/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YChatViewController.h"
#import "YChatSendViewCell.h"
#import "YChatRecieveViewCell.h"
#import "YReceiveImgViewCell.h"
#import "YSendImgTableViewCell.h"
#import "YContent.h"
#import "YFaceView.h"
#import "YBigImgViewController.h"
@interface YChatViewController ()<
    UITextViewDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    EMChatManagerDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    YFaceViewDelegate,
    EMContactManagerDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (weak, nonatomic) IBOutlet UITextView *chatTextView;

@property (weak, nonatomic) IBOutlet UIButton *faceBtn;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property(assign,nonatomic)CGFloat keyBoardHeight;
// 存放发送的消息
@property(strong,nonatomic)NSMutableArray *msgArray;
@property(strong,nonatomic)UIImagePickerController *pickerController;
@property (strong,nonatomic) UIImage *friendHeadImage;

@property (strong,nonatomic) UIImage *myHeadImage;

@property (assign, nonatomic) BOOL isEmoji;

@end

static NSString *const receiveCell = @"receiveCell";
static NSString *const sendCell = @"sendCell";
static NSString *const sendImgCell = @"sendImgCell";
static NSString *const receiveImgCell = @"reveiveImgCell";

@implementation YChatViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatTextView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    // 消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessage:) name:@"unreadMessageCount" object:nil];
    [self getHeadImage];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = self.toName;
    // 注册输入框通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upWithKeyBoard) name:UITextViewTextDidChangeNotification object:self.chatTextView];
    // 注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    // 注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    self.chatTextView.delegate = self;
    [self.chatTableView registerClass:[YChatSendViewCell class] forCellReuseIdentifier:sendCell];
    [self.chatTableView registerClass:[YChatRecieveViewCell class] forCellReuseIdentifier:receiveCell];
    [self.chatTableView registerClass:[YSendImgTableViewCell class] forCellReuseIdentifier:sendImgCell];
    [self.chatTableView registerClass:[YReceiveImgViewCell class] forCellReuseIdentifier:receiveImgCell];
    [self becomeFriends];
    // 创建会话
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:self.toName type:EMConversationTypeChat createIfNotExist:YES];
    // 获取聊天消息
    self.msgArray = [conversation loadMoreMessagesContain:nil before:-1 limit:20 from:nil direction:(EMMessageSearchDirectionUp)].mutableCopy;
    [self.chatTableView reloadData];
    [self scrollToBottom];
}
- (void)becomeFriends{
    
    [YContent getContentAvatarWithUserName:self.toName key:self.key  SuccessRequest:^(id dict) {
        if ([dict isEqualToString:@"该用户不存在"]) {
            [self showAlertViewWithMessage:@"该用户不在线"];
        }else{
            
            NSString *eventName = [self.toName lowercaseString];
            EMError *error1 = nil;
            NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error1];
            
            if (!error1) {
                NSLog(@"获取成功 -- %@",userlist);
                BOOL isHave = NO;
                for (NSString *userName in userlist) {
                    if ([userName isEqualToString:eventName]) {
                        isHave = YES;
                    }
                }
                
                if (!isHave) {
                    EMError *error = [[EMClient sharedClient].contactManager addContact:eventName message:@"我想加您为好友"];
                    if (!error) {
                        NSLog(@"添加成功");
                    }else if (error.code == 201){
                        [self showAlertViewWithMessage:@"用户未登录"];
                    }else if (error.code == 300){
                        [self showAlertViewWithMessage:@"服务器未连接"];
                    }else if (error.code == 301){
                        [self showAlertViewWithMessage:@"连接服务器超时"];
                    }else if (error.code == 302){
                        [self showAlertViewWithMessage:@"服务器忙碌"];
                    }
                }
            }else{
                NSLog(@"%d",error1.code);
            }
        }
    } failurRequest:^(NSError *error) {
    }];
    
    
}
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername{
    NSLog(@"%@同意了我的好友申请",aUsername);
}
#pragma mark--收到的消息--
- (void)getMessage:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSArray *msgArr = [userInfo objectForKey:@"messageArray"];
    for (EMMessage *msg in msgArr) {
        if ([msg.conversationId isEqualToString:self.toName]) {
            [self.msgArray addObject:msg];
        }
    }
    [self.chatTableView reloadData];
    [self scrollToBottom];
}
- (void)getHeadImage{
    
    [YContent getContentAvatarWithUserName:self.toName SuccessRequest:^(id dict) {
        if (dict != nil) {
            UIImageView *imgView1 = [[UIImageView alloc] init];
            [imgView1 sd_setImageWithURL:[NSURL URLWithString:dict]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.friendHeadImage = imgView1.image;
                [self.chatTableView reloadData];
            });
        }
    } failurRequest:^(NSError *error) {
        NSLog(@"获取friendHeadImage失败");
    }];
    AVUser *user = [AVUser currentUser];
    [YContent getContentAvatarWithUserName:user.username SuccessRequest:^(id dict) {
        if (dict != nil) {
            UIImageView *imgView2 = [[UIImageView alloc] init];
            [imgView2 sd_setImageWithURL:[NSURL URLWithString:dict]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.myHeadImage = imgView2.image;
                [self.chatTableView reloadData];
            });
        }
    } failurRequest:^(NSError *error) {
        NSLog(@"获取friendHeadImage失败");
    }];
}

#pragma mark--点击输入框通知方法--
- (void)upWithKeyBoard{
    if (self.chatTextView.text.length > 0) {
        [self.sendBtn setTitle:@"发送" forState:(UIControlStateNormal)];
        [self.sendBtn setFont:[UIFont systemFontOfSize:15.0]];
    }else{
        [self.sendBtn setTitle:@"十" forState:(UIControlStateNormal)];
    }
}
#pragma mark--键盘通知方法--
- (void)keyBoardShow:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    NSValue *value = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyBoardSize = [value CGRectValue].size;
    self.keyBoardHeight = keyBoardSize.height;
    CGRect rect = self.view.frame;
    rect.origin.y = -self.keyBoardHeight ;
    //取出动画时长
    NSTimeInterval duration = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //使用动画更改self.view.frame
    [UIView animateWithDuration:duration animations:^{
        //这里填入一些view的最终状态属性设置，即会自动产生过渡动画
        self.view.frame = rect;
    }];
}
- (void)keyBoardHide:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    CGRect rect = CGRectMake(0, 0, self.view.width, self.view.height);
    //取出动画时长
    NSTimeInterval duration = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //使用动画更改self.view.frame
    [UIView animateWithDuration:duration animations:^{
        //这里填入一些view的最终状态属性设置，即会自动产生过渡动画
        self.view.frame = rect;
    }];
}
// 滑动tableView实现键盘回收
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.chatTableView) {
        [self.sendView endEditing:YES];
    }
}
#pragma mark--发送文字、图片--
- (IBAction)sendAction:(id)sender {
    __weak typeof(self)weakSelf = self;
    if (self.chatTextView.text.length > 0 && [self.sendBtn.titleLabel.text isEqualToString:@"发送"]) {
        // 发送文字
        // TODO:构造文字消息
        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:weakSelf.chatTextView.text];
        NSString *from = [[EMClient sharedClient] currentUsername];
        // 生成Message
        EMMessage *meaasge = [[EMMessage alloc] initWithConversationID:weakSelf.toName from:from to:weakSelf.toName body:body ext:nil];
        meaasge.chatType = EMChatTypeChat;
        // TODO:发送消息
        [[EMClient sharedClient].chatManager asyncSendMessage:meaasge progress:nil completion:^(EMMessage *message, EMError *error) {
            if (!error) {
                NSLog(@"发送成功");
                [weakSelf.msgArray addObject:meaasge];
                // 主线程刷新view
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 发送之后将textView置为空，发送按钮变为"十"
                    weakSelf.chatTextView.text = nil;
                    [weakSelf.sendBtn setTitle:@"十" forState:(UIControlStateNormal)];
                    [weakSelf.sendBtn setFont:[UIFont systemFontOfSize:20.0]];
                    [weakSelf.chatTableView reloadData];
                    [weakSelf scrollToBottom];
                });
            }else{
                NSLog(@"%u",error.code);
            }
        }];
    }else if([self.sendBtn.titleLabel.text isEqualToString:@"十"]){
        // 发送图片
        // TODO:构造图片信息
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择图片" preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            // 判断是否为相机模式
            if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
                self.pickerController = [UIImagePickerController new];
                self.pickerController.delegate = self;
                self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.pickerController animated:YES completion:nil];
            }else{
                UIAlertController *alertView1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"未检测到相机!" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
                [alertView1 addAction:okAction];
                [self presentViewController:alertView1 animated:YES completion:nil];
            }
        }];
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self invokePhoto];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alertView addAction:camera];
        [alertView addAction:photoAction];
        [alertView addAction:cancelAction];
        [self presentViewController:alertView animated:YES completion:nil];
        
    }
    }

- (void)invokePhoto{
    self.pickerController = [UIImagePickerController new];
    self.pickerController.delegate = self;
    self.pickerController.allowsEditing = YES;
    [self presentViewController:self.pickerController animated:YES completion:nil];
}
#pragma mark--相册代理方法--
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // 修改之前的图片
        img = [info objectForKey:UIImagePickerControllerOriginalImage];
    }else{
        // 可编辑UIImagePickerControllerEditedImage（获取编辑后的图片）
        img = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    // 设置图片
    NSData *data = UIImageJPEGRepresentation(img, 1);
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:data displayName:@"image.png"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.toName from:from to:self.toName body:body ext:nil];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
#pragma mark--发送消息--
    __weak typeof(self)weakSelf = self;
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            NSLog(@"发送成功");
            // 把发送的消息增加到消息数组中
            [weakSelf.msgArray addObject:aMessage];
            // 在主线程中刷新view
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.chatTextView.text = nil;
                [self.sendBtn setTitle:@"十" forState:(UIControlStateNormal)];
                [weakSelf.chatTableView reloadData];
                [weakSelf scrollToBottom];
            });
        }else{
            NSLog(@"%u",aError.code);
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark--发送表情--
- (IBAction)faceSendAction:(id)sender {
    YFaceView *faceView = [[YFaceView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    if (_isEmoji == NO) {
        _isEmoji = YES;
        //呼出表情
        [self.chatTextView becomeFirstResponder];
        faceView.delegate = self;
        self.chatTextView.inputView = faceView;
        [self.chatTextView reloadInputViews];
    }else{
        _isEmoji = NO;
        self.chatTextView.inputView=nil;
        [self.chatTextView reloadInputViews];
    }
}
#pragma mark -- 表情回调 --
- (void)changeKeyBoardBtnDidSelect {
    _isEmoji = NO;
    self.chatTextView.inputView=nil;
    [self.chatTextView reloadInputViews];
}
- (void)collectionViewCellDidSelected:(NSString *)face {
    self.chatTextView.text = [NSString stringWithFormat:@"%@%@",self.chatTextView.text,face];
    [self upWithKeyBoard];
}
- (void)deleteBtnDidSelected {
    [self.chatTextView deleteBackward];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.chatTextView];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.msgArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMMessage *message = self.msgArray[indexPath.row];
    // 获取消息体的内容
    EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
    EMImageMessageBody *imgBody = (EMImageMessageBody *)message.body;
    if (message.direction == 0) {
        // 发送的消息
        if (message.body.type == 1) {
            YChatSendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sendCell forIndexPath:indexPath];
            // 发送文字
            cell.headImg = self.myHeadImage;
            cell.message = textBody.text;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }if (message.body.type == 2) {
            YSendImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sendImgCell forIndexPath:indexPath];
            // 发送图片
            NSString *path = imgBody.localPath;
            cell.sendImg = [UIImage imageWithContentsOfFile:path];
            cell.headImg = self.myHeadImage;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (message.direction == 1){
        if (message.body.type == 1) {
            // 接收文字
            YChatRecieveViewCell *cell = [tableView dequeueReusableCellWithIdentifier:receiveCell forIndexPath:indexPath];
            cell.headImg = self.friendHeadImage;
            cell.message = textBody.text;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (message.body.type == 2){
            // 接收图片
            YReceiveImgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:receiveImgCell forIndexPath:indexPath];
            NSString *path = imgBody.remotePath;
            NSURL *url = [NSURL URLWithString:path];
            NSData *data = [NSData dataWithContentsOfURL:url];
            cell.receiveImg = [UIImage imageWithData:data];
            cell.headImg = self.friendHeadImage;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    EMMessage *message = self.msgArray[indexPath.row];
    // 获取消息体的内容
    EMImageMessageBody *imgBody = (EMImageMessageBody *)message.body;
    if (message.direction == 0) {
        if (message.body.type == 2) {
            NSString *path = imgBody.localPath;
            UIImage *img = [UIImage imageWithContentsOfFile:path];
            YBigImgViewController *bigImgVC = [YBigImgViewController new];
            bigImgVC.img = img;
            [self presentViewController:bigImgVC animated:YES completion:nil];
        }
    }else if (message.direction == 1){
        if (message.body.type == 2){
            NSString *path = imgBody.remotePath;
            NSURL *url = [NSURL URLWithString:path];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageWithData:data];
            YBigImgViewController *bigImgVC = [YBigImgViewController new];
            bigImgVC.img = img;
            [self presentViewController:bigImgVC animated:YES completion:nil];
        }
    }
    
}

#pragma mark--滑到tableView最后--
- (void)scrollToBottom{
    if (self.msgArray.count < 1) {
        return;
    }else{
        // 获取tableview最后一行
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.msgArray.count - 1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMMessage *message = self.msgArray[indexPath.row];
    EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
    if (message.body.type == 1) {
        return [YChatSendViewCell heightForCellWithMessage:textBody.text];
    }else if (message.body.type == 2){
        return 200;
    }
    return 0;
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //移除好友回调
    [[EMClient sharedClient].contactManager removeDelegate:self];
    
}

// 弹框
- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 1秒后回收
    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1.5];
    [self presentViewController:alertView animated:YES completion:nil];
}
- (void)dismissAlertView:(UIAlertController *)alertView
{
    [alertView dismissViewControllerAnimated:YES completion:nil];
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
