//
//  XMGFriendTrendsViewController.m
//  百思不得姐
//
//  Created by lanou3g on 16/5/6.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "YFunnyViewController.h"
#import "YFunnyTableViewCell.h"
#import "YFunnyNoImgTableViewCell.h"
#import "YEditViewController.h"
#import "YFunnyModel.h"
#import "YFunnyDetailViewController.h"

#define kContentLabelWith 386

@interface YFunnyViewController ()<UITableViewDataSource,UITableViewDelegate,YEditViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *funnyTableView;

@property (strong,nonatomic) NSMutableArray *arr;

@property (strong,nonatomic) UIButton *toTopBtn;
@end

static NSString *const funnyCellId = @"funnyCellId";
static NSString *const funnyNoImgCellId = @"funnyNoImgCellId";

@implementation YFunnyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 接收夜间模式转换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"NotificationNight" object:nil];

    // 设置导航栏标题
    self.navigationItem.title = @"趣事";
    // 设置view的背景色
    self.view.backgroundColor = YRGBbg;
    [self setRightBarButtonItem];
    // 注册
    [self.funnyTableView registerNib:[UINib nibWithNibName:@"YFunnyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:funnyCellId];
    [self.funnyTableView registerNib:[UINib nibWithNibName:@"YFunnyNoImgTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:funnyNoImgCellId];
    self.arr = [NSMutableArray array];
    self.funnyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.toTopBtn = [self addToTopBtn];
    [self.view insertSubview:self.toTopBtn atIndex:0];
    [self.view addSubview:self.toTopBtn];
    self.toTopBtn.hidden = YES;
    [self.toTopBtn addTarget:self action:@selector(backToTop) forControlEvents:(UIControlEventTouchUpInside)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)backToTop{
    [self.funnyTableView backToTop];
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    // 接收加号按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateView:) name:@"DateButtonClicked" object:nil];
    [self getAllFunny];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DateButtonClicked" object:nil];
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
        [self addDateBtnAndPartyBtn];
    }else{
        [self removeDateBtnAndPartyBtn];
    }
}
#pragma mark--设置发布按钮--
- (void)setRightBarButtonItem{
    
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 20, 20);
    [editBtn setImage:[UIImage imageNamed:@"编辑"] forState:(UIControlStateNormal)];
    [editBtn setImage:[UIImage imageNamed:@"编辑-1"] forState:(UIControlStateHighlighted)];
    [editBtn addTarget:self action:@selector(editedAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
}
// 编辑
- (void)editedAction{

    if (self.editVC == nil) {
        YEditViewController *editVC = [YEditViewController new];
        editVC.passVCBlock = ^(YEditViewController *eVC){
            self.editVC = eVC;
            eVC.delegate = self;
        };
        [self.navigationController pushViewController:editVC animated:YES];
    }else{
        [self showAlertViewWithMessage:@"消息正在发送中，请稍后进入编辑界面"];
    }
    
    
}

- (void)sendFinalWithState:(NSString *)isSuccess{
    self.editVC = nil;
    [self showAlertViewWithMessage:isSuccess];
    [self getAllFunny];
}


- (void)friendsClick{

    YLogFunc;
    
}

- (void)getAllFunny{
    [YFunnyModel parsesFunnyWithsuccessRequest:^(id dict) {
        if (dict != nil){
            [self.arr removeAllObjects];
            NSArray *array = dict;
            [self.arr removeAllObjects];
            for (NSInteger i = array.count - 1; i >= 0; i--) {
                [self.arr addObject:array[i]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.funnyTableView reloadData];
            });
        }
    } failurRequest:^(NSError *error) {
        NSLog(@"%ld",error.code);
    }];
}


#pragma mark -- scrollde 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.funnyTableView) {
        // 先获取屏幕上的所有cell
        NSArray *visibleCells = [self.funnyTableView visibleCells];
        NSIndexPath *indexPath = [self.funnyTableView indexPathForCell:visibleCells[0]];
        if (indexPath.row != 0) {
            self.toTopBtn.hidden = NO;
        }else{
            self.toTopBtn.hidden = YES;
        }
    }
    
}


#pragma mark--UITableViewDataSource--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.arr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YFunnyModel *funny = self.arr[indexPath.row];
    if (funny.imgArr.count > 0) {
        YFunnyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:funnyCellId forIndexPath:indexPath];
        cell.funny = funny;
        return cell;
    }else{
    
        YFunnyNoImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:funnyNoImgCellId forIndexPath:indexPath];
        cell.funny = funny;
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    YFunnyModel *funny = self.arr[indexPath.row];
    if (funny.imgArr.count > 0) {
        return [YFunnyTableViewCell cellHeight:funny];
    }else{
        return [YFunnyNoImgTableViewCell cellHeight:funny];
    }
    
}
#pragma mark--UITableViewDelegate--
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YFunnyModel *funny = self.arr[indexPath.row];
    YFunnyDetailViewController *funnyDetailVC = [YFunnyDetailViewController new];
    funnyDetailVC.funny = funny;
    [self.navigationController pushViewController:funnyDetailVC animated:YES];
    
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
