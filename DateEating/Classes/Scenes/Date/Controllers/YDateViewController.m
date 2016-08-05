//
//  XMGNewViewController.m
//  百思不得姐
//
//  Created by lanou3g on 16/5/6.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "YDateViewController.h"
#import "YDateListTableViewCell.h"
#import "YDetailViewController.h"
#import "YSeekConditionViewController.h"
#import "YNSUserDefaultHandel.h"
#import "YNetWorkRequestManager.h"
#import "Request_Url.h"
#import "YDateContentModel.h"
#import <MJRefreshAutoNormalFooter.h>
#import <MJRefreshNormalHeader.h>
#import "YUserDetailViewController.h"
#import "YCityTableViewController.h"
#import "YContent.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "YRequestOurData.h"

@interface YDateViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIScrollViewDelegate,
    YSeekConditionViewControllerDelegate,
    YDateListTableViewCellDelegate,
    YCityTableViewControllerDelegate,
    YRequestOurDataDelegate
>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *hotTableView;
@property (weak, nonatomic) IBOutlet UITableView *nearbyTableView;
@property (strong,nonatomic) UISegmentedControl *titleViewSegment;

@property (strong,nonatomic) UIBarButtonItem *barButton;
@property (strong,nonatomic) NSMutableArray *hotArray;
@property (strong,nonatomic) NSMutableArray *nearByArray;
@property (strong,nonatomic) NSMutableArray *ourServerData;
@property (strong, nonatomic) YNSUserDefaultHandel *handle;
@property (assign, nonatomic) NSInteger hotCount;
@property (assign,nonatomic) NSInteger nearbyCount;
@property (assign,nonatomic) BOOL isHotDown;
@property (assign,nonatomic) BOOL isNearByDown;
@property (strong, nonatomic) UIButton *button;

@property (strong, nonatomic) BMKLocationService *locService;
@property (strong, nonatomic) BMKUserLocation *userLocation;

@property (strong, nonatomic) YRequestOurData *requestOurData;
@property (strong, nonatomic) NSMutableArray *layoutArray;

@property(strong,nonatomic)NSMutableDictionary *cityDict;
@property (strong,nonatomic) UIButton *toTopBtn;

@end

@implementation YDateViewController

