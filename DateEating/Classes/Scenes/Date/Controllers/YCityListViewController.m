//
//  YCityListViewController.m
//  DateEating
//
//  Created by user on 16/7/17.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YCityListViewController.h"
#import "YCityTypeModel.h"
#import "YCityListModel.h"
@interface YCityListViewController ()
@property(strong,nonatomic)NSArray *dataArray;
@end

static NSString *const systemCellIdentifier = @"systemCell";

@implementation YCityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSArray new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:systemCellIdentifier];
    [self getData];
}
#pragma mark--数据请求--
- (void)getData{
    [YCityTypeModel parsesWithUrl:CityList_URL successRequest:^(id dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataArray = dict;
            [self.tableView reloadData];
        });
    } failurRequest:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YCityTypeModel *model = self.dataArray[section];
    return model.city_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCellIdentifier forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        YCityTypeModel *typeModel = self.dataArray[indexPath.section];
        YCityListModel *cityModel = typeModel.city_list[indexPath.row];
        //NSLog(@"%@",cityModel.city_name);
        cell.textLabel.text = cityModel.city_name;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YCityTypeModel *model = self.dataArray[indexPath.section];
    YCityListModel *cityModel = model.city_list[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(passCityName:)]) {
        [self.delegate passCityName:cityModel.city_name];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    YCityTypeModel *model = self.dataArray[section];
    if (section == 0) {
        model.begin_key = @"热门城市";
    }
    return model.begin_key;
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *array = [NSMutableArray new];
    if (self.dataArray.count > 0) {
        for (int i = 0; i < self.dataArray.count; i++) {
            if (i == 0) {
                continue;
            }
            YCityTypeModel *model = self.dataArray[i];
            [array addObject:model.begin_key];
        }
    }
    return array;
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
