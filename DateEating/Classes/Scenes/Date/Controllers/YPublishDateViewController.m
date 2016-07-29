//
//  YPublishDateViewController.m
//  DateEating
//
//  Created by user on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YPublishDateViewController.h"
#import "YThemeTableViewCell.h"
#import "YObjectTableViewCell.h"
#import "YConcreteTableViewCell.h"
#import "YTimeOrAddressTableViewCell.h"
#import "YFindeTableViewCell.h"
#import "YTimePiker.h"
#import "YRestaurantViewController.h"
#import "YCompleteViewController.h"
@interface YPublishDateViewController ()<
    UITableViewDataSource,
    UITableViewDelegate,
    UIPickerViewDataSource,
    UIPickerViewDelegate,
    passObjectValue,
    passConcreteValue,
    UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *dateTableView;
// 判断cell上的按钮是否点击
@property(assign,nonatomic)BOOL isSelected;
// 显示picker的背景视图
@property(strong,nonatomic)UIView *backView;
// picker视图
@property(strong,nonatomic)UIPickerView *pickerView;
@property(strong,nonatomic)NSString *dateStr;
@property(strong,nonatomic)NSString *message;
@property(strong,nonatomic)NSString *dateTmpStr;
@property(strong,nonatomic)NSString *hourTmpStr;
@property(strong,nonatomic)NSString *minuteTmpStr;
// 约会时间
@property(strong,nonatomic)NSString *timeStr;
@property(assign,nonatomic)BOOL isDateView;
// 约会主题
@property(strong,nonatomic)NSString *themeStr;
// 约会说明
@property(strong,nonatomic)NSString *findStr;
// 约会对象
@property(strong,nonatomic)NSString *dateObj;
// 约会花费
@property(strong,nonatomic)NSString *concrete;
@end

// 设置重用标识符
static NSString *const themeCellIdentifier = @"themeCell";
static NSString *const objectCellIdentifier = @"objectCell";
static NSString *const concreteCellIdentifier = @"concerteCell";
static NSString *const timeOrAddressCellIdentifier = @"timeOrAddressCell";
static NSString *const findeCellIdentifier = @"findeCell";

