//
//  YFriendsViewController.m
//  DateEating
//
//  Created by lanou3g on 16/7/22.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YFriendsViewController.h"
#import "YFriendsTableViewCell.h"
#import "YFriends.h"
#import "YChatViewController.h"

@interface YFriendsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *frientsListTableView;

// 好友列表
@property (strong,nonatomic) NSMutableArray *friendsArr;
@end

static NSString *const friendsListCellId = @"friendsListCellId";

@implementation YFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsArr = [NSMutableArray new];
    // 注册cell
    [self.frientsListTableView registerNib:[UINib nibWithNibName:@"YFriendsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:friendsListCellId];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getAllFriends];
}
#pragma mark--获取所有好友列表--
- (void)getAllFriends{

    self.friendsArr = [YFriends getFriend].mutableCopy;
    if (self.friendsArr.count > 0) {
        [self.frientsListTableView reloadData];
    }else{
        [self showAlertViewWithMessage:@"您还没有好友"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--UITableViewDataSource--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.friendsArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendsListCellId forIndexPath:indexPath];
    YFriends *model = self.friendsArr[indexPath.row];
    for (NSString *key in [self.conversationDict allKeys]) {
        if ([key isEqualToString:model.friendName]) {
            if ([self.conversationDict[key] integerValue] > 0) {
                cell.unreadCountLabel.backgroundColor = [UIColor redColor];
                cell.unreadCountLabel.text = [NSString stringWithFormat:@"%@",self.conversationDict[key]];
            }else{
                cell.unreadCountLabel.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    cell.friends = self.friendsArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 62;
    
}

#pragma mark--UITableViewDataSource--
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YChatViewController *chatVC = [YChatViewController new];
    YFriends *friend = self.friendsArr[indexPath.row];
    YFriendsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:friend.friendName type:(EMConversationTypeChat) createIfNotExist:YES];
    [conversation markAllMessagesAsRead];
    NSInteger count = self.unreadCount - cell.unreadCountLabel.text.integerValue;
    [self.conversationDict setObject:[NSNumber numberWithInteger:0] forKey:friend.friendName];
    self.passValueBlock([NSNumber numberWithInteger:count],self.conversationDict);
    cell.unreadCountLabel.text = nil;
    [cell.unreadCountLabel removeFromSuperview];
    chatVC.toName = friend.friendName;
    [self.navigationController pushViewController:chatVC animated:YES];
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
#pragma mark--删除会话--
- (void)deleteConversation:(NSString *)userID{
    [[EMClient sharedClient].chatManager deleteConversation:userID deleteMessages:YES];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YFriends *friend = self.friendsArr[indexPath.row];
        [self deleteConversation:friend.friendName];
        [self.friendsArr removeObject:friend];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        [self.frientsListTableView reloadData];
    }
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
