//
//  ZZNAlterView.m
//  DeTuZZN
//
//  Created by WZ on 15/9/17.
//  Copyright © 2015年 DETU. All rights reserved.
//

#import "ZZNAlterView.h"
#import "ZZNUIManager.h"
// 设置两个警告框的长和高
#define kAlertTwoHeigth 150.0f
#define kTwoButtonHeigth (Alertheigth/2)


#define Alertwidth 310.0f
#define Alertheigth 200.0f
#define XWtitlegap 15.0f
#define XWtitleofheigth 25.0f
#define XWSinglebuttonWidth 160.0f
//        单个按钮时的宽度
#define XWdoublebuttonWidth 80.0f
//        双个按钮的宽度
#define ZZNbuttonHeigth (Alertheigth/4)
//        按钮的高度
#define XWbuttonbttomgap 10.0f
//        设置按钮距离底部的边距



#define kScoreBoardHeigh 110
#define kScoreBoardWidh (ZZN_UI_SCREEN_W - 30)


#define kNewGameAlertWidth (ZZN_UI_SCREEN_W - 80)
#define kNewGameAlertHeight (kNewGameAlertWidth-20)
#define kNewGamebuttonHeigth (kNewGameAlertHeight/2/3)

@interface ZZNAlterView ()
{
    BOOL _leftLeave;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *alertButton;
@property (nonatomic, strong) UIButton *leftbtn;
@property (nonatomic, strong) UIButton *rightbtn;
@property (nonatomic, strong) UIButton *thirdButton;
@property (nonatomic, strong) UIView *backimageView;
@property (nonatomic, assign) CGFloat alterHeight;

@property (nonatomic, assign)CGRect cellFrame;

@end

@implementation ZZNAlterView



+ (CGFloat)alertWidth
{
    return Alertwidth;
}

+ (CGFloat)alertHeight
{
    return Alertheigth;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(ZZNAlterView*)showmessage:(NSString *)message subtitle:(NSString *)subtitle cancelbutton:(NSString *)cancle
{
    ZZNAlterView *alert = [[ZZNAlterView alloc] initWithTitle:message contentText:subtitle leftButtonTitle:nil rightButtonTitle:cancle leftBlock:nil rightBlock:nil];
    [alert show];
    alert.rightBlock = ^() {
    };
    alert.dismissBlock = ^() {
    };
    return alert;
}

//Edit alert
- (id)initWithleftBlock:(void(^)())leftBlock
             rightBlock:(void(^)())rightBlock thirdBlock:(void(^)())thirdBlock;

{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        CGFloat btnHeight = kNewGameAlertHeight/5;
        CGRect leftbtnFrame;
        CGRect rightbtnFrame;
        CGRect thirdButtonBtnFrame;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kNewGameAlertWidth, btnHeight)];
        imageView.image = [UIImage imageNamed:@"ico_edit_score"];
        [self addSubview:imageView];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, btnHeight, kNewGameAlertWidth, 1.5)];
        line1.backgroundColor = ZZN_UI_COLOR_BLACK;
        [self addSubview:line1];
        
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, btnHeight, kNewGameAlertWidth, btnHeight)];
        imageView2.image = [UIImage imageNamed:@"ico_which_roll"];
        [self addSubview:imageView2];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, btnHeight*2, kNewGameAlertWidth, 1.5)];
        line2.backgroundColor = ZZN_UI_COLOR_BLACK;
        [self addSubview:line2];
        
        
        
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, btnHeight*3, kNewGameAlertWidth, 1)];
        line3.backgroundColor = ZZN_UI_COLOR_BLACK;
        [self addSubview:line3];
        
        UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, btnHeight*4, kNewGameAlertWidth, 1)];
        line4.backgroundColor = ZZN_UI_COLOR_BLACK;
        [self addSubview:line4];
        
        leftbtnFrame = CGRectMake(0, btnHeight*2, kNewGameAlertWidth, btnHeight);
        rightbtnFrame = CGRectMake(0, btnHeight*3 , kNewGameAlertWidth , btnHeight);
        thirdButtonBtnFrame =  CGRectMake(0, btnHeight*4 , kNewGameAlertWidth , btnHeight);
        self.leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];

        self.leftbtn.frame = leftbtnFrame;
        self.rightbtn.frame = rightbtnFrame;
        self.thirdButton.frame = thirdButtonBtnFrame;
        
        

        [self.leftbtn setBackgroundImage:[UIImage imageNamed:@"ico_first"] forState:UIControlStateNormal];
        [self.rightbtn setBackgroundImage:[UIImage imageNamed:@"ico_second"] forState:UIControlStateNormal];
        [self.thirdButton setBackgroundImage:[UIImage imageNamed:@"ico_edit_score_cancel"] forState:UIControlStateNormal];
        [self.leftbtn addTarget:self action:@selector(leftbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightbtn addTarget:self action:@selector(rightbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.thirdButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftbtn];
        [self addSubview:self.rightbtn];
        [self addSubview:self.thirdButton];
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        
        self.leftBlock = leftBlock;
        self.rightBlock = rightBlock;
        self.thirdBlock = thirdBlock;
        
    }
    return self;
}

