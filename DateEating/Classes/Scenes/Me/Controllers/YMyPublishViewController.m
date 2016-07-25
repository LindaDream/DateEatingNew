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
@interface YMyPublishViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateOrPartySegment;
@property (weak, nonatomic) IBOutlet UITableView *dateTableView;
@property (weak, nonatomic) IBOutlet UITableView *partyTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property(strong,nonatomic)NSMutableArray *dateArray;
@property(strong,nonatomic)NSMutableArray *partyArray;
@end

static NSString *const dateOrPartyCellIdentifier = @"dateOrPartyCell";

@implementation YMyPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"约会、聚会";
    self.dateArray = [NSMutableArray new];
    self.partyArray = [NSMutableArray new];
    self.dateOrPartySegment.selectedSegmentIndex = 0;
    [self.dateOrPartySegment addTarget:self action:@selector(changeView:) forControlEvents:(UIControlEventValueChanged)];
    self.backScrollView.delegate = self;
    [self.dateTableView registerNib:[UINib nibWithNibName:@"YDateOrPartyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:dateOrPartyCellIdentifier];
    [self.partyTableView registerNib:[UINib nibWithNibName:@"YDateOrPartyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:dateOrPartyCellIdentifier];
    [self getData:@"MyParty"];
    [self getData:@"MyDate"];
}
#pragma mark--设置分段控制器--
- (void)changeView:(UISegmentedControl *)seg{
    if (seg.selectedSegmentIndex == 1) {
        self.backScrollView.contentOffset = CGPointMake(414, 0);
    }else{
        self.backScrollView.contentOffset = CGPointMake(0, 0);
    }
}
#pragma mark--scrollView代理实现--
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.backScrollView) {
        self.dateOrPartySegment.selectedSegmentIndex = scrollView.contentOffset.x / 414.0;
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
                if ([[dict objectForKey:@"concrete"] isEqualToString:@"我请客"]) {
                    model.fee = 0;
                }else{
                    model.fee = 1;
                }
                model.caterBusinessId = [dict objectForKey:@"businessID"];
                model.eventDescription = [dict objectForKey:@"description"];
                model.user.nick = [AVUser currentUser].username;
                model.user.gender = [[[AVUser currentUser] objectForKey:@"gender"] integerValue];
                model.user.constellation = [[AVUser currentUser] objectForKey:@"constellation"];
                AVFile *file = [[AVUser currentUser] objectForKey:@"avatar"];
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    UIImage *img = [UIImage imageWithData:data];
                    model.img = img;
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([className isEqualToString:@"MyDate"]) {
                        [self.dateArray addObject:model];
                        [self.dateTableView reloadData];
                    }else{
                        [self.partyArray addObject:model];
                        [self.partyTableView reloadData];
                    }
                });
            }
        }
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.dateTableView) {
        return self.dateArray.count;
    }
    return self.partyArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDateOrPartyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dateOrPartyCellIdentifier forIndexPath:indexPath];
    if (tableView == self.dateTableView) {
        YDateContentModel *model = self.dateArray[indexPath.row];
        cell.model = model;
    }else{
        YDateContentModel *model = self.partyArray[indexPath.row];
        cell.model = model;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YDetailViewController *detailVC = [YDetailViewController new];
    if (tableView == self.dateTableView) {
        YDateContentModel *model = self.dateArray[indexPath.row];
        detailVC.model = model;
    }else{
        YDateContentModel *model = self.partyArray[indexPath.row];
        detailVC.model = model;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
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
