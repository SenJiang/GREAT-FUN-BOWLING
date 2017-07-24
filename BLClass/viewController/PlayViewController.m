//
//  PlayViewController.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/2.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "PlayViewController.h"
#import "ScoreboardViewController.h"
#import "Masonry.h"



@interface PlayViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation PlayViewController
-(BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    __weak typeof(self) weak = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weak) self = weak;
        [self refreshConstrat];
    }];
    
}
- (void)initUI{
    
    //返回
    UIButton *back_button = [UIButton new];
    [back_button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back_button];
    [back_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];

    
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    UIButton *play_button = [UIButton new];
    [play_button setImage:[UIImage imageNamed:@"ico_play_n"] forState:UIControlStateNormal];
    [play_button setImage:[UIImage imageNamed:@"ico_play_p"] forState:UIControlStateHighlighted];
    [play_button addTarget:self action:@selector(presentScoreboardVC) forControlEvents:UIControlEventTouchUpInside];
    play_button.layer.cornerRadius = 10;
    play_button.layer.masksToBounds = YES;
    [self.view addSubview:play_button];
    
    
    [play_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
        make.height.equalTo(@75);
        make.width.equalTo(@250);
    }];
    [self refreshConstrat];
}
- (void)refreshConstrat
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //竖屏
        self.imageView.image = [UIImage imageNamed:@"login_bg"];
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //横屏
        self.imageView.image = [UIImage imageNamed:@"login_bgh"];
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
}

- (void)presentScoreboardVC
{
    ScoreboardViewController *ScoreboardVC = [ScoreboardViewController new];
    
    [self.navigationController pushViewController:ScoreboardVC animated:YES];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
