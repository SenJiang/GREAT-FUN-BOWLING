//
//  GameEndView.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/27.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "GameEndView.h"
#import "masonry.h"
#import "ZZNUIManager.h"
@interface GameEndView ()
@property(nonatomic ,strong)UIImageView *backGroudImageView;
@property(nonatomic ,strong)UILabel *label;
@property(nonatomic ,strong)UIImageView *animationView;
@property(nonatomic ,strong)UIImageView *view_gameover;
@property(nonatomic ,strong)UIImageView *congratulation;
@property(nonatomic ,strong)UIImageView *yeah;
@property(nonatomic ,assign)BOOL isMove;
@property(nonatomic ,strong)UIImageView *view_red;
@end
@implementation GameEndView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIImageView *backGroudImageView = [UIImageView new];
        backGroudImageView.image = [UIImage imageNamed:@"result_bg.jpg"];
        [self addSubview:backGroudImageView];
        self.backGroudImageView = backGroudImageView;
        
        UIImageView *animationView = [UIImageView new];
        animationView.image = [UIImage imageNamed:@"ico_crown_l 2"];        
        [self addSubview:animationView];
        self.animationView = animationView;
        
        UIImageView *view_gameover = [UIImageView new];
        view_gameover.image = [UIImage imageNamed:@"ico_game_over_"];
        [self addSubview:view_gameover];
        self.view_gameover = view_gameover;
     
        
        UIImageView *view_red = [UIImageView new];
        view_red.image = [UIImage imageNamed:@"ico_game_over_zbg"];
        [self addSubview:view_red];
        self.view_red = view_red;
        
        
        UIImageView *congratulation = [UIImageView new];
        congratulation.image = [UIImage imageNamed:@"ico_congratuta"];
        [self addSubview:congratulation];
        self.congratulation = congratulation;
        
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.text = @"The winner is P1";
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.label = label;
        
        UIImageView *yeah = [UIImageView new];
        yeah.image = [UIImage imageNamed:@"ico_yeah"];
        [self addSubview:yeah];
        self.yeah = yeah;

        
        [self timerAnimation];
    }
    return self;
}
-(void)initUI
{
    [self.backGroudImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
     BLWeak
    CGSize size = CGSizeMake(200,240);
    [self.animationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@-40);
        make.size.mas_equalTo(size);
    }];
    
    [self.view_gameover mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@40);
        make.height.equalTo(@70);
    }];
    
    [self.view_red mas_remakeConstraints:^(MASConstraintMaker *make) {
        BLStrong
        make.top.equalTo(self.yeah.mas_top).offset(0);
        make.centerX.equalTo(@0);
        make.width.equalTo(@300);
        make.bottom.equalTo(@0);
    }];
    [self.congratulation mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.height.equalTo(@30);
        make.bottom.equalTo(@-40);
    }];
   
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        BLStrong
        make.bottom.equalTo(self.congratulation.mas_top).offset(-20);
        make.centerX.equalTo(@0);
        make.height.equalTo(@60);
        make.width.equalTo(@250);
        
    }];
    [self.yeah mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.label.mas_top).offset(-20);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.centerX.equalTo(@0);
    }];
    [self show];
}
-(void)hengping{
     BLWeak
        [self.backGroudImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        
        CGSize size = CGSizeMake(180,220);
        [self.animationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.centerY.equalTo(@0);
            make.size.mas_equalTo(size);
        }];
        
        [self.view_gameover mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.centerX.equalTo(@0);
            make.width.equalTo(@350);
            make.bottom.equalTo(self.backGroudImageView.mas_bottom).offset(-20);
            make.height.equalTo(@80);
        }];
    
        [self.view_red mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.bottom.equalTo(self.view_gameover.mas_top).offset(50);
            make.centerX.equalTo(@0);
            make.width.equalTo(@350);
            make.centerY.equalTo(@0);
        }];

        [self.congratulation mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@300);
            make.centerX.equalTo(@0);
            make.height.equalTo(@30);
            make.bottom.equalTo(@-130);
        }];
    
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.bottom.equalTo(self.congratulation.mas_top).offset(-5);
            make.centerX.equalTo(@0);
            make.height.equalTo(@60);
            make.width.equalTo(@250);
            
        }];
        if (ZZN_UI_SCREEN_H < 350) {
            [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                BLStrong
                make.bottom.equalTo(self.congratulation.mas_top).offset(35);
                make.centerX.equalTo(@0);
                make.height.equalTo(@60);
                make.width.equalTo(@250);
            }];
            
        }
        if (ZZN_UI_SCREEN_H == 375) {
            [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                BLStrong
                make.bottom.equalTo(self.congratulation.mas_top).offset(25);
                make.centerX.equalTo(@0);
                make.height.equalTo(@60);
                make.width.equalTo(@250);
            }];
            
        }

        [self.yeah mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.label.mas_top).offset(-10);
            make.width.equalTo(@80);
                make.height.equalTo(@30);
                make.centerX.equalTo(@0);
            }];
        [self hide];
}
-(void)hide
{
    self.view_gameover.hidden = YES;
    self.view_red.hidden = YES;
    self.yeah.hidden = YES;
    self.congratulation.hidden = YES;
    self.backGroudImageView.image = [UIImage imageNamed:@"result_bgh"];
}
-(void)show{
    self.view_gameover.hidden = NO;
    self.view_red.hidden = NO;
    self.yeah.hidden = NO;
    self.congratulation.hidden = NO;
    self.backGroudImageView.image = [UIImage imageNamed:@"result_bg.jpg"];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
    
        [self initUI];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight){
    
        [self hengping];
    }
}
- (void)timerAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    animation.duration = 0.4;
    //关键点
    animation.values = @[@0,@30,@(-0),@(0)];
    //参照当前的position点移动多少。
    animation.additive = YES;
    animation.repeatCount = MAXFLOAT;
    [self.animationView.layer addAnimation:animation forKey:nil];
  }
-(void)setWinner:(NSString *)winner
{
    _winner = winner;
    self.label.text = [NSString stringWithFormat:@"The winner is %@",self.winner];
}
-(void)startAnimation{
    [self.layer removeAllAnimations];
    [self timerAnimation];
}
@end
