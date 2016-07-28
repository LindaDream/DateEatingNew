//
//  YMyCollectionViewController.m
//  DateEating
//
//  Created by user on 16/7/20.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YMyCollectionViewController.h"
#import "YMealDetailsModel.h"
#import "YPlayDetailModel.h"
#import "MealDetailsViewController.h"
#import "PlayDetailsViewController.h"
@interface YMyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *mealOrPlaySegment;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *mealTableView;
@property (weak, nonatomic) IBOutlet UITableView *playTableView;
@property(strong,nonatomic)NSMutableArray *mealArray;
@property(strong,nonatomic)NSMutableArray *playArray;
@end

static NSString *const systemCellIdentifier = @"systemCell";

@implementation YMyCollectionViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getData:@"MyMealCollection"];
    [self getData:@"MyPlayCollection"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.mealOrPlaySegment.selectedSegmentIndex = 0;
    [self.mealOrPlaySegment addTarget:self action:@selector(changeView:) forControlEvents:(UIControlEventValueChanged)];
    [self.mealTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:systemCellIdentifier];
    [self.playTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:systemCellIdentifier];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark--切换界面--
- (void)changeView:(UISegmentedControl *)seg{
    if (seg.selectedSegmentIndex == 1) {
        self.scrollView.contentOffset = CGPointMake(414, 0);
    }else{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        self.mealOrPlaySegment.selectedSegmentIndex = scrollView.contentOffset.x / 414.0;
    }
}
#pragma mark--数据请求--
- (void)getData:(NSString *)className{
    self.mealArray = [NSMutableArray new];
    self.playArray = [NSMutableArray new];
    AVQuery *query = [AVQuery queryWithClassName:className];
    [query whereKey:@"userName" equalTo:[AVUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            for (AVObject *object in objects) {
                NSDictionary *dict = [object dictionaryForObject];
                YMealDetailsModel *model = [YMealDetailsModel new];
                model.title = [dict objectForKey:@"title"];
                model.ID = [dict objectForKey:@"ID"];
                if ([className isEqualToString:@"MyMealCollection"]) {
                    [self.mealArray addObject:model];
                }else{
                    [self.playArray addObject:model];
                }
            }dispatch_async(dispatch_get_main_queue(), ^{
                if ([className isEqualToString:@"MyMealCollection"]) {
                    [self.mealTableView reloadData];
                }else{
                    [self.playTableView reloadData];
                }
            });
        }
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.mealTableView) {
        return self.mealArray.count;
    }
    return self.playArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat height = [self textHeightForLabel:cell.textLabel];
    cell.textLabel.numberOfLines = 0;
    CGRect rect = cell.textLabel.frame;
    rect.size.height = height;
    cell.textLabel.frame = rect;
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height, 414, 1)];
    grayLine.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:grayLine
     ];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    if (tableView == self.mealTableView) {
        YMealDetailsModel *model = self.mealArray[indexPath.row];
        cell.textLabel.text = model.title;
    }else{
        YPlayDetailModel *model = self.playArray[indexPath.row];
        cell.textLabel.text = model.title;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mealTableView) {
        MealDetailsViewController *mealVC = [MealDetailsViewController new];
        YMealDetailsModel *model = self.mealArray[indexPath.row];
        mealVC.ID = model.ID;
        [self.navigationController pushViewController:mealVC animated:YES];
    }else{
        PlayDetailsViewController *playVC = [PlayDetailsViewController new];
        YPlayDetailModel *model = self.playArray[indexPath.row];
        playVC.ID = model.ID;
        [self.navigationController pushViewController:playVC animated:YES];
    }
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