- (void)viewWillDisappear:(BOOL)animated {
    [self.button removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated {
    // 接收加号按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateView:) name:@"DateButtonClicked" object:nil];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15, 7, 50, 30)];
    [button setTitleColor:YRGBColor(255, 102, 102) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button addTarget:self action:@selector(cityListAction:) forControlEvents:UIControlEventTouchUpInside];
    NSString *name = [self.handle city].allKeys.firstObject;
    [button setTitle:name forState:UIControlStateNormal];
    self.button = button;
    [self.navigationController.navigationBar addSubview:button];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.toTopBtn = [self addToTopBtn];
    [self.view insertSubview:self.toTopBtn atIndex:0];
    [self.view addSubview:self.toTopBtn];
    self.toTopBtn.hidden = YES;
    [self.toTopBtn addTarget:self action:@selector(backToTop) forControlEvents:(UIControlEventTouchUpInside)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.userLocation = [[BMKUserLocation alloc]init];
    // 获取设备所在位置的坐标
    //初始化BMKLocationService
    self.locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"areaCodeList.plist" ofType:nil];
    self.cityDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = YRGBbg;
    self.handle = [YNSUserDefaultHandel sharedYNSUserDefaultHandel];
    // 接收夜间模式转换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"NotificationNight" object:nil];
   
    // 设置navigtationbar的头视图
    [self setNavigationBar];
    // 设置上拉加载下拉刷新
    [self refrushData];
    
    // 注册cell
    [self.hotTableView registerNib:[UINib nibWithNibName:@"YDateListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YDateListTableViewCell_Identify];
    [self.nearbyTableView registerNib:[UINib nibWithNibName:@"YDateListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YDateListTableViewCell_Identify];
    self.requestOurData = [YRequestOurData sharedYRequestOurData];
    self.requestOurData.delegate = self;
    // 数据请求
    [_requestOurData getOurDataWithDateType:[_handle multi] gender:[_handle gender] time:[_handle time] age:[_handle age] constellation:[_handle constellation]];
    [self requestHotDataWithDic:[_handle city] start:0];
    [self requestNearByDataWithUrl:0];
    
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DateButtonClicked" object:nil];
}
#pragma mark -- 处理位置坐标更新代理 --
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.userLocation = userLocation;
    if (self.userLocation.location.coordinate.latitude > 1) {
        [self reloadAllData];
    }
}
- (void)backToTop{
    if (self.titleViewSegment.selectedSegmentIndex == 0) {
        [self.hotTableView backToTop];
    }else{
        [self.nearbyTableView backToTop];
    }
}
#pragma mark -- scrollde 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.hotTableView) {
        // 先获取屏幕上的所有cell
        NSArray *visibleCells = [self.hotTableView visibleCells];
        NSIndexPath *indexPath = [self.hotTableView indexPathForCell:visibleCells[0]];
        if (indexPath.section != 0) {
            self.toTopBtn.hidden = NO;
        }else{
            self.toTopBtn.hidden = YES;
        }
    }else if (scrollView == self.nearbyTableView){
        // 先获取屏幕上的所有cell
        NSArray *visibleCells = [self.nearbyTableView visibleCells];
        NSIndexPath *indexPath = [self.nearbyTableView indexPathForCell:visibleCells[0]];
        if (indexPath.section != 0) {
            self.toTopBtn.hidden = NO;
        }else{
            self.toTopBtn.hidden = YES;
        }
    }
    
}

#pragma mark--夜间模式通知方法--
- (void)change:(NSNotification *)notication{
    NSDictionary *userInfo = [notication userInfo];
    if ([[userInfo objectForKey:@"isNight"] isEqualToString:@"1"]) {
        [self changeToNight];
    }else if ([[userInfo objectForKey:@"isNight"] isEqualToString:@"0"]){
        [self changeToDay];
    }
}
#pragma mark--加号按钮通知方法--
- (void)dateView:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *num = [userInfo objectForKey:@"isClicked"];
    if (num.boolValue) {
        self.scrollView.userInteractionEnabled = NO;
        [self addDateBtnAndPartyBtn];
    }else{
        self.scrollView.userInteractionEnabled = YES;
        [self removeDateBtnAndPartyBtn];
    }
}

// 懒加载
- (NSMutableArray *)hotArray {
    if (!_hotArray) {
        _hotArray = [NSMutableArray array];
    }
    return _hotArray;
}
- (NSMutableArray *)nearByArray {
    if (!_nearByArray) {
        _nearByArray = [NSMutableArray array];
    }
    return _nearByArray;
}
- (NSMutableArray *)ourServerData {
    if (!_ourServerData) {
        _ourServerData = [NSMutableArray array];
    }
    return _ourServerData;
}

- (NSMutableArray *)layoutArray {
    if (!_layoutArray) {
        _layoutArray = [NSMutableArray array];
    }
    return _layoutArray;
}
#pragma mark -- 从自己的服务器获取数据 --


#pragma mark -- 数据查询 --
- (void)requestHotDataWithDic:(NSDictionary *)dic start:(NSInteger)start {
    __weak YDateViewController *dateVC = self;
    NSDictionary *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    NSString *cityName = [city allKeys].firstObject;
    NSNumber *cityID = self.cityDict[cityName];
    [YNetWorkRequestManager getRequestWithUrl:HotRequest_Url(cityID,[_handle multi], [_handle gender], [_handle time], [_handle age], [_handle constellation], [_handle occupation], start) successRequest:^(id dict) {
        NSNumber *count = dict[@"data"][@"total"];
        dateVC.hotCount = count.integerValue;
        if (dateVC.isHotDown) {
            [dateVC.hotArray removeAllObjects];
            dateVC.isHotDown = NO;
        }
        [dateVC.hotArray addObjectsFromArray:[YDateContentModel getDateContentListWithDic:dict]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [dateVC reloadAllData];
        });
    } failurRequest:^(NSError *error) {
        
    }];
}
- (void)requestNearByDataWithUrl:(NSInteger)start {
    __weak YDateViewController *dateVC = self;
    [YNetWorkRequestManager getRequestWithUrl:NearByRequest_Url([_handle multi], [_handle gender], [_handle time], [_handle age], [_handle constellation], [_handle occupation], start) successRequest:^(id dict) {
        NSNumber *count = dict[@"data"][@"total"];
        dateVC.nearbyCount = count.integerValue;
        if (dateVC.isNearByDown) {
            [dateVC.nearByArray removeAllObjects];
            dateVC.isNearByDown = NO;
        }
        [dateVC.nearByArray addObjectsFromArray:[YDateContentModel getDateContentListWithDic:dict]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [dateVC reloadAllData];
        });
    } failurRequest:^(NSError *error) {
        
    }];
}

#pragma mark -- 刷新数据 --
- (void)reloadAllData {
    [self.layoutArray removeAllObjects];
    [self.layoutArray addObjectsFromArray:self.ourServerData];
    [self.layoutArray addObjectsFromArray:self.hotArray];
    [self.hotTableView reloadData];
    [self.nearbyTableView reloadData];
}

