//
//  YRestaurantViewController.m
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YRestaurantDetailViewController.h"
#import "YRestaurantTableViewCell.h"
#import "YCaterDetail.h"
#import "YPublishDateViewController.h"
#import "YMapViewController.h"
#import "YAttentionViewController.h"
#import "YPublishPartyViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>// 引用发送消息视图的头文件
@interface YRestaurantDetailViewController ()<
UITableViewDataSource,
UITableViewDelegate,
MFMessageComposeViewControllerDelegate
>
// 头部视图
@property(strong,nonatomic)UIView *headView;
// 餐厅头像
@property(strong,nonatomic)UIImageView *headImgView;
// 餐厅名称
@property(strong,nonatomic)UILabel *nameLabel;
// 价格
@property(strong,nonatomic)UILabel *priceLabel;
// 餐厅类型
@property(strong,nonatomic)UILabel *typeLabel;
// 电话按钮
@property(strong,nonatomic)UIButton *telBtn;
// 关注按钮
@property(strong,nonatomic)UIButton *attentionBtn;
// 判断关注按钮是否被点击
@property(assign,nonatomic)BOOL isAttented;
// 尾部视图
@property(strong,nonatomic)UIView *footView;
@property(strong,nonatomic)UIButton *footBtn;
@property(strong,nonatomic)YCaterDetail *model;
@property(strong,nonatomic)NSString *object;
@end

static NSString *const restaurantCellIdentifier = @"restaurantCell";

@implementation YRestaurantDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getData];
    [self isAttition];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"餐厅详情";
    self.isAttented = YES;
    self.model = [YCaterDetail new];
    [self.restaurantTableView registerNib:[UINib nibWithNibName:@"YRestaurantTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:restaurantCellIdentifier];
    [self addHeadView];
    if (self.fromDetailVC == NO) {
        [self addFootView];
    }
}
#pragma mark--数据解析--
- (void)getData{
    NSString *urlStr;
    if (self.fromDetailVC && !self.ourSeverMark) {
        urlStr = [RestaurantDetail_URL(self.eventId) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    } else {
        urlStr = [CaterDetailRequest_Url(self.businessId)stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    __weak typeof(self) weakSelf = self;
    [YNetWorkRequestManager getRequestWithUrl:urlStr successRequest:^(id dict) {
        NSDictionary *modelDic = dict[@"data"];
        [weakSelf.model setValuesForKeysWithDictionary:modelDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.restaurantTableView reloadData];
            //self.restaurantTableView.tableHeaderView = nil;
            [self setData];
        });
    } failurRequest:^(NSError *error) {
        
    }];
}

- (void)setData {
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.model.cater.sPhotoUrl] placeholderImage:[UIImage imageNamed:@"DateLogo.jpg"]];
    self.nameLabel.text = self.model.cater.name;
    self.priceLabel.text = [NSString stringWithFormat:@"人均￥%@元",self.model.cater.avgPrice];
    self.typeLabel.text = self.model.cater.categoriesStr;
}

