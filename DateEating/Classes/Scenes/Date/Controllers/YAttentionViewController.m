//
//  YAttentionListViewController.m
//  DateEating
//
//  Created by user on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YAttentionViewController.h"
#import "YAttentionListViewCell.h"
#import "YUserDetailViewController.h"

@interface YAttentionViewController ()
<
    YAttentionListViewCellDelegate
>

@property(strong,nonatomic)NSArray *attentionArray;

@end

static NSString *const attentionListCellIdentifier = @"attentionListCell";

@implementation YAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.attentionArray = [NSArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"YAttentionListViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:attentionListCellIdentifier];
    [self getData];
}
#pragma mark--数据请求--
- (void)getData{
        [YAttentionListModel parsesWithUrl:AttentionList_URL(self.businessID) successRequest:^(id dict) {
            self.attentionArray = dict;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } failurRequest:^(NSError *error) {
            
        }];
}

// 点击头像跳转的代理回调
- (void)didTapTheUserImage:(NSInteger)userId {
    YUserDetailViewController *userDetailVC = [[YUserDetailViewController alloc]init];
    userDetailVC.userId = userId;
    [self.navigationController pushViewController:userDetailVC animated:YES];
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
    return self.attentionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YAttentionListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attentionListCellIdentifier forIndexPath:indexPath];
    NSLog(@"%@",self.attentionArray);
    YAttentionListModel *model = self.attentionArray[indexPath.row];
    cell.delegate = self;
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
