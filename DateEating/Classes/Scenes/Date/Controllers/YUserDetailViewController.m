//
//  YUserDetailViewController.m
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YUserDetailViewController.h"
#import "YNetWorkRequestManager.h"
#import "YUserDetailModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YDateListTableViewCell.h"
#import "YDescTableViewCell.h"
#import "YHeaderTableViewCell.h"
#import "YImageTableViewCell.h"
#import "YCaterTableViewCell.h"
#import "YHobbyTableViewCell.h"
@interface YUserDetailViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) YUserDetailModel *userDetail;
@property (strong, nonatomic) NSMutableArray *imageUrlArray;

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) NSMutableArray *hobbyArray;

@end

@implementation YUserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.hobbyArray = [NSMutableArray array];
    if ([self.model.ourSeverMark isEqualToString:@"Our"]) {
        [self getOurData];
    } else {
        // 查询数据
        [self getRequestData];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = view;
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"YDescTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YDescTableViewCell_Indentify];
    [self.tableView registerNib:[UINib nibWithNibName:@"YDateListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YDateListTableViewCell_Identify];
    [self.tableView registerNib:[UINib nibWithNibName:@"YHeaderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YHeaderTableViewCell_Indentify];
    [self.tableView registerClass:[YImageTableViewCell class] forCellReuseIdentifier:YImageTableViewCell_Indentify];
    [self.tableView registerClass:[YHobbyTableViewCell class] forCellReuseIdentifier:YHobbyTableViewCell_Identify];
    [self.tableView registerNib:[UINib nibWithNibName:@"YCaterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YCaterTableViewCell_Indentify];
    
}

// 懒加载
- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}

#pragma mark -- 查询数据 --
- (void)getRequestData {
    self.userDetail = [[YUserDetailModel alloc]init];
    NSInteger userId;
    if (self.model != nil) {
        userId = self.model.userId;
    } else {
        userId = self.userId;
    }
    
    __weak typeof(self) weakSelf = self;
    [YNetWorkRequestManager getRequestWithUrl:UserDetailRequest_Url(userId) successRequest:^(id dict) {
        NSDictionary *modelDic = dict[@"data"];
        [weakSelf.userDetail setValuesForKeysWithDictionary:modelDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf reloadData];
        });
    } failurRequest:^(NSError *error) {
        
    }];
}

- (void)getOurData {
    self.userDetail = [[YUserDetailModel alloc]init];
    _userDetail.nick = self.model.user.nick;
    _userDetail.age = self.model.user.age;
    _userDetail.gender = self.model.user.gender;
    _userDetail.constellation = self.model.user.constellation;
    _userDetail.pics = [NSString stringWithFormat:@"%@,",self.model.user.userImageUrl];
}

#pragma mark -- 数据加载完成后显示数据 --
- (void)reloadData {
    self.imageUrlArray = [self.userDetail.pics componentsSeparatedByString:@","].mutableCopy;
    [self.imageUrlArray removeLastObject];
    // tableVIew
    if (self.userDetail.personalInfo != nil) {
        NSDictionary *dic = @{@"签名":self.userDetail.personalInfo};
        [self.dataArray addObject:dic];
    }
    if (self.userDetail.district != nil) {
        NSDictionary *dic = @{@"地区":self.userDetail.district};
        [self.dataArray addObject:dic];
    }
    if (self.userDetail.occupation != 0) {
        NSInteger index = self.userDetail.occupation;
        NSArray *array = array2;
        NSDictionary *dic = @{@"职业":array[index]};
        [self.dataArray addObject:dic];
        
    }
    if (self.userDetail.marriage != 0) {
        NSString *string;
        if (self.userDetail.marriage == 1) {
            string = @"已婚";
        }else {
            string = @"未婚";
        }
        NSDictionary *dic = @{@"情感":string};
        [self.dataArray addObject:dic];
    }
    if (self.userDetail.alcohol != 0) {
        NSString *string;
        if (self.userDetail.alcohol == 1) {
            string = @"是";
        }else {
            string = @"否";
        }
        NSDictionary *dic = @{@"喝酒":string};
        [self.dataArray addObject:dic];
    }
    if (self.userDetail.smoking != 0) {
        NSString *string;
        if (self.userDetail.smoking == 1) {
            string = @"是";
        }else {
            string = @"否";
        }
        NSDictionary *dic = @{@"抽烟":string};
        [self.dataArray addObject:dic];
    }
    
    if (![self.userDetail.restaurant.name isEqualToString:@""]) {
        NSDictionary *dic = @{@"餐厅":self.userDetail.restaurant};
        [self.hobbyArray addObject:dic];
    }
    if (self.userDetail.movie.count != 0) {
        NSDictionary *dic = @{@"电影":self.userDetail.movie};
        [self.hobbyArray addObject:dic];
    }
    if (self.userDetail.travel.count != 0) {
        NSDictionary *dic = @{@"旅游":self.userDetail.travel};
        [self.hobbyArray addObject:dic];
    }
    if (self.userDetail.hobby.count != 0) {
        NSDictionary *dic = @{@"爱好":self.userDetail.hobby};
        [self.hobbyArray addObject:dic];
    }
    [self.tableView reloadData];
    
}

#pragma mark -- tableView 代理 --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.hobbyArray.count == 0) {
        return 3;
    } else {
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        if (self.userDetail.event.user != nil) {
            return 2;
        } else {
            return 1;
        }
    } else if(section == 2){
        return self.dataArray.count;
    } else {
        return self.hobbyArray.count + 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            YHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YHeaderTableViewCell_Indentify forIndexPath:indexPath];
            cell.model = self.userDetail;
            return cell;
        } else {
            YImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YImageTableViewCell_Indentify forIndexPath:indexPath];
            cell.imageArray = self.imageUrlArray;
            return cell;
        }
    } else if(indexPath.section == 1) {
        if (self.userDetail.event.user != nil) {
            if (indexPath.row == 0) {
                YDateListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YDateListTableViewCell_Identify forIndexPath:indexPath];
                cell.model = self.userDetail.event;
                return cell;
            } else {
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nil"];
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.text = [NSString stringWithFormat:@"参与过的（%ld）",self.userDetail.joinedEvent_count];
                return cell;
            }
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nil"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = [NSString stringWithFormat:@"参与过的（%ld）",self.userDetail.joinedEvent_count];
            return cell;
        }
    } else if(indexPath.section == 2) {
        YDescTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YDescTableViewCell_Indentify forIndexPath:indexPath];
        NSDictionary *dic = self.dataArray[indexPath.row];
        [cell setCellWithName:dic.allKeys.firstObject desc:dic.allValues.firstObject];
        return cell;
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.textLabel.text = @"兴趣爱好";
            return cell;
        }else if (indexPath.row == 1) {
            NSDictionary *dic = self.hobbyArray.firstObject;
            if ([dic.allKeys.firstObject isEqualToString:@"餐厅"]) {
                YCaterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YCaterTableViewCell_Indentify forIndexPath:indexPath];
                [cell setCellWithImage:@"mine_hobby_restaurant" title:[NSString stringWithFormat:@"%@等%ld家餐厅",self.userDetail.restaurant.name,self.userDetail.restaurant.len]];
                return cell;
            } else {
                YHobbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YHobbyTableViewCell_Identify forIndexPath:indexPath];
                cell.dic = self.hobbyArray[indexPath.row - 1];
                return cell;
            }
        }else {
            YHobbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YHobbyTableViewCell_Identify forIndexPath:indexPath];
            cell.dic = self.hobbyArray[indexPath.row-1];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 140;
        } else {
            return [YImageTableViewCell getHeightForCell:self.imageUrlArray.count];
        }
    } else if(indexPath.section == 1){
        if (self.userDetail.event.user != nil) {
            if (indexPath.row == 0) {
                return 200;
            } else {
                return 50;
            }
        }else {
            return 50;
        }
    } else if (indexPath.section == 2) {
        NSDictionary *dict = self.dataArray.firstObject;
        if ([dict.allKeys.firstObject isEqualToString:@"签名"] && indexPath.row == 0) {
            return [YDescTableViewCell getHeightForCellWithString:dict.allValues.firstObject];
        } else {
            return 50;
        }
    } else {
        NSDictionary *dic = self.hobbyArray.firstObject;
        if (indexPath.row == 0) {
            return 30;
        }
        if ([dic.allKeys.firstObject isEqualToString:@"餐厅"] && indexPath.row == 1) {
            return 40;
        }else {
            return 50;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else if (section == 3){
        return 0.01;
    } else {
        return 20;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2 && self.hobbyArray.count > 0) {
        return 20;
    } else {
        return 0.01;
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