//两个
- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
          leftBlock:(void(^)())leftBlock
         rightBlock:(void(^)())rightBlock

{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect leftbtnFrame;
        CGRect rightbtnFrame;
        
      
        leftbtnFrame = CGRectMake(0, 0, Alertwidth, kTwoButtonHeigth);
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, kTwoButtonHeigth, Alertwidth, 1)];
        line2.backgroundColor = ZZN_UI_COLOR_BLACK;
        [self addSubview:line2];
        
        rightbtnFrame = CGRectMake(0, kTwoButtonHeigth , Alertwidth , kTwoButtonHeigth);
        self.leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftbtn.frame = leftbtnFrame;
        self.rightbtn.frame = rightbtnFrame;
        
        

        [self.rightbtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftbtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftbtn.titleLabel.font = self.rightbtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        [self.leftbtn setTitleColor:ZZN_UI_COLOR_BLACK forState:UIControlStateNormal];
        [self.rightbtn setTitleColor:ZZN_UI_COLOR_BLACK forState:UIControlStateNormal];
        [self.leftbtn addTarget:self action:@selector(leftbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightbtn addTarget:self action:@selector(rightbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftbtn];
        [self addSubview:self.rightbtn];
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        xButton.frame = CGRectMake(Alertwidth - 25, 0, 25, 25);
        [self addSubview:xButton];
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        
        self.leftBlock = leftBlock;
        self.rightBlock = rightBlock;
        
        
    }
    return self;
}

//TODO: 4个按钮
- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
  thirdButtonTittle:(NSString *)thirdTittle alertBlock:(void(^)())alertBlock leftBlock:(void(^)())leftBlock rightBlock:(void(^)())rightBlock thirdBlock:(void(^)())thirdBlock

{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect alertbtnFrame;
        CGRect leftbtnFrame;
        CGRect rightbtnFrame;
        CGRect thirdbtnFrame;
        
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, ZZNbuttonHeigth, Alertwidth, 1)];
        line1.backgroundColor = [UIColor blackColor];
        [self addSubview:line1];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, ZZNbuttonHeigth*2, Alertwidth, 1)];
        line2.backgroundColor = [UIColor blackColor];
        [self addSubview:line2];
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, ZZNbuttonHeigth*3, Alertwidth, 1)];
        line3.backgroundColor = [UIColor blackColor];
        [self addSubview:line3];
        
        
        if (!leftTitle) {
            rightbtnFrame = CGRectMake(0, 75, Alertwidth, ZZNbuttonHeigth);
            self.rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightbtn.frame = rightbtnFrame;
            
        }else {
            self.alterHeight =  Alertheigth + ZZNbuttonHeigth*2;
            
            alertbtnFrame = CGRectMake(0, 0, Alertwidth, ZZNbuttonHeigth);
            leftbtnFrame = CGRectMake(0, ZZNbuttonHeigth, Alertwidth, ZZNbuttonHeigth);
            rightbtnFrame = CGRectMake(0, ZZNbuttonHeigth*2, Alertwidth , ZZNbuttonHeigth);
            thirdbtnFrame = CGRectMake(0, ZZNbuttonHeigth*3, Alertwidth, ZZNbuttonHeigth);
            self.alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.alertButton.frame =  alertbtnFrame;
            self.leftbtn.frame = leftbtnFrame;
            self.rightbtn.frame = rightbtnFrame;
            self.thirdButton.frame = thirdbtnFrame;
        }
        
       
//        [self.alertButton setTitle:title forState:UIControlStateNormal];
        //[self.rightbtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftbtn setTitle:leftTitle forState:UIControlStateNormal];
