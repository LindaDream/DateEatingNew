//
//  YAttentionListViewController.m
//  DateEating
//
//  Created by user on 16/7/16.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YAttentionListViewController.h"
#import "YAttentionViewCell.h"
#import "YRestaurantListModel.h"
#import "YRestaurantDetailViewController.h"
#import <SVProgressHUD.h>
@interface YAttentionListViewController ()
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)NSMutableArray *imgArray;
@end

static NSString *const attentionCellIdentifier = @"attentionCell";

@implementation YAttentionListViewController
-(void)viewWillAppear:(BOOL)animated{
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
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
    [self.tableView registerNib:[UINib nibWithNibName:@"YAttentionViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:attentionCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeClear)];
}
- (void)back{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--查找数据--
- (void)getData{
    self.dataArray = [NSMutableArray new];
    self.imgArray = [NSMutableArray new];
    AVQuery *query = [AVQuery queryWithClassName:@"MyAttention"];
    [query whereKey:@"userName" equalTo:[AVUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count != 0) {
            for (AVObject *obj in objects) {
                NSDictionary *dict = [NSDictionary new];
                dict = [obj dictionaryForObject];
                YRestaurantListModel *model = [YRestaurantListModel new];
                model.name = [dict objectForKey:@"name"];
                model.avgPrice = [dict objectForKey:@"avgPrice"];
                model.regionsStr = [dict objectForKey:@"address"];
                model.categoriesStr = [dict objectForKey:@"type"];
                model.caterUserCount = [[dict objectForKey:@"count"] integerValue];
                model.businessId = [dict objectForKey:@"businessId"];
                model.sPhotoUrl = [dict objectForKey:@"headImg"];
                [self.dataArray addObject:model];
            }
        }else{
            [SVProgressHUD dismiss];
            [self showAlertViewWithMessage:@"您还没有关注餐厅，快去关注吧!"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        });
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YAttentionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attentionCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YRestaurantDetailViewController *detailVC = [YRestaurantDetailViewController new];
    YRestaurantListModel *model = self.dataArray[indexPath.row];
    detailVC.fromDetailVC = YES;
    detailVC.ourSeverMark = YES;
    detailVC.nameStr = model.name;
    detailVC.businessId = model.businessId;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 156;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 删除数据源
        YRestaurantListModel *model = [YRestaurantListModel new];
        model = self.dataArray[indexPath.row];
        // 删除关注的数据
        // 执行 CQL 语句实现删除一个 MyAttention 对象
        NSString *object = [[NSUserDefaults standardUserDefaults] objectForKey:model.name];
        if (object != nil) {
            [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"delete from MyAttention where objectId='%@'",object] callback:^(AVCloudQueryResult *result, NSError *error) {
                if (nil != result.results) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:model.name];
                    // 删除UI
                    [self.dataArray removeObject:model];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [self.tableView reloadData];
                    });
                    NSLog(@"删除成功");
                }else{
                    NSLog(@"result = %@",result.results);
                    NSLog(@"error = %ld",error.code);
                }
            }];
        }else{
            [self showAlertViewWithMessage:@"服务器错误，请稍后重试"];
        }
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
