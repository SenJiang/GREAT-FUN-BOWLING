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

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (void)initUI{
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"login_bg.jpg"];
    [self.view addSubview:imageView];
    
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
}
- (void)presentScoreboardVC
{
    ScoreboardViewController *ScoreboardVC = [ScoreboardViewController new];
    
    [self.navigationController pushViewController:ScoreboardVC animated:YES];
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