//        [self.thirdButton setTitle:thirdTittle forState:UIControlStateNormal];
        //self.alertButton.titleLabel.font = self.leftbtn.titleLabel.font = self.rightbtn.titleLabel.font = self.thirdButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//        [self.alertButton setTitleColor:ZZN_UI_COLOR_BLACK forState:UIControlStateNormal];
        [self.leftbtn setTitleColor:ZZN_UI_COLOR_BLACK forState:UIControlStateNormal];
        [self.rightbtn setTitleColor:ZZN_UI_COLOR_BLACK forState:UIControlStateNormal];
//        [self.thirdButton setTitleColor:ZZN_UI_COLOR_BLACK forState:UIControlStateNormal];
        [self.leftbtn setImage:[UIImage imageNamed:@"ico_take_a_photo_checked"] forState:UIControlStateNormal];
        [self.rightbtn setImage:[UIImage imageNamed:@"ico_newgame_checked"] forState:UIControlStateNormal];
        [self.alertButton setImage:[UIImage imageNamed:@"ico_save_checked"] forState:UIControlStateNormal];
        [self.thirdButton setImage:[UIImage imageNamed:@"ico_cancel_checked"] forState:UIControlStateNormal];
        self.alertButton.titleEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        self.leftbtn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        self.rightbtn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        self.thirdButton.titleEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        
        [self.alertButton addTarget:self action:@selector(alertbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.leftbtn addTarget:self action:@selector(leftbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightbtn addTarget:self action:@selector(rightbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.thirdButton addTarget:self action:@selector(setThirdBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.alertButton];
        [self addSubview:self.leftbtn];
        [self addSubview:self.rightbtn];
        [self addSubview:self.thirdButton];

        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
      
        xButton.frame = CGRectMake(Alertwidth - 25, 0, 25, 25);
        [self addSubview:xButton];
        //        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        self.alertBlock = alertBlock;
        self.leftBlock = leftBlock;
        self.rightBlock = rightBlock;
        self.thirdBlock = thirdBlock;
        
        
    }
    return self;
}

//TODO:三个按钮
- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
  thirdButtonTittle:(NSString *)thirdTittle
          leftBlock:(void(^)())leftBlock
         rightBlock:(void(^)())rightBlock
         thirdBlock:(void(^)())thirdBlock

{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect alertbtnFrame;
        CGRect leftbtnFrame;
        CGRect rightbtnFrame;
        CGRect thirdbtnFrame;
        
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, kNewGameAlertHeight/2, kNewGameAlertWidth, 1)];
        line1.backgroundColor = [UIColor blackColor];
        [self addSubview:line1];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, kNewGameAlertHeight/2+kNewGamebuttonHeigth, kNewGameAlertWidth, 1)];
        line2.backgroundColor = [UIColor blackColor];
        [self addSubview:line2];
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, kNewGameAlertHeight/2+kNewGamebuttonHeigth*2, kNewGameAlertWidth, 1)];
        line3.backgroundColor = [UIColor blackColor];
        [self addSubview:line3];
        
    

        self.alterHeight =  kNewGameAlertHeight;
        
        alertbtnFrame = CGRectMake(0, 0, kNewGameAlertWidth, kNewGameAlertHeight/2);
        leftbtnFrame = CGRectMake(0, kNewGameAlertHeight/2, kNewGameAlertWidth, kNewGamebuttonHeigth);
        rightbtnFrame = CGRectMake(0, kNewGameAlertHeight/2 + kNewGamebuttonHeigth, kNewGameAlertWidth , kNewGamebuttonHeigth);
        thirdbtnFrame = CGRectMake(0, kNewGameAlertHeight/2 + kNewGamebuttonHeigth*2, kNewGameAlertWidth, kNewGamebuttonHeigth);
        self.alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.alertButton.frame =  alertbtnFrame;
        self.leftbtn.frame = leftbtnFrame;
        self.rightbtn.frame = rightbtnFrame;
        self.thirdButton.frame = thirdbtnFrame;
 
        
        [self.leftbtn setImage:[UIImage imageNamed:@"ico_clear_scores"] forState:UIControlStateNormal];
        [self.rightbtn setImage:[UIImage imageNamed:@"ico_clear_everything"] forState:UIControlStateNormal];
        [self.alertButton setImage:[UIImage imageNamed:@"ico_newgame_msg1"] forState:UIControlStateNormal];

        [self.thirdButton setBackgroundImage:[UIImage imageNamed:@"ico_cancel_newgame"] forState:UIControlStateNormal];
        
       
        [self.leftbtn addTarget:self action:@selector(leftbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightbtn addTarget:self action:@selector(rightbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.thirdButton addTarget:self action:@selector(setThirdBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.alertButton];
        [self addSubview:self.leftbtn];
        [self addSubview:self.rightbtn];
        [self addSubview:self.thirdButton];
        
    
        //        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
      
        self.leftBlock = leftBlock;
        self.rightBlock = rightBlock;
        self.thirdBlock = thirdBlock;
        
        
    }
    return self;
}


#pragma mark － 按钮
- (id)initWithCellFrame:(CGRect)frame alertBlock:(void(^)())alertBlock{

    if (self) {
        [super self];
        UIImageView *backimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScoreBoardWidh, kScoreBoardHeigh)];
        backimageView.contentMode = UIViewContentModeScaleToFill;
        backimageView.image = [UIImage imageNamed:@"ico_input_score_bg"];
        [self addSubview:backimageView];
        
        UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 0, 15, 110)];
        arrowView.contentMode = UIViewContentModeScaleToFill;
        arrowView.image = [UIImage imageNamed:@"ico_input_score_bg_p"];
        [backimageView addSubview:arrowView];
        self.alertBlock = alertBlock;

    }
    return self;
}
- (void)alertbtnclicked:(id)sender
{
    if (self) {
        self.alertBlock();
    }
    [self dismissAlert];
}
- (void)leftbtnclicked:(id)sender
{
    
    if (self.leftBlock) {
        self.leftBlock();
    }
    [self dismissAlert];
}

