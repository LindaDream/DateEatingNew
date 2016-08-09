//
//  YFunnyDetailViewController.m
//  DateEating
//
//  Created by user on 16/7/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YFunnyDetailViewController.h"
#import "YFunnyModel.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "YContent.h"
#import "YContentTableViewCell.h"
#import "YFaceView.h"

#define kContentLabelWith kWidth - 28

@interface YFunnyDetailViewController ()<SDCycleScrollViewDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,YFaceViewDelegate,YContentTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *publishName;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *reportBtn;

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@property (weak, nonatomic) IBOutlet UIButton *sendContentBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScorllView;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *pinglunLabel;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *editContentView;


@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
// 该页发布者的唯一标识
@property (strong,nonatomic) NSString *ownerId;

// 存放评论的数组
@property (strong,nonatomic) NSArray *contentArr;
// 标记表情键盘是否存在
@property (assign,nonatomic) BOOL isEmoji;
@end


// 重用标识符
static NSString *const contentCellId = @"contentCellId";


@implementation YFunnyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置view
    [self setTheViewFrame];
    [self setTheView];
    
    // 去掉cell的系统分割线
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 初始化ownerId
    self.ownerId = [NSString stringWithFormat:@"%@%@",_funny.publishName,_funny.publishTime];

    
    
    // 注册cell
    [self.contentTableView registerNib:[UINib nibWithNibName:@"YContentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:contentCellId];

    // 注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark--点击输入框代理方法--
- (void)textFieldDidBeginEditing:(UITextField *)textField{
}

// 详情页举报按钮
- (IBAction)reportAction:(id)sender {
    [self showAlertViewWithMessage:@"举报成功，我们将尽快处理！"];
}
// 评论举报按钮
- (void)showReport{
    [self showAlertViewWithMessage:@"举报成功，我们将尽快处理！"];
}


#pragma mark--键盘通知方法--
- (void)keyBoardShow:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    NSValue *value = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyBoardSize = [value CGRectValue].size;
    CGFloat h = keyBoardSize.height;
    CGRect contentViewRect = self.contentView.frame;
    CGRect editContentViewRect = self.editContentView.frame;
    contentViewRect.origin.y = -h;
    editContentViewRect.origin.y = self.view.height - 50 - h;
    //取出动画时长
    NSTimeInterval duration = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //使用动画更改self.view.frame
    [UIView animateWithDuration:duration animations:^{
        //这里填入一些view的最终状态属性设置，即会自动产生过渡动画
        self.contentView.frame = contentViewRect;
        self.editContentView.frame = editContentViewRect;
        self.editContentView.alpha = 1;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // 取消第一响应者（回收键盘）
    [self backKeyBoard];
    return YES;
    
}

- (void)backKeyBoard{

    [self.contentTextField resignFirstResponder];
    CGFloat h = [[self class] textHeightFromModel:_funny];
    self.contentView.frame = CGRectMake(0, 0, kWidth, 643 + h);
    self.editContentView.frame = CGRectMake(0, self.contentScorllView.height, kWidth, 45);
    _isEmoji = NO;
    self.contentTextField.inputView = nil;
    
}


// 滑动tableView实现键盘回收
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.contentScorllView ||scrollView == self.contentTableView) {
        [self backKeyBoard];
    }
}


// 设置view位置
- (void)setTheViewFrame{
    CGFloat h = [[self class] textHeightFromModel:_funny];
    self.contentScorllView.frame = CGRectMake(0, 0, kWidth, kHeight - 45);
    self.contentView.frame = CGRectMake(0, 0, kWidth, 643 + h);
    self.contentScorllView.contentSize = CGSizeMake(kWidth, 643 + h);
    self.contentScorllView.delegate = self;
    self.avatarImageView.frame = CGRectMake(14, 16, 40, 40);
    self.publishName.frame = CGRectMake(77, 25, 300, 21);
    self.reportBtn.frame = CGRectMake(kWidth - 10 - 30, 25, 30, 30);
    self.contentLabel.frame = CGRectMake(14, 64, kContentLabelWith, h);
    self.contentLabel.numberOfLines = 0;
    
    self.editContentView.frame = CGRectMake(0, self.contentScorllView.height, kWidth, 45);
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(8, 5, 35, 35)];
    [button setImage:[UIImage imageNamed:@"emoji"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(emojiBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.editContentView addSubview:button];
    self.sendContentBtn.frame = CGRectMake(kWidth - 56 - 8, 5, 56, 35);
    self.contentTextField.frame = CGRectMake(50, 5, kWidth - 123, 35);
    self.contentTextField.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.contentTextField.delegate = self;
    
    
    if (_funny.imgArr.count == 0) {
        
        self.scrollView.hidden = YES;
        self.scrollView.height = 0;
        self.pinglunLabel.frame = CGRectMake(14 ,CGRectGetMaxY(self.contentLabel.frame) + 10, self.pinglunLabel.width, self.pinglunLabel.height);
        self.contentTableView.frame = CGRectMake(0 ,CGRectGetMaxY(self.pinglunLabel.frame) + 10, kWidth, self.contentTableView.height);
    }else {
        
        self.scrollView.frame = CGRectMake(14 ,CGRectGetMaxY(self.contentLabel.frame) + 10, kContentLabelWith, self.scrollView.height);
        self.pinglunLabel.frame = CGRectMake(14 ,CGRectGetMaxY(self.scrollView.frame) + 10, self.pinglunLabel.width, self.pinglunLabel.height);
        self.contentTableView.frame = CGRectMake(0 ,CGRectGetMaxY(self.pinglunLabel.frame) + 10, kWidth, self.contentTableView.height);
    }
    
}

#pragma mark -- 弹出表情键盘 --
- (void)emojiBtnAction {
    if (_isEmoji == NO) {
        _isEmoji = YES;
        [self.contentTextField becomeFirstResponder];
        YFaceView *faceView = [[YFaceView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];
        faceView.delegate = self;
        self.contentTextField.inputView = faceView;
        [self.contentTextField reloadInputViews];
    } else {
        _isEmoji = NO;
        self.contentTextField.inputView = nil;
        [self.contentTextField reloadInputViews];
    }
}
#pragma mark -- 表情键盘的回调 --
- (void)changeKeyBoardBtnDidSelect {
    _isEmoji = NO;
    self.contentTextField.inputView=nil;
    [self.contentTextField reloadInputViews];
}
- (void)collectionViewCellDidSelected:(NSString *)face {
    self.contentTextField.text = [NSString stringWithFormat:@"%@%@",self.contentTextField.text,face];
}
- (void)deleteBtnDidSelected {
    [self.contentTextField deleteBackward];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.contentTextField];
}

// 设置view
- (void)setTheView{

    self.publishName.text = _funny.publishName;
    self.contentLabel.text = _funny.publishContent;
    [self.publishName sizeToFit];
    
    if (_funny.imgArr.count == 0) {
        
        self.scrollView.hidden = YES;
        self.scrollView.height = 0;
        
        
    }else if (_funny.imgArr.count == 1){
        
        self.scrollView.hidden = NO;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:_funny.imgArr[0]] placeholderImage:[UIImage imageNamed:@"zhanwei.jpg"]];
        [self.scrollView addSubview:imgView];
        
    }else{
        self.scrollView.hidden = NO;
        
        // 用网络图片实现
        NSArray *imageURLString = _funny.imgArr; // 解析数据时得到的轮播图数组
        
        // 创建代标题的轮播图
        //_cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) imageURLStringsGroup:nil];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) delegate:nil placeholderImage:[UIImage imageNamed:@"zhanwei.jpg"]];
        // 设置代理
        _cycleScrollView.delegate = self;
        // 设置小圆点的位置
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        // 设置小圆点动画效果
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        // 小圆点颜色
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.currentPageDotColor = [UIColor greenColor];
        // 把图片数组赋值给每个图片
        _cycleScrollView.imageURLStringsGroup = imageURLString;
        
        // 几秒钟换图片
        _cycleScrollView.autoScrollTimeInterval = 3;
        if (_funny.imgArr.count == 1) {
            _cycleScrollView.autoScroll = NO;
        }else{
            _cycleScrollView.autoScroll = YES;
        }
        [self.scrollView addSubview:_cycleScrollView];
    }
    
    [YContent getContentAvatarWithUserName:self.publishName.text SuccessRequest:^(id dict) {
        if (dict != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:dict]placeholderImage:[UIImage imageNamed:@"head_img"]];
            });
        }
    } failurRequest:^(NSError *error) {
        NSLog(@"获取头像失败");
    }];

    
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self getAllContent];
    
}



