//
//  PlayDetailsViewControllerViewController.m
//  ShiYi
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import "PlayDetailsViewController.h"
#import "EventView.h"
#import "EventModel.h"
#import "ContentView.h"
#import "OtherEventView.h"
#import "YPlayModel.h"
#import <UMSocialControllerService.h>
#import "UMSocial.h"

@interface PlayDetailsViewController ()<UMSocialUIDelegate>

@property (nonatomic, strong)EventView *myEventView;
@property (nonatomic, strong)NSURLSessionDataTask *myTask;
@property (nonatomic, strong)EventModel *model;
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, strong)NSMutableArray *wordArray;
@property (nonatomic, strong)NSString *wordOne;
@property (nonatomic, strong)NSString *wordTwo;
@property (nonatomic, strong)UIScrollView *BGScrollView;
@property (nonatomic, strong)ContentView *contentView;
@property (nonatomic, assign)CGFloat hight;
@property (nonatomic, strong)OtherEventView *otherView;
@property (nonatomic, strong)NSMutableArray *modelArray;
//@property (nonatomic, strong)DDIndicator *loadingView;
@property (nonatomic, strong)UIView *BGView;
@property (nonatomic, assign)BOOL isOnce;
@property (nonatomic, assign)BOOL isBuild;

// 是否收藏
@property (assign,nonatomic) BOOL isCollection;
@property (strong,nonatomic) NSString *objId;

@end

@implementation PlayDetailsViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.myTask) {
        [self.myTask cancel];
        self.myTask = nil;
        NSLog(@"yes");
    } else {
        NSLog(@"no");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageArray = [NSMutableArray array];
    self.wordArray = [NSMutableArray array];
    self.modelArray = [NSMutableArray array];
    [self addSubView];
    [self setUpData];

    [self setNavigationStyle];
    self.isCollection = YES;
    self.isOnce = NO;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpData
{
    dispatch_queue_t myQueue = dispatch_queue_create("com.PlayDetails.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(myQueue, ^{
        
        NSString *urlString = [[kPlayDetailsUrlOne stringByAppendingString:self.ID] stringByAppendingString:kPlayDetailsUrlTwo];
        NSLog(@"%@",urlString);
        NSURL *newUrl = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:newUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        [request setHTTPMethod:@"GET"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        self.myTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data != nil && [data length] > 0) {
                self.BGView.hidden = NO;
                //[self.loadingView startAnimating];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                self.model = [[EventModel alloc] init];
                [self.model setValuesForKeysWithDictionary:[dic valueForKey:@"data"]];
                self.model.recommendAutomatic = [NSMutableArray arrayWithArray:[dic valueForKey:@"recommendAutomatic"]];
                self.model.content = [self removePTagString:self.model.content];
                [self getArray:[self getContectString:self.model.content]];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self changeFrame];
                    self.myTask = nil;
//                    [self.loadingView stopAnimating];
//                    self.BGView.hidden = YES;
                    self.navigationItem.title = self.model.title;
                    NSThread *aThread = [[NSThread alloc] initWithTarget:self selector:@selector(changeFrame) object:nil];
                    [aThread start];
                    aThread = nil;
                    
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.myTask = nil;
                    //[self.loadingView stopAnimating];
                    self.BGView.hidden = YES;
                [self showAlertViewWithMessage:@"你的网络状态较差,请检查网络!"];
                });
            }
            
            
        }];
        [self.myTask resume];
    });
}

- (void)addSubView
{
    self.BGScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.BGScrollView.bounces = NO;
    self.BGScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.BGScrollView];
    self.myEventView = [[EventView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 310)];
    [self.BGScrollView addSubview:self.myEventView];
    self.contentView = [[ContentView alloc] initWithFrame:CGRectMake(0, 320, kWidth, 310)];
    [self.BGScrollView addSubview:self.contentView];
    self.otherView = [[OtherEventView alloc] initWithFrame:CGRectMake(0, 650, kWidth, 270)];
    [self.BGScrollView addSubview:self.otherView];
    self.BGView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.BGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.BGView];
    
    //_loadingView = [[DDIndicator alloc] initWithFrame:CGRectMake((kScreenWidth - 40)/ 2, (self.BGView.height - 100)/ 2, 40, 40)];
    //[self.BGView addSubview:_loadingView];