- (void)setThirdBtnClicked:(id)sender
{
    
    if (self.thirdBlock) {
        self.thirdBlock();
    }
    [self dismissAlert];
}
- (void)rightbtnclicked:(id)sender
{
    
    if (self.rightBlock) {
        self.rightBlock();
    }
    [self dismissAlert];
}
- (void)show
{   //获取第一响应视图视图
#if 0
    UIViewController *topVC = [self appRootViewController];
    self.alterHeight = kAlertTwoHeigth;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAlert)];
    topVC.view.userInteractionEnabled = YES;
    [topVC.view addGestureRecognizer:tap];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - Alertwidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - Alertheigth) * 0.5, Alertwidth, self.alterHeight);
    self.opaque = YES;
    self.alpha=0;
    NSLog(@"%@",NSStringFromCGRect(self.frame));
    [topVC.view addSubview:self];
#endif
    [self showThree];
}

- (void)showThree {
    //获取第一响应视图视图
    UIViewController *topVC = [self appRootViewController];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAlert)];
    topVC.view.userInteractionEnabled = YES;
//    [topVC.view addGestureRecognizer:tap];
    topVC.view.opaque = YES;
    self.alterHeight = Alertheigth ;
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - Alertwidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - Alertheigth) * 0.5, Alertwidth, self.alterHeight);
    self.opaque = YES;
    [topVC.view addSubview:self];
}

- (void)showNewGame {
    //获取第一响应视图视图
    UIViewController *topVC = [self appRootViewController];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAlert)];
    topVC.view.userInteractionEnabled = YES;
//    [topVC.view addGestureRecognizer:tap];
    topVC.view.opaque = YES;
    self.alterHeight = kNewGameAlertHeight ;
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kNewGameAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kNewGameAlertWidth) * 0.5, kNewGameAlertWidth, self.alterHeight);
    self.opaque = YES;
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [topVC.view addSubview:self];}

- (void)showButton {

    
    //获取第一响应视图视图
    UIViewController *topVC = [self appRootViewController];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAlert)];
    topVC.view.userInteractionEnabled = YES;
    [topVC.view addGestureRecognizer:tap];
//    self.frame = CGRectMake(20, self.cellFrame.origin.x+self.cellFrame.size.width/2, kScoreBoardWidh, kScoreBoardHeigh);
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - Alertwidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - Alertheigth) * 0.5, Alertwidth, self.alterHeight);
    NSLog(@"%@",NSStringFromCGRect(self.frame));
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview2];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview2
{
    [self.backimageView removeFromSuperview];
    self.backimageView = nil;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        __strong typeof(weakSelf)self = weakSelf;
        self.alpha=0;
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf)self = weakSelf;

        [self removeFromSuperview];
       
    }];
}
//添加新视图时调用（在一个子视图将要被添加到另一个视图的时候发送此消息）
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    //     获取根控制器
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backimageView) {
        self.backimageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backimageView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAlert)];
        [self.backimageView addGestureRecognizer:tap];
        self.backimageView.alpha = 0.2f;
        self.backimageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    //    加载背景背景图,防止重复点击
    self.backimageView.opaque = YES;
    [topVC.view addSubview:self.backimageView];
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha=1;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}


@end
