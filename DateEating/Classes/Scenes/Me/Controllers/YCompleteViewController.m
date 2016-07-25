//
//  YCompleteViewController.m
//  DateEating
//
//  Created by user on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YCompleteViewController.h"

@interface YCompleteViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(assign,nonatomic)NSInteger gender;
@property(strong,nonatomic)NSMutableArray *constellationArray;
@property(assign,nonatomic)BOOL isSelected;
@end

static NSString *const systemCellIdentifier = @"systemCell";

@implementation YCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSelected = YES;
    self.constellationArray = [NSMutableArray new];
    [self.constellationArray addObjectsFromArray:array1];
    [self.constellationArray removeObjectAtIndex:0];
    self.constellationTF.delegate = self;
    self.constellationTableView.hidden = YES;
    [self.constellationTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:systemCellIdentifier];
}
#pragma mark--选择男性--
- (IBAction)selectBoyAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.isSelected) {
        [btn setBackgroundImage:[UIImage imageNamed:@"select"] forState:(UIControlStateNormal)];
        self.gender = 1;
        [self.girlBtn setBackgroundImage:[UIImage imageNamed:@"notSelect"] forState:(UIControlStateNormal)];
    }
}
#pragma mark--选择女性--
- (IBAction)selectGirlAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.isSelected) {
        [btn setBackgroundImage:[UIImage imageNamed:@"select"] forState:(UIControlStateNormal)];
        self.gender = 0;
        [self.boyBtn setBackgroundImage:[UIImage imageNamed:@"notSelect"] forState:(UIControlStateNormal)];
    }
}
#pragma mark--星座输入框代理方法--
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
    [UIView animateWithDuration:0.5 animations:^{
        self.constellationTableView.hidden = NO;
    }];
}
#pragma mark--完成--
- (IBAction)doneAction:(id)sender {
    [[AVUser currentUser] setObject:self.ageTF.text forKey:@"age"];
    [[AVUser currentUser] setObject:[NSString stringWithFormat:@"%ld",self.gender] forKey:@"gender"];
    [[AVUser currentUser] setObject:self.constellationTF.text forKey:@"constellation"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"保存成功");
        }
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--取消--
- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.constellationArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.constellationTF.text = self.constellationArray[indexPath.row];
    self.constellationTableView.hidden = YES;
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