#pragma mark -- 回调刷新数据 -- 
- (void)getOurDataByCondition:(NSMutableArray *)array {
    
    self.ourServerData = array;
    [self.layoutArray removeAllObjects];
    [self.layoutArray addObjectsFromArray:self.ourServerData];
    [self.layoutArray addObjectsFromArray:self.hotArray];
    [self.hotTableView reloadData];
}

#pragma mark -- 上拉加载 --
- (void)refrushData {
    // 尾
    MJRefreshAutoNormalFooter *footerHot = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData:)];
    [footerHot setTitle:@"" forState:MJRefreshStateIdle];
    [footerHot setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footerHot setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    footerHot.stateLabel.font = [UIFont systemFontOfSize:16.0f];
    footerHot.stateLabel.textColor = YRGBColor(255, 102, 102);
    self.hotTableView.mj_footer = footerHot;
    
    MJRefreshAutoNormalFooter *footerNearBy = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNearByData:)];
    [footerNearBy setTitle:@"" forState:MJRefreshStateIdle];
    [footerNearBy setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footerNearBy setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    footerNearBy.stateLabel.font = [UIFont systemFontOfSize:16.0f];
    footerNearBy.stateLabel.textColor = YRGBColor(255, 102, 102);
    self.nearbyTableView.mj_footer = footerNearBy;
    // 头
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *headerHot = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isHotDown = YES;
        [self.requestOurData getOurDataWithDateType:[_handle multi] gender:[_handle gender] time:[_handle time] age:[_handle age] constellation:[_handle constellation]];
        [weakSelf requestHotDataWithDic:[weakSelf.handle city] start:0];
        [weakSelf.hotTableView.mj_header endRefreshing];
    }];
    headerHot.stateLabel.textColor = YRGBColor(255, 102, 102);
    headerHot.lastUpdatedTimeLabel.textColor = YRGBColor(255, 102, 102);
    self.hotTableView.mj_header = headerHot;
    
    MJRefreshNormalHeader *headerNearBy = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isNearByDown = YES;
        [weakSelf requestNearByDataWithUrl:0];
        [weakSelf.nearbyTableView.mj_header endRefreshing];
    }];
    headerNearBy.stateLabel.textColor = YRGBColor(255, 102, 102);
    headerNearBy.lastUpdatedTimeLabel.textColor = YRGBColor(255, 102, 102);
    self.nearbyTableView.mj_header = headerNearBy;
}

- (void)loadMoreHotData:(MJRefreshAutoNormalFooter *)footer {
    if (self.hotArray.count >= self.hotCount) {
        footer.state = MJRefreshStateNoMoreData;
        return;
    }
    
    [self requestHotDataWithDic:[self.handle city] start:self.hotArray.count];
    [footer endRefreshing];
    
}
- (void)loadMoreNearByData:(MJRefreshAutoNormalFooter *)footer {
    if (self.nearByArray.count >= self.nearbyCount) {
        footer.state = MJRefreshStateNoMoreData;
        return;
    }
    [self requestNearByDataWithUrl:self.nearByArray.count];
    [footer endRefreshing];
}

#pragma mark -- 设置导航栏上的各功能按钮 --
- (void)setNavigationBar {
    
    // 设置右边的按钮
    NSString *imgString = nil;
    if ([self.handle haveSeekCondition]) {
        imgString = @"NaviFiltered";
    } else {
        imgString = @"NaviUnFiltered";
    }
    self.barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:imgString] style:UIBarButtonItemStyleDone target:self action:@selector(seekByConditionAction:)];
    self.navigationItem.rightBarButtonItem = _barButton;
    
    // 设置头视图
    self.titleViewSegment = [[UISegmentedControl alloc]initWithItems:@[@"热门",@"附近"]];
    _titleViewSegment.frame = CGRectMake(0, 0, 180, 30);
    _titleViewSegment.selectedSegmentIndex = 0;
    _titleViewSegment.tintColor = YRGBColor(255, 102, 102);
    [_titleViewSegment addTarget:self action:@selector(titleViewSegmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _titleViewSegment;
}



#pragma mark -- segment触发的事件，关联滚动视图 --
- (void)titleViewSegmentAction:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        self.button.hidden = NO;
        self.scrollView.contentOffset = CGPointMake(0, 0);
        // 先获取屏幕上的所有cell
        NSArray *visibleCells = [self.hotTableView visibleCells];
        NSIndexPath *indexPath = [self.hotTableView indexPathForCell:visibleCells[0]];
        if (indexPath.section != 0) {
            self.toTopBtn.hidden = NO;
        }else{
            self.toTopBtn.hidden = YES;
        }
    } else {
        self.button.hidden = YES;
        self.scrollView.contentOffset = CGPointMake(self.view.width, 0);
        // 先获取屏幕上的所有cell
        NSArray *visibleCells = [self.nearbyTableView visibleCells];
        NSIndexPath *indexPath = [self.nearbyTableView indexPathForCell:visibleCells[0]];
        if (indexPath.section != 0) {
            self.toTopBtn.hidden = NO;
        }else{
            self.toTopBtn.hidden = YES;
        }
    }
}

