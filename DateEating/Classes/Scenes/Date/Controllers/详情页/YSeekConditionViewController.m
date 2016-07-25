//
//  YSeekConditionViewController.m
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YSeekConditionViewController.h"
#import "YSelectionView.h"
#import "Request_Url.h"
#import "YNSUserDefaultHandel.h"
#import <MJRefresh/UIScrollView+MJRefresh.h>

@interface YSeekConditionViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateType;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateTime;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong,nonatomic) NSArray *superArray;
@property (strong, nonatomic) NSMutableArray *detailArray;
@property (strong,nonatomic) NSMutableDictionary *conditionDic;
@property (strong,nonatomic) NSDictionary *listDic;
@property (strong,nonatomic) YNSUserDefaultHandel *handle;

@end

@implementation YSeekConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.superArray = @[@"年龄",@"星座",@"职业"];
    self.conditionDic = [NSMutableDictionary dictionary];
    self.detailArray = @[@"不限",@"不限",@"不限"].mutableCopy;
    // 添加完成按钮
    UIBarButtonItem *completeBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(completeSeekAction:)];
    completeBtn.tintColor = YRGBColor(255, 102, 102);
    self.navigationItem.rightBarButtonItem = completeBtn;
    self.listDic = @{@0:array0,@1:array1,@2:array2};
    // 条件的设置
    [self setCondition];
//    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
//        
//        [self.tableview setSeparatorInset:UIEdgeInsetsMake(0, 39, 0, 0)];
//        
//    }
//    [self.tableview setSeparatorColor:[UIColor grayColor]];
}

#pragma mark -- 设置条件选择 --
- (void)setCondition {
    // 将条件喜好写入内存的操作类
    self.handle = [YNSUserDefaultHandel sharedYNSUserDefaultHandel];
    if ([_handle haveSeekCondition]) {
        self.dateTime.selectedSegmentIndex = [_handle time];
        self.dateType.selectedSegmentIndex = [_handle multi];
        self.gender.selectedSegmentIndex = [_handle gender];
        NSInteger num = [_handle age];
        [self.detailArray replaceObjectAtIndex:0 withObject:self.listDic[@0][num]];
        num = [_handle constellation];
        [self.detailArray replaceObjectAtIndex:1 withObject:self.listDic[@1][num]];
        num = [_handle occupation];
        [self.detailArray replaceObjectAtIndex:2 withObject:self.listDic[@2][num]];
    }
}

#pragma -- 点击完成后实现按条件查询 --
- (void)completeSeekAction:(UIBarButtonItem *)item {
    [self.handle setMulti:self.dateType.selectedSegmentIndex];
    [self.handle setTime:self.dateTime.selectedSegmentIndex];
    [self.handle setGender:self.gender.selectedSegmentIndex];
    if (_delegate && [_delegate respondsToSelector:@selector(passSeekCondition)]) {
        [_delegate passSeekCondition];
    }
    [self.handle synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

// 重置所选条件
- (IBAction)resetAction:(id)sender {
    self.dateType.selectedSegmentIndex = 0;
    self.gender.selectedSegmentIndex = 0;
    self.dateTime.selectedSegmentIndex = 0;
    for (UITableViewCell *cell in [self.tableview visibleCells]) {
        cell.detailTextLabel.text = @"不限";
    }
    [self.handle reSetCondition];
}

#pragma mark -- tableView代理实现的方法 --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = self.superArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.detailTextLabel.text = self.detailArray[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    UIImageView * separatorLine = [[UIImageView alloc]initWithFrame:CGRectMake(10, 39, self.view.width - 20, 1)];
    separatorLine.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:separatorLine];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YSelectionView *conditionList = [[YSelectionView alloc]initWithFrame:self.view.bounds];
    //conditionList.array = [NSMutableArray array];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    conditionList.array = self.listDic[@(indexPath.row)];
    conditionList.choiceBlock = ^(NSString *string,NSInteger index) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = string;
        if (indexPath.row == 0) {
            [self.handle setAge:index];
        } else if (indexPath.row == 1) {
            [self.handle setConstellation:index];
        } else {
            [self.handle setOccupation:index];
        }
    };
    [UIView animateWithDuration:0.5 animations:^{
        [[[UIApplication sharedApplication]keyWindow]addSubview:conditionList];
    }];
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