// 判断是否关注过此餐厅
- (void)isAttition {
    // AND查询
    AVQuery *nameQuery = [AVQuery queryWithClassName:@"MyAttention"];
    [nameQuery whereKey:@"name" equalTo:self.nameStr];
    NSLog(@"%@",self.nameStr);
    AVQuery *userNameQuery = [AVQuery queryWithClassName:@"MyAttention"];
    [userNameQuery whereKey:@"userName" equalTo:[AVUser currentUser].username];
    AVQuery *query = [AVQuery andQueryWithSubqueries:[NSArray arrayWithObjects:nameQuery,userNameQuery, nil]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count != 0) {
            self.isAttented = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"guarantee_bg"] forState:(UIControlStateNormal)];
                [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [self.attentionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"guarantee_red_bg"] forState:(UIControlStateNormal)];
                [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
                [self.attentionBtn setTitleColor:YRGBColor(243, 32, 37) forState:UIControlStateNormal];
            });
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:restaurantCellIdentifier forIndexPath:indexPath];
    CGRect rect = cell.desLabel.frame;
    CGFloat height = [self textHeightForLabel:cell.desLabel];
    rect.size.height = height;
    cell.frame = rect;
    if (indexPath.section == 0) {
        cell.imgView.image = [UIImage imageNamed:@"locationCell"];
        cell.desLabel.text = self.model.cater.address;
    }else{
        cell.imgView.image = [UIImage imageNamed:@"mine_restaurant"];
        cell.desLabel.text = [NSString stringWithFormat:@"关注此餐厅的人(%ld)",self.model.caterUserCount];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YMapViewController *mapVC = [YMapViewController new];
        mapVC.model = self.model.cater;
        [self.navigationController pushViewController:mapVC animated:YES];
    }else{
        YAttentionViewController *attentionListVC = [YAttentionViewController new];
        attentionListVC.businessID = self.model.cater.businessId;
        [self.navigationController pushViewController:attentionListVC animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    sectionView.backgroundColor = [UIColor lightGrayColor];
    return sectionView;
}
#pragma mark--设置头部视图--
- (void)addHeadView{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    // 添加餐厅头像
    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 5;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.model.cater.sPhotoUrl] placeholderImage:[UIImage imageNamed:@"DateLogo.jpg"]];
    [self.headView addSubview:self.headImgView];
    
    // 添加餐厅名称
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame) + 10, CGRectGetMinY(self.headImgView.frame), 150, 20)];
    //self.nameLabel.text = self.model.cater.name;
    [self.nameLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.headView addSubview:self.nameLabel];
    
    // 添加价格标签
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 12, 150, 20)];
    //self.priceLabel.text = [NSString stringWithFormat:@"人均￥%@元",self.model.cater.avgPrice];
    [self.priceLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.headView addSubview:self.priceLabel];
    
    // 添加类型标签
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.priceLabel.frame), CGRectGetMaxY(self.priceLabel.frame)+8, 150, 20)];
    //self.typeLabel.text = self.model.cater.categoriesStr;
    [self.typeLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.headView addSubview:self.typeLabel];
    
    // 添加电话按钮
    self.telBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.telBtn.frame = CGRectMake(kWidth - 50, CGRectGetMinY(self.nameLabel.frame), 30, 30);
    [self.telBtn setBackgroundImage:[UIImage imageNamed:@"tel"] forState:(UIControlStateNormal)];
    [self.telBtn addTarget:self action:@selector(telAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.headView addSubview:self.telBtn];
    
    // 添加关注按钮
    self.attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    self.attentionBtn.center = CGPointMake(self.headView.width/2.0, CGRectGetMaxY(self.headImgView.frame) + 25);
    self.attentionBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.attentionBtn addTarget:self action:@selector(attentAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.headView addSubview:self.attentionBtn];
    
    [self.restaurantTableView setTableHeaderView:self.headView];
}
#pragma mark--尾部视图--
- (void)addFootView{
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, self.view.width, 50)];
    self.footView.backgroundColor = [UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1];
    self.footBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.footBtn.frame = CGRectMake(0, 0, kWidth, self.footView.height);
    self.footBtn.backgroundColor = [UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1];
    self.footBtn.titleLabel.textAlignment = UITextAlignmentCenter;
    [self.footBtn setTitle:@"吃这家" forState:(UIControlStateNormal)];
    [self.footBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.footBtn addTarget:self action:@selector(footBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.footView addSubview:self.footBtn];
    [self.view addSubview:self.footView];
}
#pragma mark--点击"吃这家"按钮方法实现--
- (void)footBtnAction:(UIButton *)btn{
    NSArray *vcArr = self.navigationController.viewControllers;
    if (self.isDateView) {
        YPublishDateViewController *dateVC = (YPublishDateViewController *)[vcArr objectAtIndex:1];
        dateVC.addressStr = self.model.cater.name;
        dateVC.businessID = self.model.cater.businessId;
        [self.navigationController popToViewController:dateVC animated:YES];
    }else{
        YPublishPartyViewController *partyVC = (YPublishPartyViewController *)[vcArr objectAtIndex:1];
        partyVC.addressStr = self.model.cater.name;
        partyVC.businessID = self.model.cater.businessId;
        [self.navigationController popToViewController:partyVC animated:YES];
    }

}
#pragma mark--联系卖家--
- (void)telAction:(UIButton *)telBtn{
    // 调用系统电话
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.model.cater.telephone]]];
}
#pragma mark--关注餐厅--
- (void)attentAction:(UIButton *)attentBtn{
    AVObject *object = [AVObject objectWithClassName:@"MyAttention"];
    if (self.isAttented) {
        [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"guarantee_bg"] forState:(UIControlStateNormal)];
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        // 保存当前用户名
        [object setObject:[AVUser currentUser].username forKey:@"userName"];
        // 保存餐厅名称
        [object setObject:self.model.cater.name forKey:@"name"];
        // 保存人均价格
        [object setObject:self.model.cater.avgPrice forKey:@"avgPrice"];
        // 保存地址
        [object setObject:self.model.cater.address forKey:@"address"];
        // 保存类型
        [object setObject:self.model.cater.categories forKey:@"type"];
        // 保存businessId
        [object setObject:self.model.cater.businessId forKey:@"businessId"];
        // 保存关注人数(NSInteger转换成NSNumber类型)
        [object setObject:[NSNumber numberWithInteger:self.model.userContentCount] forKey:@"count"];
        // 保存餐厅图片链接
        [object setObject:self.model.cater.sPhotoUrl forKey:@"headImg"];
        // AND查询
        AVQuery *nameQuery = [AVQuery queryWithClassName:@"MyAttention"];
        [nameQuery whereKey:@"name" equalTo:self.nameStr];
        AVQuery *userNameQuery = [AVQuery queryWithClassName:@"MyAttention"];
        [userNameQuery whereKey:@"userName" equalTo:[AVUser currentUser].username];
        AVQuery *query = [AVQuery andQueryWithSubqueries:[NSArray arrayWithObjects:nameQuery,userNameQuery, nil]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count == 0) {
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"保存成功");
                        [[NSUserDefaults standardUserDefaults] setObject:object.objectId forKey:self.model.cater.name];
                    }
                }];
            }else{
                NSLog(@"您已关注,不可重复关注");
            }
        }];
        self.isAttented = NO;
    }else{
        [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"guarantee_red_bg"] forState:(UIControlStateNormal)];
        [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:YRGBColor(243, 32, 37) forState:UIControlStateNormal];
        // 删除关注的数据
        // 执行 CQL 语句实现删除一个 MyAttention 对象
        self.object = [[NSUserDefaults standardUserDefaults] objectForKey:self.nameStr];
        NSLog(@"%@",self.nameStr);
        [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"delete from MyAttention where objectId='%@'",self.object] callback:^(AVCloudQueryResult *result, NSError *error) {
            if (result.results != nil) {
                NSLog(@"删除成功");
            }else{
                NSLog(@"error = %ld",error.code);
            }
        }];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.nameStr];
        self.isAttented = YES;
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