#pragma mark -- 滚动视图实现的代理方法 --
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if (scrollView.contentOffset.x >= self.view.width) {
            self.button.hidden = YES;
            self.titleViewSegment.selectedSegmentIndex = 1;
            // 先获取屏幕上的所有cell
            NSArray *visibleCells = [self.nearbyTableView visibleCells];
            NSIndexPath *indexPath = [self.nearbyTableView indexPathForCell:visibleCells[0]];
            if (indexPath.section != 0) {
                self.toTopBtn.hidden = NO;
            }else{
                self.toTopBtn.hidden = YES;
            }
        } else {
            self.button.hidden = NO;
            self.titleViewSegment.selectedSegmentIndex = 0;
            // 先获取屏幕上的所有cell
            NSArray *visibleCells = [self.hotTableView visibleCells];
            NSIndexPath *indexPath = [self.hotTableView indexPathForCell:visibleCells[0]];
            if (indexPath.section != 0) {
                self.toTopBtn.hidden = NO;
            }else{
                self.toTopBtn.hidden = YES;
            }
        }
    }
}

#pragma mark -- 按条件查询数据 --
- (void)seekByConditionAction:(UIBarButtonItem *)item {
    YSeekConditionViewController *seekVC = [[YSeekConditionViewController alloc]init];
    seekVC.delegate = self;
    [self.navigationController pushViewController:seekVC animated:YES];
}

#pragma mark -- 选择查询条件后的代理回调 --
- (void)passSeekCondition {
    
    if ([self.handle haveSeekCondition]) {
        [self.barButton setImage:[UIImage imageNamed:@"NaviFiltered"]];
    } else {
        [self.barButton setImage:[UIImage imageNamed:@"NaviUnFiltered"]];
    }
    self.isHotDown = YES;
    self.isNearByDown = YES;
    [self.requestOurData getOurDataWithDateType:[_handle multi] gender:[_handle gender] time:[_handle time] age:[_handle age] constellation:[_handle constellation]];
    [self requestHotDataWithDic:[self.handle city] start:0];
    [self requestNearByDataWithUrl:0];
}
#pragma mark -- 切换城市 --
- (void)cityListAction:(UIButton *)button {
    YCityTableViewController *cityVC = [[YCityTableViewController alloc]init];
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
}

#pragma mark -- 确定城市后的回调 --
- (void)didSelectCity:(YCityListModel *)model {
    // 设置button上显示的城市名
    self.button.titleLabel.text = model.city_name;
    [self.hotArray removeAllObjects];
    [self requestHotDataWithDic:[self.handle city] start:0];
}

#pragma mark -- 点击头像跳转个人详情页 --
- (void)clickedUserImage:(YDateContentModel *)model {
    YUserDetailViewController *userDetailVC = [[YUserDetailViewController alloc]init];
    userDetailVC.model = model;
    [self.navigationController pushViewController:userDetailVC animated:YES];
}


- (void)tagClick{
    
    YLogFunc;
    
}


#pragma mark -- tableview实现的代理方法 --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.hotTableView) {
        return self.layoutArray.count;
    }else {
        return self.nearByArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDateListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YDateListTableViewCell_Identify forIndexPath:indexPath];
    if (tableView == self.hotTableView) {
        cell.model = self.layoutArray[indexPath.section];
    }else {
        cell.model = self.nearByArray[indexPath.section];
    }
    cell.userLocation = self.userLocation;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 186;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YDetailViewController *detailVC = [[YDetailViewController alloc]init];
    if (tableView == self.hotTableView) {
        detailVC.model = self.layoutArray[indexPath.section];
    } else {
        detailVC.model = self.nearByArray[indexPath.section];
    }
    detailVC.passNewCount = ^(NSInteger count){
        YDateListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.commentCount.text = [NSString stringWithFormat:@"%ld",count];
    };
    detailVC.userLocation = self.userLocation;
    detailVC.isListData = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

// 间隔 （头部视图）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
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
