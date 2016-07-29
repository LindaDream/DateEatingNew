//
//  YDisclaimerViewController.m
//  DateEating
//
//  Created by lanou3g on 16/7/29.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YDisclaimerViewController.h"

@interface YDisclaimerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;

@end

@implementation YDisclaimerViewController

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *disclaimer = @"      约起来（以下简称“本产品”）是一个集聊天、约会、聚餐、分享于一体的软件。本软件提供的所有店铺资料和客户信息均为软件作者提供及客户发布，不得用于任何商业用途。\n      任何单位或个人认为通过本产品提供的服务可能涉嫌侵犯其合法权益，应该及时向约起来书面反馈，并提供身份证明、权属证明及详细侵权情况证明，约起来在收到上述法律文件后，将会尽快移除被控侵权信息。\n      本产品中的绝大部分信息来源于互联网，如果某些信息作者对使用本产品提供的服务有任何异议，都欢迎与我们联系沟通。约起来将在规定时间内给予删除等相关处理。";
    self.disclaimerLabel.height = [[self class] textHeightWithTitle:disclaimer];
    self.disclaimerLabel.font = [UIFont systemFontOfSize:15.0];
    self.disclaimerLabel.text = disclaimer;
    
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
