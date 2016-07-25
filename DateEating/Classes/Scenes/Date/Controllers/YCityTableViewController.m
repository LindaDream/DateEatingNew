//
//  YCityTableViewController.m
//  DateEating
//
//  Created by lanou3g on 16/7/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YCityTableViewController.h"
#import "YCityTypeModel.h"

@interface YCityTableViewController ()
<   UISearchControllerDelegate,
    UISearchResultsUpdating
>
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSArray *indexTitle;

@end

@implementation YCityTableViewController

- (void)viewWillDisappear:(BOOL)animated {
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [NSMutableArray array];
    // 设置搜索栏
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.delegate = self;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"nil"];
    // 查询数据
    [self getRequestData];
}

// 懒加载
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

// 获取数据
- (void)getRequestData {
    __weak typeof(self) weakSelf = self;
    [YCityTypeModel parsesWithUrl:CityList_URL successRequest:^(id dict) {
        weakSelf.listArray = dict;
        dispatch_async(dispatch_get_main_queue(), ^{
            for (YCityTypeModel *model in weakSelf.listArray) {
                [weakSelf.array addObjectsFromArray:model.city_list];
            }
            [weakSelf.array removeObjectAtIndex:0];
            [weakSelf.tableView reloadData];
        });
    } failurRequest:^(NSError *error) {
    }];
}

#pragma mark -- searchController代理方法 --
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"city_name CONTAINS[d] %@",searchString];
    if (self.searchArray != nil) {
        [self.searchArray removeAllObjects];
    }
    self.searchArray = [self.array filteredArrayUsingPredicate:pre].mutableCopy;
    //刷新表格
    [self.tableView reloadData];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return 1;
    } else {
        return self.listArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.searchArray.count;
    } else {
        YCityTypeModel *model = self.listArray[section];
        return model.city_list.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nil" forIndexPath:indexPath];
    if (self.searchController.active) {
        YCityListModel *listModel = self.searchArray[indexPath.row];
        cell.textLabel.text = listModel.city_name;
    } else {
        YCityTypeModel *model = self.listArray[indexPath.section];
        YCityListModel *listModel = model.city_list[indexPath.row];
        cell.textLabel.text = listModel.city_name;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YCityListModel *cityModel;
    if (self.searchController.active) {
        cityModel = self.searchArray[indexPath.row];
        } else {
        YCityTypeModel *model = self.listArray[indexPath.section];
        cityModel = model.city_list[indexPath.row];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectCity:)]) {
        [_delegate didSelectCity:cityModel];
        NSDictionary *dic = @{cityModel.city_name:[NSNumber numberWithInteger:cityModel.city_id]};
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"city"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 创建索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:27];
    for (YCityTypeModel *model in self.listArray) {
        [array addObject:model.begin_key];
    }
    self.indexTitle = array;
    return array;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.indexTitle[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.searchController.active) {
        return 0.01;
    }
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
