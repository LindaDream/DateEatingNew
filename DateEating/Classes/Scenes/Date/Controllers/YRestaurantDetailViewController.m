//
//  YRestaurantViewController.m
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YRestaurantDetailViewController.h"
#import "YRestaurantTableViewCell.h"
#import "YRestaurantDetailModel.h"
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
// 关注按钮上的label
@property(strong,nonatomic)UILabel *attentionLabel;
// 判断关注按钮是否被点击
@property(assign,nonatomic)BOOL isAttented;
// 尾部视图
@property(strong,nonatomic)UIView *footView;
@property(strong,nonatomic)UIButton *footBtn;
@property(strong,nonatomic)YRestaurantDetailModel *model;
@property(strong,nonatomic)NSString *object;
@end

static NSString *const restaurantCellIdentifier = @"restaurantCell";

@implementation YRestaurantDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getData];
    // AND查询
    AVQuery *nameQuery = [AVQuery queryWithClassName:@"MyAttention"];
    [nameQuery whereKey:@"name" equalTo:self.nameStr];
    AVQuery *userNameQuery = [AVQuery queryWithClassName:@"MyAttention"];
    [userNameQuery whereKey:@"userName" equalTo:[AVUser currentUser].username];
    AVQuery *query = [AVQuery andQueryWithSubqueries:[NSArray arrayWithObjects:nameQuery,userNameQuery, nil]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count != 0) {
            self.isAttented = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"guarantee_bg"] forState:(UIControlStateNormal)];
                self.attentionLabel.text = @"已关注";
                self.attentionLabel.textColor = [UIColor lightGrayColor];
                [self.attentionBtn addSubview:self.attentionLabel];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"guarantee_red_bg"] forState:(UIControlStateNormal)];
                self.attentionLabel.backgroundColor = [UIColor whiteColor];
                self.attentionLabel.text = @"关注";
                self.attentionLabel.textColor = [UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1];
                [self.attentionBtn addSubview:self.attentionLabel];
            });
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"餐厅详情";
    self.isAttented = YES;
    self.model = [YRestaurantDetailModel new];
    [self.restaurantTableView registerNib:[UINib nibWithNibName:@"YRestaurantTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:restaurantCellIdentifier];
    [self addHeadView];
    [self addFootView];
    if (self.fromDetailVC) {
        self.footView.hidden = YES;
    }
}
#pragma mark--数据解析--
- (void)getData{
    NSString *urlStr = [RestaurantDetail_URL(self.businessId) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [YRestaurantDetailModel parsesWithUrl:urlStr successRequest:^(id dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.model = dict;
            [self.restaurantTableView reloadData];
            [self addHeadView];
        });
    } failurRequest:^(NSError *error) {
        
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
        cell.desLabel.text = self.model.address;
    }else{
        cell.imgView.image = [UIImage imageNamed:@"mine_restaurant"];
        cell.desLabel.text = [NSString stringWithFormat:@"关注此餐厅的人(%ld)",self.count];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YMapViewController *mapVC = [YMapViewController new];
        mapVC.model = self.model;
        [self.navigationController pushViewController:mapVC animated:YES];
    }else{
        YAttentionViewController *attentionListVC = [YAttentionViewController new];
        attentionListVC.businessID = self.model.businessId;
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
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 160)];
    // 添加餐厅头像
    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 5;
    [self.headImgView setImageWithURL:[NSURL URLWithString:self.model.sPhotoUrl] placeholderImage:[UIImage imageNamed:@"DateLogo.jpg"]];
    [self.headView addSubview:self.headImgView];
    
    // 添加餐厅名称
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame) + 10, CGRectGetMinY(self.headImgView.frame) - 15, 200, 30)];
    self.nameLabel.text = self.model.name;
    [self.nameLabel setFont:[UIFont systemFontOfSize:16.0]];
    [self.headView addSubview:self.nameLabel];
    
    // 添加价格标签
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 10, 100, 30)];
    self.priceLabel.text = [NSString stringWithFormat:@"人均￥%@元",self.model.avgPrice];
    [self.priceLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.headView addSubview:self.priceLabel];
    
    // 添加类型标签
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.priceLabel.frame), CGRectGetMaxY(self.priceLabel.frame) + 5, 200, 30)];
    self.typeLabel.text = self.model.categoriesStr;
    [self.typeLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.headView addSubview:self.typeLabel];
    
    // 添加电话按钮
    self.telBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.telBtn.frame = CGRectMake(self.view.width - 50, CGRectGetMinY(self.nameLabel.frame), 30, 30);
    [self.telBtn setBackgroundImage:[UIImage imageNamed:@"tel"] forState:(UIControlStateNormal)];
    [self.telBtn addTarget:self action:@selector(telAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.headView addSubview:self.telBtn];
    
    // 添加关注按钮
    self.attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.typeLabel.frame) + 30, 160, 30)];
    self.attentionBtn.center = CGPointMake(self.headView.center.x, CGRectGetMaxY(self.typeLabel.frame) + 20);
    self.attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 2, 60, 26)];
    [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"guarantee_red_bg"] forState:(UIControlStateNormal)];
    self.attentionLabel.backgroundColor = [UIColor whiteColor];
    self.attentionLabel.text = @"关注";
    [self.attentionLabel setFont:[UIFont systemFontOfSize:14.0]];
    self.attentionLabel.textColor = [UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1];
    [self.attentionBtn addSubview:self.attentionLabel];
    [self.attentionBtn addTarget:self action:@selector(attentAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.attentionBtn.layer.masksToBounds = YES;
    self.attentionBtn.layer.cornerRadius = 20;
    [self.headView addSubview:self.attentionBtn];
    
    [self.restaurantTableView setTableHeaderView:self.headView];
}
#pragma mark--尾部视图--
- (void)addFootView{
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 50)];
    self.footView.backgroundColor = [UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1];
    self.footBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.footBtn.frame = CGRectMake(0, 0, self.footView.width, self.footView.height);
    self.footBtn.backgroundColor = [UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1];
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
        dateVC.addressStr = self.nameStr;
        dateVC.businessID = self.model.businessId;
        [self.navigationController popToViewController:dateVC animated:YES];
    }else{
        YPublishPartyViewController *partyVC = (YPublishPartyViewController *)[vcArr objectAtIndex:1];
        partyVC.addressStr = self.nameStr;
        partyVC.businessID = self.model.businessId;
        [self.navigationController popToViewController:partyVC animated:YES];
    }

}
#pragma mark--联系卖家--
- (void)telAction:(UIButton *)telBtn{
    //NSLog(@"%@",self.model.telephone);
    // 调用系统电话
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.model.telephone]]];
}
#pragma mark--关注餐厅--
- (void)attentAction:(UIButton *)attentBtn{
    AVObject *object = [AVObject objectWithClassName:@"MyAttention"];
    if (self.isAttented) {
        [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"guarantee_bg"] forState:(UIControlStateNormal)];
        self.attentionLabel.text = @"已关注";
        self.attentionLabel.textColor = [UIColor lightGrayColor];
        // 保存当前用户名
        [object setObject:[AVUser currentUser].username forKey:@"userName"];
        // 保存餐厅名称
        [object setObject:self.nameLabel.text forKey:@"name"];
        
        // 保存人均价格
        [object setObject:self.priceLabel.text forKey:@"avgPrice"];
        
        // 保存地址
        [object setObject:self.addressStr forKey:@"address"];
        
        // 保存类型
        [object setObject:self.typeLabel.text forKey:@"type"];
        
        // 保存businessId
        [object setObject:self.model.businessId forKey:@"businessId"];
        
        // 保存关注人数(NSInteger转换成NSNumber类型)
        [object setObject:[NSNumber numberWithInteger:self.count] forKey:@"count"];
        
        // 保存餐厅图片链接
        [object setObject:self.model.sPhotoUrl forKey:@"headImg"];
        
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
                        [[NSUserDefaults standardUserDefaults] setObject:object.objectId forKey:self.nameStr];
                    }
                }];
            }else{
                NSLog(@"您已关注,不可重复关注");
            }
        }];
        self.isAttented = NO;
    }else{
        [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"guarantee_red_bg"] forState:(UIControlStateNormal)];
        self.attentionLabel.text = @"关注";
        self.attentionLabel.textColor = [UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1];
        // 删除关注的数据
        // 执行 CQL 语句实现删除一个 MyAttention 对象
        self.object = [[NSUserDefaults standardUserDefaults] objectForKey:self.nameStr];
        NSLog(@"%@",self.object);
        [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"delete from MyAttention where objectId='%@'",self.object] callback:^(AVCloudQueryResult *result, NSError *error) {
            NSLog(@"删除成功");
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
