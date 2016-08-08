//
//  YMyPublishViewController.m
//  DateEating
//
//  Created by user on 16/7/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YMyPublishViewController.h"
#import "YDateOrPartyTableViewCell.h"
#import "YDateContentModel.h"
#import "YDetailViewController.h"
#import <SVProgressHUD.h>
@interface YMyPublishViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,deletePassDateOrParty>
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateOrPartySegment;
@property (weak, nonatomic) IBOutlet UITableView *dateTableView;
@property (weak, nonatomic) IBOutlet UITableView *partyTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property(strong,nonatomic)NSString *date;
@property(strong,nonatomic)NSMutableArray *onDateArr;
@property(strong,nonatomic)NSMutableArray *passDateArr;
@property(strong,nonatomic)NSMutableArray *onPartyArr;
@property(strong,nonatomic)NSMutableArray *passPartyArr;
@end

static NSString *const dateOrPartyCellIdentifier = @"dateOrPartyCell";

@implementation YMyPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"约会、聚会";
    
    UIButton *bankButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [bankButton setTitle:@"返回" forState:(UIControlStateNormal)];
    [bankButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:(UIControlStateNormal)];
    [bankButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:(UIControlStateHighlighted)];
    bankButton.size = CGSizeMake(70, 30);
    bankButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;// 使按钮内部的所有内容左对齐
    [bankButton setTitleColor:[UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1] forState:(UIControlStateNormal)];
    bankButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    [bankButton addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bankButton];
    
    // 获取当前时间
    self.date = nil;
    NSDateFormatter *fomatter = [NSDateFormatter new];
    [fomatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    self.date = [fomatter stringFromDate:[NSDate date]];
    
    self.dateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.partyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.onDateArr = [NSMutableArray new];
    self.passDateArr = [NSMutableArray new];
    self.onPartyArr = [NSMutableArray new];
    self.passPartyArr = [NSMutableArray new];
    
    self.dateOrPartySegment.selectedSegmentIndex = 0;
    [self.dateOrPartySegment addTarget:self action:@selector(changeView:) forControlEvents:(UIControlEventValueChanged)];
    self.backScrollView.delegate = self;
    [self.dateTableView registerNib:[UINib nibWithNibName:@"YDateOrPartyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:dateOrPartyCellIdentifier];
    [self.partyTableView registerNib:[UINib nibWithNibName:@"YDateOrPartyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:dateOrPartyCellIdentifier];
    [self getData:@"MyDate"];
    [self getData:@"MyParty"];
    if (self.onDateArr.count == 0 && self.passDateArr.count == 0 && self.onPartyArr.count == 0 && self.passPartyArr.count == 0) {
        [SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeClear)];
    }
}

- (void)back{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark--设置分段控制器--
- (void)changeView:(UISegmentedControl *)seg{
    if (seg.selectedSegmentIndex == 1) {
        self.backScrollView.contentOffset = CGPointMake(kWidth, 0);
        //[SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeClear)];
    }else{
        self.backScrollView.contentOffset = CGPointMake(0, 0);
        //[SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeClear)];
    }
}
#pragma mark--scrollView代理实现--
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.backScrollView) {
        self.dateOrPartySegment.selectedSegmentIndex = scrollView.contentOffset.x / self.view.width;
        //[SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeClear)];
    }
}
#pragma mark--数据请求--
- (void)getData:(NSString *)className{
    AVQuery *query = [AVQuery queryWithClassName:className];
    [query whereKey:@"userName" equalTo:[AVUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count != 0) {
                for (AVObject *object in objects) {
                    NSDictionary *dict = [object dictionaryForObject];
                    YDateContentModel *model = [YDateContentModel new];
                    model.eventName = [dict objectForKey:@"theme"];
                    model.eventLocation = [dict objectForKey:@"address"];
                    model.dateTime = [dict objectForKey:@"time"];
                    model.ourSeverMark = @"Our";
                    if ([[dict objectForKey:@"concrete"] isEqualToString:@"我请客"]) {
                        model.fee = 0;
                    }else{
                        model.fee = 1;
                    }
                    YActionUserModel *user = [YActionUserModel new];
                    user.nick = [AVUser currentUser].username;
                    model.user = user;
                    model.creatAt = [NSString stringWithFormat:@"%@",object.createdAt];
                    model.caterBusinessId = [dict objectForKey:@"businessID"];
                    model.eventDescription = [dict objectForKey:@"description"];
                    model.user.gender = [[[AVUser currentUser] objectForKey:@"gender"] integerValue];
                    model.user.constellation = [[AVUser currentUser] objectForKey:@"constellation"];
                    AVFile *file = [[AVUser currentUser] objectForKey:@"avatar"];
                    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        UIImage *img = [UIImage imageWithData:data];
                        model.img = img;
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([self.date substringWithRange:NSMakeRange(5, 2)].integerValue < [model.dateTime substringWithRange:NSMakeRange(5, 2)].integerValue) {
                            if ([className isEqualToString:@"MyDate"]) {
                                [self.onDateArr addObject:model];
                                //[self.dateTableView reloadData];
                            }else{
                                [self.onPartyArr addObject:model];
                                //[self.partyTableView reloadData];
                            }
                        }else if ([self.date substringWithRange:NSMakeRange(5, 2)].integerValue == [model.dateTime substringWithRange:NSMakeRange(5, 2)].integerValue && [self.date substringWithRange:NSMakeRange(8, 2)].integerValue < [model.dateTime substringWithRange:NSMakeRange(8, 2)].integerValue){
                            if ([className isEqualToString:@"MyDate"]) {
                                [self.onDateArr addObject:model];
                               // [self.dateTableView reloadData];
                            }else{
                                [self.onPartyArr addObject:model];
                               // [self.partyTableView reloadData];
                            }
                        }else if([[self.date substringToIndex:10] isEqualToString:[model.dateTime substringToIndex:10]] && [self.date substringWithRange:NSMakeRange(11, 2)].integerValue == [model.dateTime substringWithRange:NSMakeRange(12, 2)].integerValue && [self.date substringWithRange:NSMakeRange(14, 2)].integerValue <= [model.dateTime substringWithRange:NSMakeRange(17, 2)].integerValue){
                            if ([className isEqualToString:@"MyDate"]) {
                                [self.onDateArr addObject:model];
                                //[self.dateTableView reloadData];
                            }else{
                                [self.onPartyArr addObject:model];
                                //[self.partyTableView reloadData];
                            }
                        }else if([[self.date substringToIndex:10] isEqualToString:[model.dateTime substringToIndex:10]] && [self.date substringWithRange:NSMakeRange(11, 2)].integerValue < [model.dateTime substringWithRange:NSMakeRange(12, 2)].integerValue){
                            if ([className isEqualToString:@"MyDate"]) {
                                [self.onDateArr addObject:model];
                                //[self.dateTableView reloadData];
                            }else{
                                [self.onPartyArr addObject:model];
                               // [self.partyTableView reloadData];
                            }
                        }else{
                            if ([className isEqualToString:@"MyDate"]) {
                                [self.passDateArr addObject:model];
                               // [self.dateTableView reloadData];
                            }else{
                                [self.passPartyArr addObject:model];
                               // [self.partyTableView reloadData];
                            }
                        }
                        if (self.onDateArr.count == 0 && self.passDateArr.count == 0) {
                            [SVProgressHUD dismiss];
                            [self showAlertViewWithMessage:@"抱歉，没有相关约会信息!"];
                        }else{
                            [self.dateTableView reloadData];
                            [SVProgressHUD dismiss];
                        }
                        if (self.onPartyArr.count == 0 && self.passPartyArr.count == 0) {
                            [SVProgressHUD dismiss];
                            [self showAlertViewWithMessage:@"抱歉，没有相关聚会信息!"];
                        }else{
                            [self.partyTableView reloadData];
                            [SVProgressHUD dismiss];
                        }
                });
            }
        }
    }];
}

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.dateTableView) {
        if (section == 0) {
            return self.onDateArr.count;
        }
        return self.passDateArr.count;
    }else{
        if (section == 0) {
            return self.onPartyArr.count;
        }
            return self.passPartyArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDateOrPartyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dateOrPartyCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    if (tableView == self.dateTableView) {
        if (indexPath.section == 0) {
            [cell.passLabel setHidden:YES];
            [cell.deleteBtn setHidden:YES];
            YDateContentModel *model = self.onDateArr[indexPath.row];
            cell.model = model;
        }else{
            [cell.passLabel setHidden:NO];
            [cell.deleteBtn setHidden:NO];
            YDateContentModel *model = self.passDateArr[indexPath.row];
            cell.model = model;
        }
    }else{
        if (indexPath.section == 0) {
            [cell.passLabel setHidden:YES];
            [cell.deleteBtn setHidden:YES];
            YDateContentModel *model = self.onPartyArr[indexPath.row];
            cell.model = model;
        }else{
            [cell.passLabel setHidden:NO];
            [cell.deleteBtn setHidden:NO];
            YDateContentModel *model = self.passPartyArr[indexPath.row];
            cell.model = model;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YDetailViewController *detailVC = [YDetailViewController new];
    if (tableView == self.dateTableView) {
        if (indexPath.section == 0) {
            YDateContentModel *model = self.onDateArr[indexPath.row];
            detailVC.model = model;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }else{
        if (indexPath.section == 0) {
            YDateContentModel *model = self.onPartyArr[indexPath.row];
            detailVC.model = model;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

-(void)deletePassDateOrParty:(YDateOrPartyTableViewCell *)cell{
    if (self.backScrollView.contentOffset.x == 0) {
        NSIndexPath *indexPath = [self.dateTableView indexPathForCell:cell];
        YDateContentModel *model = self.passDateArr[indexPath.row];
        // 删除关注的数据
        // 执行 CQL 语句实现删除一个 MyAttention 对象
        NSString *object = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Date%@",[AVUser currentUser].username,model.creatAt]];
        [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"delete from MyDate where objectId='%@'",object] callback:^(AVCloudQueryResult *result, NSError *error) {
            if (nil== error) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@Date%@",[AVUser currentUser].username,model.creatAt]];
                NSLog(@"删除成功");
            }else{
                NSLog(@"error = %ld",error.code);
            }
        }];
        [self.passDateArr removeObject:model];
        // 删除UI
        [self.dateTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        NSIndexPath *indexPath = [self.partyTableView indexPathForCell:cell];
        YDateContentModel *model = self.passPartyArr[indexPath.row];
        // 删除关注的数据
        // 执行 CQL 语句实现删除一个 MyAttention 对象
        NSString *object = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Party%@",[AVUser currentUser].username,model.creatAt]];
        [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"delete from MyParty where objectId='%@'",object] callback:^(AVCloudQueryResult *result, NSError *error) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@Party%@",[AVUser currentUser].username,model.creatAt]];
            NSLog(@"删除成功");
        }];
        [self.passPartyArr removeObject:model];
        // 删除UI
        [self.partyTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 24)];
    headView.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 150, 20)];
    [label setTextColor:[UIColor whiteColor]];
    [headView addSubview:label];
    if (tableView == self.dateTableView) {
        if (section == 0) {
            label.text = @"正在进行的约会";
        }else{
            label.text = @"已经过期的约会";
        }
    }else{
        if (section == 0) {
            label.text = @"正在进行的聚会";
        }else{
            label.text = @"已经过期的聚会";
        }
    }
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
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
