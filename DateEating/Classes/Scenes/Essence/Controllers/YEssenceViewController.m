//
//  YViewController.m
//  DateEating
//
//  Created by user on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YEssenceViewController.h"
#import "YMealOrPlayTableViewCell.h"
#import "YPopView.h"
#import "YTabBar.h"
#import "YMealModel.h"
#import "YPlayModel.h"
#import "YPlayDetailModel.h"
#import "YCityModel.h"
#import "PlayDetailsViewController.h"
#import "MealDetailsViewController.h"


@interface YEssenceViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,EMChatManagerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UITableView *mealTableView;

@property (weak, nonatomic) IBOutlet UITableView *playTableView;

@property(strong,nonatomic)UIView *VC;

// 是否已经弹框
@property (assign,nonatomic) BOOL isSelected;
// 弹框
@property (strong,nonatomic) YPopView *popView;
// 点击手势，用于使弹框消失
@property (strong,nonatomic) UITapGestureRecognizer *tap;
// 在美食界面还是在完了界面
@property (strong,nonatomic) NSString *isMeal;
// 美食界面的model数组
@property (strong,nonatomic) NSMutableArray *mealArr;
// 玩乐界面的model数组
@property (strong,nonatomic) NSMutableArray *playArr;
// 城市界面的model数组
@property (strong,nonatomic) NSArray *cityArr;

@property (weak, nonatomic) IBOutlet UITableView *cityTableView;

@property (weak, nonatomic) IBOutlet UIView *managerView;
// 城市Id
@property (assign,nonatomic) NSInteger cityId;
// 类型
@property (strong,nonatomic) NSString *categoryId;
// 判断是上啦还是下拉
@property (strong,nonatomic) NSString *howRefresh;
// 美食页请求下数据的页码
@property (strong,nonatomic) NSNumber *mealPage;
// 美食页请求数据的页码
@property (strong,nonatomic) NSNumber *mealNextPage;
// 玩乐页请求下数据的页码
@property (strong,nonatomic) NSNumber *playPage;
// 玩乐页请求数据的页码
@property (strong,nonatomic) NSNumber *playNextPage;
// 数据总条数
@property (strong,nonatomic) NSString *rows;

@property(strong,nonatomic)NSMutableArray *msgArray;

// 城市按钮
@property (strong,nonatomic) UIButton *cityBtn;

@property (strong,nonatomic) UIButton *toTopBtn;

@property (assign,nonatomic) BOOL cityVCIsOpening;
@end


// 重用标识符
static NSString *const mealCellId = @"mealCellId";
static NSString *const playCellId = @"playCellId";
static NSString *const cityCellId = @"cityCellId";


@implementation YEssenceViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.managerView.userInteractionEnabled = YES;
    // 接收加号按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateView:) name:@"DateButtonClicked" object:nil];
    // 注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}