@implementation YPublishDateViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:243/255.0 green:32/255.0 blue:37/255.0 alpha:1];
        
    }
    return self;
}
#pragma mark--返回方法--
- (void)backAction{
    if (nil != [[AVUser currentUser] objectForKey:@"age"] && nil != [[AVUser currentUser] objectForKey:@"gender"] && nil != [[AVUser currentUser] objectForKey:@"constellation"]) {
        if (nil != self.timeStr && nil != self.themeStr && nil != self.addressStr && nil != self.findStr && nil != self.concrete && nil != self.dateObj){
            // 发送publishDate通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"publishDate" object:nil userInfo:@{@"theme":self.themeStr,@"time":self.timeStr,@"address":self.addressStr,@"description":self.findStr}];
            AVObject *object = [AVObject objectWithClassName:@"MyDate"];
            [object setObject:[AVUser currentUser].username forKey:@"userName"];
            [object setObject:self.themeStr forKey:@"theme"];
            [object setObject:self.dateObj forKey:@"dateObject"];
            [object setObject:self.concrete forKey:@"concrete"];
            [object setObject:self.timeStr forKey:@"time"];
            [object setObject:self.addressStr forKey:@"address"];
            [object setObject:self.findStr forKey:@"description"];
            [object setObject:self.businessID forKey:@"businessID"];
            [object setObject:@"Our" forKey:@"Our"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"保存成功");
                }
            }];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"请完善约会信息!" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertView addAction:doneAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先完善资料再来发布约会!" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            YCompleteViewController *completeVC = [YCompleteViewController new];
            [self.navigationController pushViewController:completeVC animated:YES];
        }];
        [alertView addAction:doneAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.dateTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布约会";
    self.isSelected = YES;
    self.dateStr = @"".mutableCopy;
    // 注册cell
    [self.dateTableView registerNib:[UINib nibWithNibName:@"YThemeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:themeCellIdentifier];
    [self.dateTableView registerNib:[UINib nibWithNibName:@"YObjectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:objectCellIdentifier];
    [self.dateTableView registerNib:[UINib nibWithNibName:@"YConcreteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:concreteCellIdentifier];
    [self.dateTableView registerNib:[UINib nibWithNibName:@"YTimeOrAddressTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:timeOrAddressCellIdentifier];
    [self.dateTableView registerNib:[UINib nibWithNibName:@"YFindeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:findeCellIdentifier];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 1;
    }
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            YThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:themeCellIdentifier forIndexPath:indexPath];
            self.themeStr = cell.themeTF.text;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            YFindeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:findeCellIdentifier forIndexPath:indexPath];
            self.findStr = cell.findeTF.text;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (indexPath.section == 1){
        YObjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:objectCellIdentifier forIndexPath:indexPath];
        cell.objDelegate = self;
        cell.isSelected = self.isSelected;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            YConcreteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:concreteCellIdentifier forIndexPath:indexPath];
            cell.delegate = self;
            cell.isSelect = self.isSelected;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1 || indexPath.row == 2){
            YTimeOrAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeOrAddressCellIdentifier forIndexPath:indexPath];
            if (indexPath.row == 1) {
                cell.timeOrAddLabel.text = @"时间";
                cell.addressLabel.text = self.timeStr;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.timeOrAddLabel.text = @"地点";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.addressLabel.text = self.addressStr;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            return cell;
        }
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"主题";
    }else if (section == 1){
        return @"约会的对象";
    }else{
        return @"具体信息";
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 1) {
        [self addPickerView];
    }else if(indexPath.section == 2 && indexPath.row == 2){
        YRestaurantViewController *restaurantVC = [YRestaurantViewController new];
        restaurantVC.isDateView = self.isDateView;
        restaurantVC.passValueBlock = ^(NSString *addressStr,NSString *businessID){
            self.addressStr = addressStr;
            self.businessID = businessID;
            [self.dateTableView reloadData];
        };
        [self.navigationController pushViewController:restaurantVC animated:YES];
    }
}
#pragma mark--cell上的代理方法--
-(void)passConcreteValue:(NSString *)concrete cell:(YConcreteTableViewCell *)cell{
    self.concrete = concrete;
    if (!cell.isSelect) {
        self.isSelected = YES;
    }else{
        self.isSelected = NO;
    }
}
-(void)passObject:(NSString *)dateObj cell:(YObjectTableViewCell *)cell{
    self.dateObj = dateObj;
    if (!cell.isSelected) {
        self.isSelected = YES;
    }else{
        self.isSelected = NO;
    }
}
#pragma mark--搭建picker视图--
- (void)addPickerView{
    self.dateStr = @"".mutableCopy;
    // 背景view
    self.backView = [[UIView alloc] initWithFrame:self.view.frame];
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:self.backView];
    
    // pickerView
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0,250,300)];
    self.pickerView.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    self.pickerView.layer.masksToBounds = YES;
    self.pickerView.layer.cornerRadius = 10;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    // 设置选中当天日期
    NSString *date = nil;
    NSInteger index = 0;
    NSDateFormatter *fomatter = [NSDateFormatter new];
    [fomatter setDateFormat:@"YYYY-MM-dd"];
    date = [fomatter stringFromDate:[NSDate date]];
    for (NSString *dateStr in [[YTimePiker sharedYTimePiker] dateArray]) {
        if ([[dateStr substringToIndex:10] isEqualToString:date]) {
            index = [[[YTimePiker sharedYTimePiker] dateArray] indexOfObject:dateStr];
        }
    }
    [self.pickerView selectRow:index inComponent:0 animated:YES];
    [self.backView addSubview:self.pickerView];
}
#pragma mark--pickerView的dataSource协议中的方法，返回控件包含几列--
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
#pragma mark--放方法决定该控件包含多少个列表项--
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [[YTimePiker sharedYTimePiker] dateArray].count;
    }else if (component == 1){
        return [[YTimePiker sharedYTimePiker] hourArray].count;
    }else{
        return [[YTimePiker sharedYTimePiker] minuteArray].count;
    }
}

#pragma mark--pickerView点击方法--
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.dateTmpStr = [[[YTimePiker sharedYTimePiker] dateArray] objectAtIndex:row];
    }else if (component == 1){
        self.hourTmpStr = [NSString stringWithFormat:@"%@ ",[[[YTimePiker sharedYTimePiker] hourArray] objectAtIndex:row]];
    }
    if (component == 2) {
        self.minuteTmpStr = [[[YTimePiker sharedYTimePiker] minuteArray] objectAtIndex:row];
        self.message = [NSString stringWithFormat:@"%@%@ : %@",self.dateTmpStr,self.hourTmpStr,self.minuteTmpStr];
        [self selectedTime:self.message];
    }
}
- (void)selectedTime:(NSString *)message{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您选择的时间是:%@",message] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            self.timeStr = message;
            self.dateStr = @"".mutableCopy;
            [self.backView removeFromSuperview];
            [self.dateTableView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            self.dateStr = @"".mutableCopy;
        }];
        [alertView addAction:cancelAction];
        [alertView addAction:doneAction];
        [self presentViewController:alertView animated:YES completion:nil];
}
#pragma mark--设置每列的宽度--
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0) {
        return 160;
    }else if(component == 1){
        return 30;
    }else{
        return 30;
    }
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textAlignment = UITextAlignmentCenter;
    if (component == 0) {
        label.frame = CGRectMake(0, 0, 160, 30);
        label.text = [[[YTimePiker sharedYTimePiker] dateArray] objectAtIndex:row];
    }else if (component == 1){
        label.frame = CGRectMake(0, 0, 30, 30);
        label.text = [[[YTimePiker sharedYTimePiker] hourArray] objectAtIndex:row];
    }else if (component == 2){
        label.frame = CGRectMake(0, 0, 30, 30);
        label.text = [[[YTimePiker sharedYTimePiker] minuteArray] objectAtIndex:row];
    }
    return label;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.backView removeFromSuperview];
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
