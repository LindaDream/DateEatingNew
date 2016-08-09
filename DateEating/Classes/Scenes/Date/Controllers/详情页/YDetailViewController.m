//
//  YDetailViewController.m
//  DateEating
//
//  Created by user on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YDetailViewController.h"
#import "YDetailHeaderTableViewCell.h"
#import "YChatTableViewCell.h"
#import "YNetWorkRequestManager.h"
#import "Request_Url.h"
#import "YChatMessageModel.h"
#import "YRestaurantDetailViewController.h"
#import "YUserDetailViewController.h"
#import <UMSocialData.h>
#import <UMSocialSnsService.h>
#import <UMSocialControllerService.h>
#import "UMSocial.h"
#import "YCaterDetail.h"
#import "YFaceView.h"
#import "YChatViewController.h"
#import "YContent.h"

@interface YDetailViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIScrollViewDelegate,
    YDetailHeaderTableViewCellDelegate,
    YChatTableViewCellDelegate,
    UMSocialUIDelegate,
    UITextFieldDelegate,
    YFaceViewDelegate,
    EMChatManagerDelegate
>


@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *messageArray;
@property (strong, nonatomic) NSMutableArray *ourMessageArray;
@property (assign, nonatomic) NSInteger messageCount;
@property (strong, nonatomic) NSMutableArray *layoutArray;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UITextField *message;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (assign,nonatomic) BOOL isSendMessage;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) YFaceView *faceView;
@property (assign, nonatomic) BOOL isEmoji;


@end

@implementation YDetailViewController

- (void)viewWillDisappear:(BOOL)animated {
    if (self.isListData) {
        self.passNewCount(self.layoutArray.count);
    }    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册键盘出现的代理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    // 注册键盘消失的代理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = @"详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置收藏分享按钮
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareBtnAction:)];
    self.navigationItem.rightBarButtonItem = shareBtn;
    
    // 注册
    [self.tableview registerNib:[UINib nibWithNibName:@"YDetailHeaderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YDetailHeaderTableViewCell_Identify];
    [self.tableview registerNib:[UINib nibWithNibName:@"YChatTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YChatTableViewCell_Indentify];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self refushData];
    // 请求数据
    [self getOurSeverData];
    [self getRequestData:0];
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    
    // 给输入框添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    self.message.returnKeyType = UIReturnKeyDone;
    self.message.delegate = self;
    self.sendBtn.enabled = NO;
    [self.sendBtn setBackgroundColor:YRGBColor(180, 180, 180)];
    
}

// 懒加载
- (NSMutableArray *)messageArray {
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}
- (NSMutableArray *)ourMessageArray {
    if (!_ourMessageArray) {
        _ourMessageArray = [NSMutableArray array];
    }
    return _ourMessageArray;
}
- (NSMutableArray *)layoutArray {
    if (!_layoutArray) {
        _layoutArray = [NSMutableArray array];
    }
    return _layoutArray;
}

#pragma mark -- 请求聊天信息 --
- (void)getRequestData:(NSInteger)start {
    __weak YDetailViewController *detailVC = self;
    [YNetWorkRequestManager getRequestWithUrl:ChatMessageRequest_Url(self.model.ID,start) successRequest:^(id dict) {
        NSNumber *count = dict[@"data"][@"total"];
        detailVC.messageCount = count.integerValue;
        [detailVC.messageArray addObjectsFromArray:[YChatMessageModel getDateContentListWithDic:dict]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [detailVC reloadData];
        });
    } failurRequest:^(NSError *error) {
        
    }];
}
#pragma mark -- 请求自己的评论数据 --
- (void)getOurSeverData {
    NSString *eventId;
    if (self.model.ourSeverMark) {
        eventId = [NSString stringWithFormat:@"%@%@",self.model.user.nick,self.model.dateTime];
    } else {
        eventId = [NSString stringWithFormat:@"%@%ld",self.model.user.nick,self.model.eventDateTime];
    }
    __weak typeof(self) weakSelf = self;
    AVQuery *query = [AVQuery queryWithClassName:@"eventCount"];
    [query whereKey:@"eventId" equalTo:eventId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count != 0) {
            if (weakSelf.isSendMessage) {
                [self.ourMessageArray removeAllObjects];
                weakSelf.isSendMessage = NO;
            }
            for (AVObject *object in objects) {
                NSDictionary *dict = [object dictionaryForObject];
                YChatMessageModel *model = [YChatMessageModel new];
                model.isOurData = YES;
                model.user = [YActionUserModel new];
                model.user.nick = [dict objectForKey:@"user"];
                NSString *replayUserName = [dict objectForKey:@"replayUser"];
                if (![replayUserName isEqualToString:weakSelf.model.user.nick]) {
                    model.replyUser = [YActionUserModel new];
                    model.replyUser.nick = replayUserName;
                }
                NSString *eventId = [dict objectForKey:@"eventId"];
                model.eventId = eventId.integerValue;
                model.content = [dict objectForKey:@"content"];
                model.createTime = [[dict objectForKey:@"createTime"] integerValue];
                [weakSelf.ourMessageArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reloadData];
            });
        }
    }];
}