#pragma mark--接收消息--
-(void)didReceiveMessages:(NSArray *)aMessages{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadMessageCount" object:nil userInfo:@{@"messageArray":aMessages}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.msgArray = [NSMutableArray new];
    // 接收夜间模式转换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"NotificationNight" object:nil];
    self.toTopBtn = [self addToTopBtn];
    [self.view insertSubview:self.toTopBtn atIndex:0];
    [self.view addSubview:self.toTopBtn];
    self.toTopBtn.hidden = YES;
    [self.toTopBtn addTarget:self action:@selector(backToTop) forControlEvents:(UIControlEventTouchUpInside)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置view的背景色
    self.view.backgroundColor = YRGBbg;
    self.cityVCIsOpening = NO;
    [self addNavigationItems];
    
    // 初始化isSelected等
    self.isSelected = NO;
    self.isMeal = @"美食";
    self.categoryId = @"";
    self.cityId = 1;
    self.mealNextPage = @(1);
    self.playNextPage = @(1);
    // 初始化数组
    self.mealArr = [NSMutableArray array];
    self.playArr = [NSMutableArray array];
    // 刚加载时请求数据
    [self requestMealWithCityId:self.cityId categoryId:self.categoryId page:[NSString stringWithFormat:@"%d",self.mealNextPage.intValue]];
    [self requestPlayWithCityId:self.cityId categoryId:self.categoryId page:[NSString stringWithFormat:@"%d",self.playNextPage.intValue]];
    [self requestCity];
    
    // 注册cell
    [self.mealTableView registerNib:[UINib nibWithNibName:@"YMealOrPlayTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:mealCellId];
    [self.playTableView registerNib:[UINib nibWithNibName:@"YMealOrPlayTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:playCellId];
    [self.cityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cityCellId];
    
    self.scroll.delegate = self;
    
    // 为分段控制器添加方法
    [self.segment addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    // 自定义点击手势，使_popView消失
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    __weak typeof(self) weakSelf = self;
    // 下拉刷新
    self.mealTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.howRefresh = @"下拉刷新";
        //[weakSelf.mealArr removeAllObjects];
        [weakSelf requestMealWithCityId:weakSelf.cityId categoryId:weakSelf.categoryId page:@"1"];
        [weakSelf.mealTableView.mj_header endRefreshing];
    }];
    self.playTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.howRefresh = @"下拉刷新";
        //[weakSelf.playArr removeAllObjects];
        [weakSelf requestPlayWithCityId:weakSelf.cityId categoryId:weakSelf.categoryId page:@"1"];
        [weakSelf.playTableView.mj_header endRefreshing];
    }];
    // 上拉加载
    self.mealTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.howRefresh = @"上拉加载";
        [weakSelf requestMealWithCityId:weakSelf.cityId categoryId:weakSelf.categoryId page:[NSString stringWithFormat:@"%d",weakSelf.mealNextPage.intValue]];
        [weakSelf.mealTableView.mj_footer endRefreshing];
        
    }];
    self.playTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.howRefresh = @"上拉加载";
        [weakSelf requestPlayWithCityId:weakSelf.cityId categoryId:weakSelf.categoryId page:[NSString stringWithFormat:@"%d",weakSelf.playNextPage.intValue]];
        [weakSelf.playTableView.mj_footer endRefreshing];
    }];
    
}

- (void)backToTop{
    if ([self.isMeal isEqualToString:@"美食"]) {
        [self.mealTableView backToTop];
    }else{
        [self.playTableView backToTop];
    }
}



-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DateButtonClicked" object:nil];
}
- (void)addNavigationItems{
    
    // 设置导航栏左边的按钮
    _cityBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _cityBtn.frame = CGRectMake(10, 10, 40, 40);
    [_cityBtn setTitle:@"城市" forState:(UIControlStateNormal)];
    [_cityBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [_cityBtn addTarget:self action:@selector(tagClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_cityBtn];
    
    // 设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" heightImage:@"MainTagSubIconClick" target:self action:@selector(rightClick)];
    
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
        self.managerView.userInteractionEnabled = NO;
        [self addDateBtnAndPartyBtn];
    }else{
        self.managerView.userInteractionEnabled = YES;
        [self removeDateBtnAndPartyBtn];
    }
}


// 请求美食界面的数据
- (void)requestMealWithCityId:(NSInteger)cityId categoryId:(NSString *)categoryId page:(NSString *)page{
    // 拼接路径
    NSString *mealStr = kMealUrl(cityId,categoryId,page);
    // 为两个数组赋值
    [YMealModel parsesWithUrl:mealStr successRequest:^(id dict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.mealNextPage = ((YMealModel *)((NSArray *)dict).lastObject).nextPage;
            self.mealPage = ((YMealModel *)((NSArray *)dict).lastObject).page;
            
            NSInteger ID = ((YMealModel *)((NSArray *)dict).lastObject).ID;
            
            if (self.isSelected) {// 如果用类型搜索
                // 清空数组
                [self.mealArr removeAllObjects];
                
                if (self.mealPage.intValue == self.mealNextPage.intValue) {// 只有一页
                    [self.mealArr addObjectsFromArray:dict];
                    [self.mealTableView reloadData];
                    if (self.mealArr.count == 0) {
                        [self showAlertViewWithMessage:@"抱歉，暂时没有相关数据"];
                    }
                }else if(!self.mealPage){
                    [self.mealArr addObjectsFromArray:dict];
                    [self.mealTableView reloadData];
                }else{
                    [self.mealArr addObjectsFromArray:dict];
                    [self.mealTableView reloadData];
                }
                self.isSelected = NO;
                
            }else if ([self.howRefresh isEqualToString:@"下拉加载"]) {// 如果下拉刷新
                // 清空数组
                [self.mealArr removeAllObjects];
                
                if (self.mealPage.intValue == self.mealNextPage.intValue) {// 只有一页
                    [self.mealArr addObjectsFromArray:dict];
                    [self.mealTableView reloadData];
                    if (self.mealArr.count == 0) {
                        [self showAlertViewWithMessage:@"抱歉，暂时没有相关数据"];
                    }
                }else{
                    [self.mealArr addObjectsFromArray:dict];
                    [self.mealTableView reloadData];
                }
            }else{// 普通加载
                if(self.cityId != cityId){// 换城市
                    self.cityId = cityId;
                    [self.mealArr removeAllObjects];
                    [self.mealArr addObjectsFromArray:dict];
                    [self.mealTableView reloadData];
                }else{
                    if (((YMealModel *)(self.mealArr).lastObject).ID != ID) {// 判断是否加载到最后一页
                        [self.mealArr addObjectsFromArray:dict];
                        [self.mealTableView reloadData];
                    }else {
                        [self showAlertViewWithMessage:@"数据已全部加载"];
                    }
                }
            }
            
            

        });
        
    } failurRequest:^(NSError *error) {
        
    }];
    
    
}