//    [self.loadingView startAnimating];

    
}

- (NSString *)removePTagString:(NSString *)string
{
    string = [string  stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string  stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    int numOne = 0;
    int numTwo = 0;
    for (int i = 0; i < [string length]; i++) {
        NSRange  range = {i, 1};
        if ([[string substringWithRange:range] isEqualToString:@"<"]) {
            numOne = i;
            for (int j = i; j < [string length]; j++) {
                NSRange  otherrange = {j, 1};
                if ([[string substringWithRange:otherrange] isEqualToString:@">"]) {
                    numTwo = j;
                    NSRange newRange = {i, (j - i + 1)};
                    NSString *str = [string substringWithRange:newRange];
                    if ([str rangeOfString:@"<img src="].location != NSNotFound) {
                        NSLog(@"%@", str);
                    } else {
                        string = [string stringByReplacingOccurrencesOfString:str withString:@""];
                        i = 0;
                        break;
                    }
                }
            }
        }
    }
    string = [string  stringByReplacingOccurrencesOfString:@"alt=style=text-align:justify;/>" withString:@""];
    string = [string  stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    string = [string  stringByReplacingOccurrencesOfString:@"YHOUSE悦会客服专线：4008-215-270" withString:@""];
    string = [string  stringByReplacingOccurrencesOfString:@"如有疑问，请联系 YHOUSE 客服" withString:@""];
    string = [string  stringByReplacingOccurrencesOfString:@"客服电话：4008215270" withString:@""];
    [string  stringByReplacingOccurrencesOfString:@"YHOUSE悦会客服专线：4008-215-270" withString:@""];
    [string  stringByReplacingOccurrencesOfString:@"。电话：4008215270" withString:@""];
    return string;
}

- (void)getArray:(NSMutableArray *)array
{
    self.imageArray = [NSMutableArray array];
    self.wordArray = [NSMutableArray array];
    for (int i = 0; i < [array count]; i++) {
        if ([array[i] hasSuffix:@"jpg"] || [array[i] hasSuffix:@"png"] || [array[i] hasSuffix:@"jpg "]) {
            if ([array[i] hasSuffix:@"jpg "]) {
                array[i] = [array[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            array[i] = [array[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            array[i] = [array[i] stringByReplacingOccurrencesOfString:@" http" withString:@"http"];
            [self.imageArray addObject:array[i]];
        } else {
            [self.wordArray addObject:array[i]];
        }
    }
    self.wordOne = @"";
    self.wordTwo = @"";
    for (int i = 0; i < [self.wordArray count]; i++) {
        if (i < [self.wordArray count] / 2) {
            self.wordOne = [self.wordOne stringByAppendingString:self.wordArray[i]];
        } else {
            self.wordTwo = [self.wordTwo stringByAppendingString:self.wordArray[i]];
            
        }
    }
}

- (NSMutableArray *)getContectString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    NSMutableArray *highlightArray = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < [highlightArray count]; i++) {
        
        if (![highlightArray[i] isEqualToString:@""]) {
            
            if ([highlightArray[i] rangeOfString:@".jpg"].location !=NSNotFound) {
                NSArray *myArray2 = [highlightArray[i] componentsSeparatedByString:@".jpg"];
                highlightArray[i] = myArray2[0];
                highlightArray[i] = [highlightArray[i] stringByReplacingOccurrencesOfString:@"<img src=" withString:@""];
                highlightArray[i] = [highlightArray[i] stringByAppendingString:@".jpg"];
                highlightArray[i] = [highlightArray[i] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            }
            if ([highlightArray[i] rangeOfString:@".png"].location !=NSNotFound) {
                NSArray *myArray2 = [highlightArray[i] componentsSeparatedByString:@".png"];
                highlightArray[i] = myArray2[0];
                highlightArray[i] = [highlightArray[i] stringByReplacingOccurrencesOfString:@"<img src=" withString:@""];
                highlightArray[i] = [highlightArray[i] stringByAppendingString:@".png"];
                highlightArray[i] = [highlightArray[i] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            }
            if ([highlightArray[i] isEqualToString:@"YHOUSE悦会客服专线：4008-215-270"]) {
                [highlightArray removeObject:@"YHOUSE悦会客服专线：4008-215-270"];
            }
        } else {
            
        }
    }
    return highlightArray;
}

- (CGFloat)hightForLabelWithString:(NSString *)string
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    CGRect newFrame = [string boundingRectWithSize:CGSizeMake(340, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return newFrame.size.height;
}

- (void)actionLook:(UIButton *)button
{
    NSInteger number = button.tag % 2500;
    NSDictionary *dic = [self.model.recommendAutomatic[number] valueForKey:@"data"];
    YPlayModel *model = [[YPlayModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    PlayDetailsViewController *playVC = [[PlayDetailsViewController alloc] init];
    playVC.ID = [NSString stringWithFormat:@"%ld", model.ID];
    playVC.isWhat = self.isWhat;
    [self.navigationController pushViewController:playVC animated:YES];

}

- (void)changeFrame
{
    [self.myEventView.image sd_setImageWithURL:[NSURL URLWithString:self.model.mPicUrl] placeholderImage:nil];
    self.myEventView.titleLabel.text = self.model.title;
    self.myEventView.addtessLabel.text = [@"地址: " stringByAppendingString:self.model.address];
    self.myEventView.durationLabel.text = [@"时间: " stringByAppendingString:self.model.duration];
    self.contentView.sayLabel.text = @"-----------  正文 -----------";
    
    self.contentView.contentOneView.text = [@"    " stringByAppendingString:self.wordOne];
    CGRect newcontentOneView = self.contentView.contentOneView.frame;
    newcontentOneView.size.height = [self hightForLabelWithString:self.wordOne];
    self.contentView.contentOneView.frame = newcontentOneView;
    
    
    if ([self.imageArray count] == 0) {
        CGRect newImage = self.contentView.image.frame;
        newImage.origin.y = self.contentView.contentOneView.frame.size.height + 40;
        newImage.size = CGSizeMake(0, 0);
        self.contentView.image.frame = newImage;
    } else {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageArray[0]]]];
        CGFloat scale = 0.55;
        while (image.size.width * scale > kWidth - 10) {
            scale = scale - 0.05;
        }
        CGRect newImage = self.contentView.image.frame;
        newImage.origin.y = self.contentView.contentOneView.frame.size.height + 40;
        newImage.origin.x = (kWidth - image.size.width * scale) / 2;
        newImage.size = CGSizeMake(image.size.width * scale, image.size.height * scale);
        self.contentView.image.frame = newImage;
        [self.contentView.image sd_setImageWithURL:[NSURL URLWithString:self.imageArray[0]] placeholderImage:nil];
    }
    
    
    self.contentView.contentTwoView.text = [@"    " stringByAppendingString:self.wordTwo];
    CGRect newcontentTwoView = self.contentView.contentTwoView.frame;
    newcontentTwoView.origin = CGPointMake((kWidth - 340) / 2, self.contentView.image.frame.origin.y + self.contentView.image.frame.size.height + 40);
    newcontentTwoView.size.height = [self hightForLabelWithString:self.wordTwo];
    self.contentView.contentTwoView.frame = newcontentTwoView;
    
    self.hight = self.contentView.contentTwoView.frame.origin.y + self.contentView.frame.size.height + 350;
    
    CGRect newContentView = self.contentView.frame;
    newContentView.size.height = self.contentView.contentTwoView.frame.origin.y + self.contentView.contentTwoView.frame.size.height + 20;
    self.contentView.frame = newContentView;
    CGRect newOtherView = self.otherView.frame;
    newOtherView.origin.y = self.contentView.frame.origin.y + self.contentView.frame.size.height + 20;
    self.otherView.frame = newOtherView;
    self.hight = self.otherView.frame.origin.y + 270;
    
    if ([self.model.recommendAutomatic count] >= 3) {
        for (int i = 0; i < 3; i++) {
            YPlayModel *model = [[YPlayModel alloc] init];
            [model setValuesForKeysWithDictionary: [self.model.recommendAutomatic[i] valueForKey:@"data"]];
            UIImageView *image = (UIImageView *)[self.otherView viewWithTag:2600 + i];
            UILabel *labelOne = (UILabel *)[self.otherView viewWithTag:2700 + i];
            UILabel *labelTwo = (UILabel *)[self.otherView viewWithTag:2800 + i];
            UIButton *button = (UIButton *)[self.otherView viewWithTag:2500 + i];
            [image sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:nil];
            labelOne.text = model.title;
            labelTwo.text = model.neededCredits;
            [button addTarget:self action:@selector(actionLook:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    } else if ([self.model.recommendAutomatic count] == 2) {
        for (int i = 0; i < 2; i++) {
            YPlayModel *model = [[YPlayModel alloc] init];
            [model setValuesForKeysWithDictionary: [self.model.recommendAutomatic[i] valueForKey:@"data"]];
            UIImageView *image = (UIImageView *)[self.otherView viewWithTag:2600 + i];
            UILabel *labelOne = (UILabel *)[self.otherView viewWithTag:2700 + i];
            UILabel *labelTwo = (UILabel *)[self.otherView viewWithTag:2800 + i];
            UIButton *button = (UIButton *)[self.otherView viewWithTag:2500 + i];
            [image sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:nil];
            labelOne.text = model.title;
            labelTwo.text = model.neededCredits;
            [button addTarget:self action:@selector(actionLook:) forControlEvents:UIControlEventTouchUpInside];
        }

    } else if ([self.model.recommendAutomatic count] == 1) {
        for (int i = 0; i < 1; i++) {
            YPlayModel *model = [[YPlayModel alloc] init];
            [model setValuesForKeysWithDictionary: [self.model.recommendAutomatic[i] valueForKey:@"data"]];
            UIImageView *image = (UIImageView *)[self.otherView viewWithTag:2600 + i];
            UILabel *labelOne = (UILabel *)[self.otherView viewWithTag:2700 + i];
            UILabel *labelTwo = (UILabel *)[self.otherView viewWithTag:2800 + i];
            UIButton *button = (UIButton *)[self.otherView viewWithTag:2500 + i];
            [image sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:nil];
            labelOne.text = model.title;
            labelTwo.text = model.neededCredits;
            [button addTarget:self action:@selector(actionLook:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.BGScrollView.contentSize = CGSizeMake(0, self.hight + 80);
    
    self.BGView.hidden = YES;
    //[self.loadingView stopAnimating];
    self.isBuild = YES;
}



- (void)setNavigationStyle
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.model.title;
    
    // 分享
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(actionShareButton:)];
    
    
    // 收藏
    UIBarButtonItem *shouCangButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"favorite"] style:UIBarButtonItemStylePlain target:self action:@selector(actionCollection:)];
    
    shouCangButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    self.navigationItem.rightBarButtonItems = @[shareButton, shouCangButton];
}


- (void)actionCollection:(UIBarButtonItem *)button
{
    
    AVObject *object = [AVObject objectWithClassName:@"MyPlayCollection"];
    if (self.isCollection) {
        
        // 保存当前用户名
        [object setObject:[AVUser currentUser].username forKey:@"userName"];
        
        // 保存ID
        [object setObject:self.ID forKey:@"ID"];
        
        // 保存title
        [object setObject:self.model.title forKey:@"title"];
        
        AVQuery *query = [AVQuery queryWithClassName:@"MyPlayCollection"];
        [query whereKey:@"ID" equalTo:self.ID];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count == 0) {
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [self showAlertViewWithMessage:(@"收藏成功")];
                        [[NSUserDefaults standardUserDefaults] setObject:object.objectId forKey:self.ID];
                    }
                }];
            }else{
                [self showAlertViewWithMessage:(@"您已收藏,不可重复收藏,如果想取消收藏，请再次点击")];
            }
        }];
        self.isCollection = NO;
    }else{

        // 删除收藏的数据
        // 执行 CQL 语句实现删除一个 MyAttention 对象
        self.objId = [[NSUserDefaults standardUserDefaults] objectForKey:self.ID];
        NSLog(@"%@",self.objId);
        [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"delete from MyPlayCollection where objectId='%@'",self.objId] callback:^(AVCloudQueryResult *result, NSError *error) {
            [self showAlertViewWithMessage:(@"取消收藏成功")];
        }];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.ID];
        self.isCollection = YES;
    }
}

- (BOOL)isHave
{
    AVUser *currentUser = [AVUser currentUser];
    if (self.isWhat == YES) {
        NSArray *ID = [[currentUser objectForKey:@"play"] valueForKey:@"ID"];
        for (int i = 0; i < [ID count]; i++) {
            if (self.model.ID == ID[i]) {
                return YES;
            }
        }
        return NO;

    } else {
        NSArray *ID = [[currentUser objectForKey:@"life"] valueForKey:@"ID"];
        for (int i = 0; i < [ID count]; i++) {
            if (self.model.ID == ID[i]) {
                return YES;
            }
        }
        return NO;

    }
}



- (void)actionUserLogin:(NSNotification *)notification
{

    
//    Reachability *conn = [Reachability reachabilityForInternetConnection];
//    if ([conn currentReachabilityStatus] != NotReachable) {
//        AVUser *currentUser = [AVUser currentUser];
//        if (currentUser != nil) {
//            if (self.isWhat == YES) {
//                if ([self isHave]) {
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已经收藏过了" preferredStyle:UIAlertControllerStyleAlert];
//                    [self presentViewController:alertController animated:YES completion:nil];
//                    [self performSelector:@selector(dismiss:) withObject:alertController afterDelay:0.5];
//                } else {
//                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.model.ID, @"ID", self.model.title, @"title", nil];
//                    [currentUser addObject:dic forKey:@"play"];
//                    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                        [currentUser saveInBackground];
//                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
//                        [self presentViewController:alertController animated:YES completion:nil];
//                        [self performSelector:@selector(dismiss:) withObject:alertController afterDelay:0.5];
//                    }];
//                }
//            } else {
//                if ([self isHave]) {
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已经收藏过了" preferredStyle:UIAlertControllerStyleAlert];
//                    [self presentViewController:alertController animated:YES completion:nil];
//                    [self performSelector:@selector(dismiss:) withObject:alertController afterDelay:0.5];
//                } else {
//                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.model.ID, @"ID", self.model.title, @"title", nil];
//                    [currentUser addObject:dic forKey:@"life"];
//                    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                        [currentUser saveInBackground];
//                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
//                        [self presentViewController:alertController animated:YES completion:nil];
//                        [self performSelector:@selector(dismiss:) withObject:alertController afterDelay:0.5];
//                    }];
//                }
//            }
//            
//            
//        } else {
//            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
//            UIViewController *loginVC = [storyBoard instantiateInitialViewController];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionUserLogin:) name:@"USERISLOGIN" object:nil];
//            [self presentViewController:loginVC animated:YES completion:nil];
//        }
//        
//    } else {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏失败 请您检查是否为网络原因" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *say = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:say];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//
}

- (void)dismiss:(UIAlertController *)alert
{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionShareButton:(UIBarButtonItem *)button
{
    // 分享字符串
    NSString *shareString = [NSString stringWithFormat:@"【 %@ 】%@ 简单的生活，纷繁的世界 #约起来#带你到别人的世界走走", self.model.title, self.model.openUrl];
    // 分享图片
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.model.mPicUrl];
    // 跳转分享界面
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"578c9832e0f55a30cb003483" shareText:shareString shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms,nil] delegate:nil];
    
}

//- (void)networkStateChange
//{
//    Reachability *conn = [Reachability reachabilityForInternetConnection];
//    if ([conn currentReachabilityStatus] != NotReachable) {
//        if (self.isBuild == YES) {
//            
//        } else {
//            [self setUpData];
//        }
//    } else {
//        
//    }
//}


- (void)actionLeftButton
{
    if (self.isOnce == NO) {
        [self.navigationController popViewControllerAnimated:YES];
        self.isOnce = YES;
    }
}


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
