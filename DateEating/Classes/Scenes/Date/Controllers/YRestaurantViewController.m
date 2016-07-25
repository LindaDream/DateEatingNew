//
//  YRestaurantViewController.m
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YRestaurantViewController.h"
#import "YRestaurantDetailViewController.h"
#import "YRestaurantDetailViewCell.h"
#import "YRestaurantListModel.h"
#import "YCityListViewController.h"
@interface YRestaurantViewController ()<passCurrentCell,UISearchControllerDelegate,UISearchResultsUpdating,passCityName>
@property(strong,nonatomic)UILabel *cityLabel;
@property(strong,nonatomic)NSArray *dataArray;
@property(strong,nonatomic)YRestaurantListModel *model;
// 定义一个searchbarcontroller
@property(strong,nonatomic)UISearchController *searchController;
// 接收结果的数组
@property(strong,nonatomic)NSMutableArray *searchListArr;
@property(strong,nonatomic)NSMutableArray *nameArr;
@end

static NSString *const restaurantListCellIndentifier = @"restaurantListCell";

@implementation YRestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"餐厅列表";
    self.model = [YRestaurantListModel new];
    self.dataArray = [NSArray new];
    self.nameArr = [NSMutableArray new];
    self.searchListArr = [NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"YRestaurantDetailViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:restaurantListCellIndentifier];
    [self setNavigationBar];
    [self getData];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    // 设置searchBar
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.bounds.origin.x, self.searchController.searchBar.bounds.origin.y, self.searchController.searchBar.bounds.size.width, 44);
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
}
#pragma mark--设置导航栏--
- (void)setNavigationBar{
    // 设置城市按钮
    UIButton *cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 50, 0, 40, 30)];
    [cityBtn addTarget:self action:@selector(cityListAction:) forControlEvents:(UIControlEventTouchUpInside)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    imgView.image = [[UIImage imageNamed:@"didian"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [cityBtn addSubview:imgView];
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 3, 0, 30, 30)];
    self.cityLabel.text = @"北京";
    self.cityLabel.font = [UIFont systemFontOfSize:13];
    [cityBtn addSubview:self.cityLabel];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:cityBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}
#pragma mark--searchBarController必须实现的代理--
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *string = self.searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd]%@",string];
    if (self.searchListArr) {
        [self.searchListArr removeAllObjects];
    }
    // 过滤数据
    self.searchListArr = [NSMutableArray arrayWithArray:[self.nameArr filteredArrayUsingPredicate:predicate]];
    // 刷新表格
    [self.tableView reloadData];
}
#pragma mark--城市按钮点击事件--
- (void)cityListAction:(UIButton *)btn{
    YCityListViewController *cityVC = [YCityListViewController new];
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
}
#pragma mark--数据请求--
- (void)getData{
    NSString *urlStr = [RestaurantList_URL(self.cityLabel.text) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [YRestaurantListModel parsesWithUrl:urlStr successRequest:^(id dict) {
        for (YRestaurantListModel *model in dict) {
            [self.nameArr addObject:model.name];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataArray = dict;
            [self.tableView reloadData];
        });
    } failurRequest:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
    if (self.searchController.active) {
        return self.searchListArr.count;
    }
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YRestaurantDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:restaurantListCellIndentifier forIndexPath:indexPath];
    cell.delegate = self;
    if (self.searchController.active) {
        for (YRestaurantListModel *model in self.dataArray) {
            if ([model.name isEqualToString:self.searchListArr[indexPath.row]]) {
                cell.model = model;
            }
        }
    }else{
        self.model = self.dataArray[indexPath.row];
        cell.model = self.model;
    }
    CGRect rect = cell.nameLabel.frame;
    CGFloat height = [self textHeightForLabel:cell.nameLabel];
    rect.size.height = height;
    cell.nameLabel.frame = rect;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YRestaurantDetailViewController *detailVC = [YRestaurantDetailViewController new];
    detailVC.isDateView = self.isDateView;
    if (self.searchController.active) {
        for (YRestaurantListModel *model in self.dataArray) {
            if ([model.name isEqualToString:self.searchListArr[indexPath.row]]) {
                detailVC.count = model.caterUserCount;
                detailVC.businessId = model.businessId;
                detailVC.addressStr = model.regionsStr;
                detailVC.nameStr = model.name;
            }
        }
    }else{
        self.model = self.dataArray[indexPath.row];
        detailVC.count = self.model.caterUserCount;
        detailVC.businessId = self.model.businessId;
        detailVC.addressStr = self.model.regionsStr;
        detailVC.nameStr = self.model.name;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.searchController.searchBar.bounds.size.height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.searchController.searchBar;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
#pragma mark--点击“吃这家”按钮的代理方法实现--
-(void)passCurrentCell:(YRestaurantDetailViewCell *)cell{
    self.passValueBlock(cell.nameLabel.text,cell.model.businessId);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--城市列表代理方法--
-(void)passCityName:(NSString *)cityName{
    self.cityLabel.text = cityName;
    [self.tableView reloadData];
    [self getData];
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