// 请求玩乐界面的数据
- (void)requestPlayWithCityId:(NSInteger)cityId categoryId:(NSString *)categoryId page:(NSString *)page{
    
    // 拼接路径
    NSString *playStr = kPlayUrl(page,cityId,categoryId);
    
    // 为两个数组赋值
    [YPlayModel parsesWithUrl:playStr successRequest:^(id dict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.playNextPage = ((YPlayModel *)((NSArray *)dict).lastObject).nextPage;
            self.playPage = ((YPlayModel *)((NSArray *)dict).lastObject).page;
            NSInteger ID = ((YPlayModel *)((NSArray *)dict).lastObject).ID;

            if (self.isSelected) {// 如果用类型搜索
                // 清空数组
                [self.playArr removeAllObjects];
                
                if (self.playPage.intValue == self.playNextPage.intValue) {// 只有一页
                    [self.playArr addObjectsFromArray:dict];
                    [self.playTableView reloadData];
                    if (self.playArr.count == 0) {
                        [self showAlertViewWithMessage:@"抱歉，暂时没有相关数据"];
                    }
                }else if(!self.playPage){
                    [self.playArr addObjectsFromArray:dict];
                    [self.playTableView reloadData];
                }else{
                    [self.playArr addObjectsFromArray:dict];
                    [self.playTableView reloadData];
                }
                self.isSelected = NO;
                
            }else if ([self.howRefresh isEqualToString:@"下拉加载"]) {// 如果下拉刷新
                // 清空数组
                [self.playArr removeAllObjects];
                if (self.playPage.intValue == self.playNextPage.intValue) {// 只有一页
                    [self.playArr addObjectsFromArray:dict];
                    [self.playTableView reloadData];
                    if (self.playArr.count == 0) {
                        [self showAlertViewWithMessage:@"抱歉，暂时没有相关数据"];
                    }
                }else{
                    [self.playArr addObjectsFromArray:dict];
                    [self.playTableView reloadData];
                }
            }else{// 普通加载
                if(self.cityId != cityId){// 换城市
                    self.cityId = cityId;
                    [self.playArr removeAllObjects];
                    [self.playArr addObjectsFromArray:dict];
                    [self.playTableView reloadData];
                }else{
                    if (((YPlayModel *)(self.playArr).lastObject).ID != ID) {// 判断是否加载到最后一页
                        [self.playArr addObjectsFromArray:dict];
                        [self.playTableView reloadData];
                    }else {
                        [self showAlertViewWithMessage:@"数据已全部加载"];
                    }
                }
                
            }
            
            
        });
        
    } failurRequest:^(NSError *error) {
        
    }];
}