- (void)reloadData {
    [self.layoutArray removeAllObjects];
    [self.layoutArray addObjectsFromArray:self.messageArray];
    [self.layoutArray addObjectsFromArray:self.ourMessageArray];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
    [self.layoutArray sortUsingDescriptors:@[sort]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"count" object:nil userInfo:@{@"count":[NSString stringWithFormat:@"%ld",self.layoutArray.count]}];
    [self.tableview reloadData];
}

#pragma mark -- 上拉加载 --
- (void)refushData {
    // 尾
    MJRefreshAutoNormalFooter *footerHot = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData:)];
    [footerHot setTitle:@"" forState:MJRefreshStateIdle];
    [footerHot setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footerHot setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    footerHot.stateLabel.font = [UIFont systemFontOfSize:17];
    footerHot.stateLabel.textColor = YRGBColor(248, 89, 64);
    self.tableview.mj_footer = footerHot;
}

- (void)loadMoreHotData:(MJRefreshAutoNormalFooter *)footer {
    if (self.messageArray.count >= self.messageCount) {
        footer.state = MJRefreshStateNoMoreData;
        return;
    }
    [self getRequestData:self.messageArray.count];
    [footer endRefreshing];
}

#pragma mark -- 分享按钮的响应事件 --
- (void)shareBtnAction:(UIBarButtonItem *)item {
    
    NSString *url = [NSString stringWithFormat:@"http://www.qingchifan.com/event/detail/%ld", self.model.ID];
    // 分享字符串
    NSString *shareString = [NSString stringWithFormat:@"【%@，%@！】%@ 简单的生活，纷繁的世界 #约起来#带你到别人的世界走走", self.model.user.nick, self.model.eventName, url];
    // 分享图片
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.model.caterPhotoUrl];
    
    [UMSocialData defaultData].extConfig.title = shareString;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"578c9832e0f55a30cb003483"
                                      shareText:shareString
                                     shareImage:nil
                                shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms]
                                       delegate:self];
}

#pragma mark -- 餐厅详情按钮代理 --
- (void)restaurantBtnDidClicked:(YDetailHeaderTableViewCell *)cell {
    
     YRestaurantDetailViewController *detailVC = [[YRestaurantDetailViewController alloc]init];
    if (self.model.ourSeverMark) {
        detailVC.fromDetailVC = YES;
        detailVC.ourSeverMark = YES;
        detailVC.businessId = self.model.caterBusinessId;
        detailVC.nameStr = self.model.eventLocation;
    } else {
        detailVC.fromDetailVC = YES;
        detailVC.eventId = self.model.ID;
        detailVC.nameStr = self.model.eventLocation;
    }
    [self.navigationController pushViewController:detailVC animated:YES];  
}

// 点击头像的代理方法
- (void)userImageDidTap:(NSInteger)userId {
    YUserDetailViewController *userDetailVC = [[YUserDetailViewController alloc]init];
    userDetailVC.userId = userId;
    [self.navigationController pushViewController:userDetailVC animated:YES];
}
#pragma mark--聊天按钮代理方法--
- (void)chatBtnDidClicked:(YDetailHeaderTableViewCell *)cell{
    if ([cell.model.user.nick isEqualToString:[AVUser currentUser].username]) {
        [self showAlertViewWithMessage:@"不能和自己聊天"];
    }else{
        [self saveChatFriendsWithName:cell.model.user.nick avatarUrl:cell.model.user.userImageUrl];
        YChatViewController *chatVC = [YChatViewController new];
        chatVC.title = cell.model.user.nick;
        chatVC.toName = cell.model.user.nick;
        chatVC.key = @"username";
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}
- (void)saveChatFriendsWithName:(NSString *)name avatarUrl:(NSString *)avatarUrl{
    
    [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"select * from _User where username = '%@'",name] callback:^(AVCloudQueryResult *result, NSError *error) {
        if (result.results.count != 0) {
            NSLog(@"已经存在");
        }else if(error != nil){
            NSLog(@"%ld",error.code);
        }else if(result.results.count == 0){
            [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"select * from ChatFriendsList where friendName = '%@'",name] callback:^(AVCloudQueryResult *result, NSError *error) {
                if (result.results.count != 0) {
                    NSLog(@"已经存在");
                }else if(error != nil){
                    NSLog(@"%ld",error.code);
                }else if (result.results.count == 0) {
                    AVObject *object = [[AVObject alloc ]initWithClassName:@"ChatFriendsList"];
                    [object setObject:name forKey:@"friendName"];
                    [object setObject:avatarUrl forKey:@"avatarUrl"];
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"======保存成功");
                        }
                    }];
                }
            }];
        }
    }];
    
    
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

// 用户A同意用户B的加好友请求后，用户B会收到这个回调

