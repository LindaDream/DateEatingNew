//
//  YCaterViewController.m
//  DateEating
//
//  Created by lanou3g on 16/7/16.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YCaterViewController.h"
#import "YCaterTableViewCell.h"
#import "YNetWorkRequestManager.h"
#import "Request_Url.h"
#import "YCaterDetail.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YCaterViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *caterImage;
@property (weak, nonatomic) IBOutlet UILabel *caterName;
@property (weak, nonatomic) IBOutlet UILabel *caterAvgPrice;
@property (weak, nonatomic) IBOutlet UILabel *caterDishesType;

@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;


@property (strong, nonatomic) YCaterDetail *caterDetail;

@end

@implementation YCaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"餐厅详情";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:YRGBColor(248, 89, 64)};
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"YCaterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YCaterTableViewCell_Indentify];
    UIImage *image = [UIImage imageNamed:@"guarantee_red_bg"];
    
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2.0, 10, image.size.height/2.0, 10) resizingMode:UIImageResizingModeTile];
    [self.focusBtn setBackgroundImage:newImage forState:UIControlStateNormal];
    [self.messageBtn setBackgroundImage:newImage forState:UIControlStateNormal];
    // 请求数据
    [self getRequestData];
    
}

#pragma mark -- 请求数据 --
- (void)getRequestData {
    self.caterDetail = [[YCaterDetail alloc]init];
    NSString *businessId = [self.businessId stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    __weak typeof(self) weakSelf = self;
    [YNetWorkRequestManager getRequestWithUrl:CaterDetailRequest_Url(businessId) successRequest:^(id dict) {
        NSDictionary *modelDic = dict[@"data"];
        [weakSelf.caterDetail setValuesForKeysWithDictionary:modelDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    } failurRequest:^(NSError *error) {
        
    }];
}

// 将数据显示到页面上
- (void)reloadData {
    self.caterName.text = self.caterDetail.cater.name;
    self.caterAvgPrice.text = [NSString stringWithFormat:@"￥%@",self.caterDetail.cater.avgPrice];
    self.caterDishesType.text = self.caterDetail.cater.categoriesStr;
    [self.caterImage sd_setImageWithURL:[NSURL URLWithString:self.caterDetail.cater.sPhotoUrl]];
    [self.tableView reloadData];
}


#pragma mark -- 按钮事件 --
// 打电话事件
- (IBAction)telBtnAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.caterDetail.cater.telephone]]];
}


#pragma mark -- tableView的代理方法 --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCaterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YCaterTableViewCell_Indentify forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        NSString *title = [NSString stringWithFormat:@"%@(%@)",self.caterDetail.cater.address,@"100km"];
        [cell setCellWithImage:@"locationCell" title:title];
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            [cell setCellWithImage:@"mine_committed" title:[NSString stringWithFormat:@"正在进行中的约会（%ld）",self.caterDetail.openingEventCount]];
        } else {
            [cell setCellWithImage:@"mine_join" title:[NSString stringWithFormat:@"已经完成的约会（%ld）",self.caterDetail.finishEventCount]];
        }
    } else {
        if (indexPath.row == 0) {
            [cell setCellWithImage:@"mine_restaurant" title:[NSString stringWithFormat:@"关注此餐厅的人（%ld）",self.caterDetail.caterUserCount]];
        } else {
            [cell setCellWithImage:@"shopMessage" title:[NSString stringWithFormat:@"约饭留言板（%ld）",self.caterDetail.userContentCount]];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [YCaterTableViewCell getHeightForCellWithString:[NSString stringWithFormat:@"%@(%@)",self.caterDetail.cater.address,@"100km"]];
    }else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

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