// 请求城市界面的数据
- (void)requestCity{
    
    // 为两个数组赋值
    [YCityModel parsesWithUrl:kCityIDUrl successRequest:^(id dict) {
        if (dict != nil){
            self.cityArr = dict;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.cityTableView reloadData];
            });
        }
    } failurRequest:^(NSError *error) {
        
    }];
}



- (void)tagClick{
    
    if (self.managerView.x == 0) {
        self.managerView.x = 130;
        self.cityVCIsOpening = YES;
    }else{
        self.managerView.x = 0;
        self.cityVCIsOpening = NO;
    }
}

// 导航栏右侧按钮触发的方法
- (void)rightClick{
    
    if (!self.isSelected) {
        
        _popView = [[YPopView alloc] initWithStr:self.isMeal];
        _popView.center = CGPointMake(kWidth, 0);
        [self.view addSubview:_popView];
        // 动画
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:3 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            
            _popView.center = self.view.center;
            
            _popView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
        } completion:^(BOOL finished) {
            
        }];

        [self.popView addGestureRecognizer:self.tap];
        self.isSelected = YES;
        // 点击btn触发的事件
        __weak typeof(self) __weakSelf = self;
        self.popView.ba = ^(NSInteger tag){
            __weakSelf.categoryId = [NSString stringWithFormat:@"%ld",tag];
            if (tag == 0) {
                __weakSelf.categoryId = @"";
            }
            if ([__weakSelf.isMeal isEqualToString:@"美食"]) {
                [__weakSelf requestMealWithCityId:__weakSelf.cityId categoryId:__weakSelf.categoryId page:@"1"];
            }else{
                [__weakSelf requestPlayWithCityId:__weakSelf.cityId categoryId:__weakSelf.categoryId page:@"1"];
            }
            [__weakSelf.popView removeFromSuperview];
            __weakSelf.popView.center = CGPointMake(kWidth, 0);
        };
    }else{
        [_popView removeFromSuperview];
        self.isSelected = NO;
        _popView.center = CGPointMake(kWidth, 0);
    }
}

// 点击手势触发的方法
- (void)tapAction{

    if (self.isSelected) {
        [self.popView removeFromSuperview];
        _popView.center = CGPointMake(kWidth, 0);
        self.isSelected = NO;
    }
    
}