- (void)didReceiveAgreedFromUsername:(NSString *)aUsername{
    NSLog(@"%@同意了我的好友申请",aUsername);
    YChatViewController *chatVC = [YChatViewController new];
    chatVC.title = aUsername;
    chatVC.toName = aUsername;
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

#pragma mark -- 弹出表情框 --
- (IBAction)addFaceBtnAction:(id)sender {
    YFaceView *faceView = [[YFaceView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    if (_isEmoji == NO) {
        _isEmoji = YES;
        //呼出表情
        [self.message becomeFirstResponder];
        faceView.delegate = self;
        self.message.inputView = faceView;
        [self.message reloadInputViews];
    }else{
        _isEmoji = NO;
        self.message.inputView=nil;
        [self.message reloadInputViews];
    }
}

#pragma mark -- 点击表情后的代理回调 --
- (void)changeKeyBoardBtnDidSelect {
    _isEmoji = NO;
    self.message.inputView=nil;
    [self.message reloadInputViews];
}
- (void)collectionViewCellDidSelected:(NSString *)face {
    self.message.text = [NSString stringWithFormat:@"%@%@",self.message.text,face];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
}
- (void)deleteBtnDidSelected {
    [self.message deleteBackward];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark -- 评论 --
- (IBAction)sendBtnDidClick:(id)sender {
    
    if (self.message.text.length == 0) {
        NSLog(@"不能为空");
    }else{
        
        NSString *userName = [AVUser currentUser].username;
        NSString *eventId;
        if (self.model.ourSeverMark) {
            eventId = [NSString stringWithFormat:@"%@%@",self.model.user.nick,self.model.dateTime];
        } else {
            eventId = [NSString stringWithFormat:@"%@%ld",self.model.user.nick,self.model.eventDateTime];
        }
        NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
        NSString *createTime = [NSString stringWithFormat:@"%ld",(NSInteger)time];
        AVObject *contentObject = [[AVObject alloc] initWithClassName:@"eventCount"];
        [contentObject setObject:userName forKey:@"user"];
        [contentObject setObject:self.model.user.nick forKey:@"replayUser"];
        [contentObject setObject:eventId forKey:@"eventId"];
        [contentObject setObject:self.message.text forKey:@"content"];
        [contentObject setObject:createTime forKey:@"createTime"];
        [contentObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (succeeded) {
                    [self showAlertViewWithMessage:@"评论成功"];
                    _isSendMessage = YES;
                    [self getOurSeverData];
                    self.message.text = @"";
                    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
                }else{
                    [self showAlertViewWithMessage:@"评论失败，请稍后重试"];
                    NSLog(@"%ld",error.code);
                }
            });
        }];
    }
}

- (void)showReport{
    [self showAlertViewWithMessage:@"举报成功，我们将尽快处理！"];
}

- (void)textFieldTextDidChange {
    if (self.message.text.length == 0 ) {
        [self.sendBtn setBackgroundColor:YRGBColor(180, 180, 180)];
        self.sendBtn.enabled = NO;
    } else {
        self.sendBtn.backgroundColor = YRGBColor(234, 78, 56);
        self.sendBtn.enabled = YES;
    }
}

#pragma mark -- textField代理 --
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -- 滚动视图键盘消失 --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.message resignFirstResponder];
    _isEmoji = NO;
    self.message.inputView = nil;
}

#pragma mark -- 键盘通知触发的方法 --
- (void)keyboardWasShown:(NSNotification*)aNotification {
    CGRect keyboardBounds;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    CGRect btnFrame = self.view.frame;
    btnFrame.origin.y = -keyboardBounds.size.height;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    
    // set views with new info
    self.view.frame = btnFrame;
    // commit animations
    [UIView commitAnimations];
}
// 键盘消失
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect btnFrame = self.view.frame;
    btnFrame.origin.y = 0;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.view.frame = btnFrame;
    
    // commit animations
    [UIView commitAnimations];
    //[self.faceBtn setImage:[UIImage imageNamed:@"emoji_"] forState:UIControlStateNormal];
    //self.lineView.backgroundColor = YRGBColor(180, 180, 180);
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

#pragma mark -- tableview 实现的代理方法 --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.layoutArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YDetailHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YDetailHeaderTableViewCell_Identify forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = self.model;
        cell.userLocation = self.userLocation;
        return cell;
    } else {
        YChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YChatTableViewCell_Indentify forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.layoutArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self.message becomeFirstResponder];
        
        YChatMessageModel * model= self.layoutArray[indexPath.row];
        self.message.text = [NSString stringWithFormat:@"回复%@:",model.user.nick];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [YDetailHeaderTableViewCell getHeightForCellWithActivity:self.model];
    }else {
        return [YChatTableViewCell getHeightForCellWithActivity:self.layoutArray[indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 15;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 15)];
    view.backgroundColor = YRGBColor(220, 220, 220);
    return view;
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