#pragma mark--获取评论--
- (void)getAllContent{

    [YContent parsesContentWithOwnerId:self.ownerId SuccessRequest:^(id dict) {
        if (dict != nil) {
            self.contentArr = dict;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.contentTableView reloadData];
            });
        }
    } failurRequest:^(NSError *error) {
        [self showAlertViewWithMessage:@"获取评论失败"];
    }];
    
}




#pragma mark--发送评论--
- (IBAction)sendContentAction:(id)sender {
    
    if (self.contentTextField.text.length == 0) {
        
        [self backKeyBoard];
        [self showAlertViewWithMessage:@"请填写评论，再发送"];
        
    }else{
        
        [self backKeyBoard];
        
        // 显示菊花
        [SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeClear)];
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        
        appDelegate.window.userInteractionEnabled = NO;
        
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
        NSString *createTime = [NSString stringWithFormat:@"%ld",(NSInteger)time];
        NSString *fromName = [AVUser currentUser].username;
        NSString *ownerId = [NSString stringWithFormat:@"%@%@",_funny.publishName,_funny.publishTime];
        AVObject *contentObject = [[AVObject alloc] initWithClassName:@"ContentObject"];
        [contentObject setObject:ownerId forKey:@"ownerId"];
        [contentObject setObject:fromName forKey:@"fromName"];
        [contentObject setObject:_funny.publishName forKey:@"toName"];
        [contentObject setObject:self.contentTextField.text forKey:@"contents"];
        [contentObject setObject:createTime forKey:@"contentTime"];
        [contentObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 隐藏菊花
                [SVProgressHUD dismiss];
                
                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                appDelegate.window.userInteractionEnabled = YES;
                
                if (succeeded) {
                    [self showAlertViewWithMessage:@"评论成功"];
                    self.contentTextField.text = nil;
                    [self getAllContent];
                    
                }else{
                    [self showAlertViewWithMessage:@"评论失败，请稍后重试"];
                    NSLog(@"%ld",error.code);
                }
            });
        }];
        
    }
    
}


#pragma mark--UITableViewDataSource--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.contentArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YContent *content = self.contentArr[indexPath.row];
    YContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCellId forIndexPath:indexPath];
    cell.content = content;
    cell.delegate = self;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YContent *content = self.contentArr[indexPath.row];
    return [YContentTableViewCell cellHeight:content];
    
}



// 计算文本高度
+ (CGFloat)textHeightFromModel:(YFunnyModel *)funny{
    
    CGRect rect = [funny.publishContent boundingRectWithSize:CGSizeMake(kContentLabelWith, 200) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    return rect.size.height;
    
}






// 弹框
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