#pragma mark -- scrollde 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView == self.mealTableView) {
        // 先获取屏幕上的所有cell
        NSArray *visibleCells = [self.mealTableView visibleCells];
        NSIndexPath *indexPath = [self.mealTableView indexPathForCell:visibleCells[0]];
        if (indexPath.row != 0) {
            self.toTopBtn.hidden = NO;
        }else{
            self.toTopBtn.hidden = YES;
        }
    }else if (scrollView == self.playTableView){
        // 先获取屏幕上的所有cell
        NSArray *visibleCells = [self.playTableView visibleCells];
        NSIndexPath *indexPath = [self.playTableView indexPathForCell:visibleCells[0]];
        if (indexPath.row != 0) {
            self.toTopBtn.hidden = NO;
        }else{
            self.toTopBtn.hidden = YES;
        }
    }else if (self.scroll == scrollView) {
        self.segment.selectedSegmentIndex = scrollView.contentOffset.x / kWidth;
        if (self.segment.selectedSegmentIndex == 0) {
            self.isMeal = @"美食";
            self.cityBtn.enabled = YES;
            self.cityBtn.hidden = NO;
            if (self.cityVCIsOpening) {
                self.managerView.x = 0;
                self.cityVCIsOpening = NO;
            }
            // 先获取屏幕上的所有cell
            NSArray *visibleCells = [self.mealTableView visibleCells];
            NSIndexPath *indexPath = [self.mealTableView indexPathForCell:visibleCells[0]];
            if (indexPath.row != 0) {
                self.toTopBtn.hidden = NO;
            }else{
                self.toTopBtn.hidden = YES;
            }
        }else{
            self.isMeal = @"玩乐";
            self.cityBtn.enabled = NO;
            self.cityBtn.hidden = YES;
            if (self.cityVCIsOpening) {
                self.managerView.x = 0;
                self.cityVCIsOpening = NO;
            }
            // 先获取屏幕上的所有cell
            NSArray *visibleCells = [self.playTableView visibleCells];
            NSIndexPath *indexPath = [self.playTableView indexPathForCell:visibleCells[0]];
            if (indexPath.row != 0) {
                self.toTopBtn.hidden = NO;
            }else{
                self.toTopBtn.hidden = YES;
            }
        }
        
    }
    
}
#pragma mark -- segment滑动换页
- (void)changePage:(UISegmentedControl *)segment{
    
    self.scroll.contentOffset = CGPointMake(kWidth * self.segment.selectedSegmentIndex, 0);
    if (self.segment.selectedSegmentIndex == 0) {
        self.isMeal = @"美食";
        self.cityBtn.enabled = YES;
        self.cityBtn.hidden = NO;
        if (self.cityVCIsOpening) {
            self.managerView.x = 0;
            self.cityVCIsOpening = NO;
        }
        // 先获取屏幕上的所有cell
        NSArray *visibleCells = [self.mealTableView visibleCells];
        NSIndexPath *indexPath = [self.mealTableView indexPathForCell:visibleCells[0]];
        if (indexPath.row != 0) {
            self.toTopBtn.hidden = NO;
        }else{
            self.toTopBtn.hidden = YES;
        }
    }else{
        self.isMeal = @"玩乐";
        self.cityBtn.enabled = NO;
        self.cityBtn.hidden = YES;
        if (self.cityVCIsOpening) {
            self.managerView.x = 0;
            self.cityVCIsOpening = NO;
        }
        // 先获取屏幕上的所有cell
        NSArray *visibleCells = [self.playTableView visibleCells];
        NSIndexPath *indexPath = [self.playTableView indexPathForCell:visibleCells[0]];
        NSLog(@"%ld",indexPath.row);
        if (indexPath.row != 0) {
            self.toTopBtn.hidden = NO;
        }else{
            self.toTopBtn.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.mealTableView) {
        return self.mealArr.count;
    }else if (tableView == self.playTableView) {
        return self.playArr.count;
    }else {
        return self.cityArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mealTableView) {
        
        YMealOrPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mealCellId forIndexPath:indexPath];
        cell.meal = self.mealArr[indexPath.row];
        return cell;
        
    }else if (tableView == self.playTableView) {
        
        YMealOrPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:playCellId forIndexPath:indexPath];
        cell.play = self.playArr[indexPath.row];
        return cell;
    }else{
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellId forIndexPath:indexPath];
        cell.textLabel.text = ((YCityModel *)self.cityArr[indexPath.row]).name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.mealTableView || tableView == self.playTableView) {
        return 222;
    }else{
        return 50;
    }
    
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.mealTableView) {
        
        MealDetailsViewController *mealVC = [[MealDetailsViewController alloc] init];
        
        if ([self.mealArr count] != 0) {
            YMealModel *model = self.mealArr[indexPath.row];
            mealVC.ID = [NSString stringWithFormat:@"%ld", model.ID];
            
        }
        mealVC.model = nil;
        
        [self.navigationController pushViewController:mealVC animated:YES];
        
    }else if (tableView == self.playTableView) {
        
        PlayDetailsViewController *playVC = [[PlayDetailsViewController alloc] init];
        if ([self.playArr count] != 0) {
            YPlayModel *model = self.playArr[indexPath.row];
            playVC.ID = [NSString stringWithFormat:@"%ld", model.ID];
        }
        playVC.isWhat = YES;
        
        [self.navigationController pushViewController:playVC animated:YES];
        
        
    }else{
        NSInteger cityId = ((YCityModel *)self.cityArr[indexPath.row]).baseCityId;
        [self.cityBtn setTitle:((YCityModel *)self.cityArr[indexPath.row]).name forState:(UIControlStateNormal)];
        self.managerView.x = 0;
        [self requestMealWithCityId:cityId categoryId:self.categoryId page:@"1"];
    }
    
}


// 弹框
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
