//
//  YViewController.m
//  DateEating
//
//  Created by user on 16/8/2.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YBigImgViewController.h"

@interface YBigImgViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bigImgView;

@end

@implementation YBigImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.bigImgView.image = _img;
    CGFloat imgWidth = _img.size.width;
    CGFloat imgHeight = _img.size.height;
    imgHeight = imgHeight * kWidth / imgWidth;
    self.bigImgView.frame = CGRectMake(0, (kHeight - imgHeight) / 2, kWidth, imgHeight);
//    if (imgWidth >= imgHeight) {
//        imgHeight = imgHeight * kWidth / imgWidth;
//        self.bigImgView.frame = CGRectMake(0, (kHeight - imgHeight) / 2, kWidth, imgHeight);
//    }else{
//        NSLog(@"kHeight = %lf,kWidth = %lf",kHeight,kWidth);
//        imgWidth = imgWidth * kHeight / imgHeight;
//        self.bigImgView.frame = CGRectMake((kWidth - imgWidth) / 2, 0, imgWidth, kHeight);
//    }
    //self.bigImgView.center = self.view.center;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
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
