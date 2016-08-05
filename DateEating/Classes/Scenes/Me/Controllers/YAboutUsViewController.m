//
//  YAboutUsViewController.m
//  DateEating
//
//  Created by user on 16/7/29.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YAboutUsViewController.h"

@interface YAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutUsLabel;

@end

@implementation YAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    NSString *aboutUs = @"      我们是免费的( ⊙ o ⊙ )啊！\n      最实用的吃货导游, 最有趣的美食派对, 最美好的约会体验.\n      为您提供各种美食推荐, 活动信息, 聊天聚会, 给您提供一种不一样的交友体验.\n      各种美食图片, 详情信息以最直观的方式向您展示。\n      为吃货交友而生。";
    self.aboutUsLabel.text = aboutUs;
    self.aboutUsLabel.height = [[self class] textHeightWithTitle:aboutUs];
    // 设置导航栏左边的按钮
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backBtn.frame = CGRectMake(10, 10, 50, 40);
    [backBtn setTitle:@"<返回" forState:(UIControlStateNormal)];
    [backBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(tagClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
- (void)tagClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 计算文本高度
+ (CGFloat)textHeightWithTitle:(NSString *)title{
    
    CGRect rect = [title boundingRectWithSize:CGSizeMake( kWidth - 40, 200) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    return rect.size.height;
    
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
