//
//  NEWCell.m
//  GREAT FUN BOWLING
//
//  Created by Mac-hcm on 2017/5/19.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "NEWCell.h"
#import "masonry.h"
#import "ZZNUIManager.h"

@interface NEWCell ()

@property (nonatomic, strong)UIView *lineView;

@end
@implementation NEWCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.label_top = [UILabel new];
        self.label_top.textColor = ZZN_UI_COLOR_WHITE;
        self.label_top.textAlignment = NSTextAlignmentCenter;
        self.label_top.backgroundColor = BOWLING_BACKGROUD_COLOR;
        self.label_top.text = @"";
        self.label_top.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:self.label_top];
        
        self.label_first = [UILabel new];
        self.label_first.textColor = ZZN_UI_COLOR_WHITE;
        self.label_first.textAlignment = NSTextAlignmentCenter;
        self.label_first.text = @"";
        self.label_first.font = [UIFont boldSystemFontOfSize:18];
        self.label_first.backgroundColor = BOWLING_FIRST_COLOR;
        [self addSubview:self.label_first];
        
        self.label_second = [UILabel new];
        self.label_second.textColor = ZZN_UI_COLOR_WHITE;
        self.label_second.text = @"";
        self.label_second.textAlignment = NSTextAlignmentCenter;
         self.label_second.backgroundColor = BOWLING_SECOND_COLOR;
         self.label_second.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:self.label_second];
        
        self.label_result = [UILabel new];
        self.label_result.textColor = ZZN_UI_COLOR_WHITE;
        self.label_result.text = @"";
        self.label_result.backgroundColor = BOWLING_FIRST_COLOR;
        self.label_result.textAlignment = NSTextAlignmentCenter;
        self.label_result.font = [UIFont boldSystemFontOfSize:22];
        [self addSubview:self.label_result];
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = BOWLING_LINE_COLOR;
        [self.label_result addSubview:self.lineView];
        
        self.label_result.layer.borderWidth = 0.5;
        self.label_result.layer.borderColor = BOWLING_LINE_COLOR.CGColor;
        self.label_first.layer.borderWidth = .5;
        self.label_first.layer.borderColor = BOWLING_LINE_COLOR.CGColor;
        self.label_second.layer.borderWidth = .5;
        self.label_second.layer.borderColor = BOWLING_LINE_COLOR.CGColor;
        
    }
    
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        
        BLWeak
        
        //场分
        [self.label_result mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo([NSNumber numberWithFloat:self.height_imageView_head*0.6]);
        }];
        //底部线条
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@3);
        }];
        //第一个分
        [self.label_first mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.bottom.equalTo(self.label_result.mas_top).offset(0);
            make.left.equalTo(@0);
            make.width.equalTo([NSNumber numberWithFloat:self.frame.size.width/2]);
            make.height.equalTo([NSNumber numberWithFloat:self.height_imageView_head*0.4]);
        }];
        //第二分
        [self.label_second mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.bottom.equalTo(self.label_result.mas_top).offset(0);
            make.right.equalTo(@0);
            make.width.equalTo([NSNumber numberWithFloat:self.frame.size.width/2]);
            make.height.equalTo([NSNumber numberWithFloat:self.height_imageView_head*0.4]);
            
        }];
        //序号
        [self.label_top mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.bottom.equalTo(self.label_first.mas_top).offset(0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@24);
        }];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        BLWeak
        //场分
        [self.label_result mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo([NSNumber numberWithFloat:self.frame.size.height*0.6]);
        }];
        //第一个分
        [self.label_first mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.bottom.equalTo(self.label_result.mas_top).offset(0);
            make.left.equalTo(@0);
            make.width.equalTo([NSNumber numberWithFloat:self.frame.size.width/2]);
            make.height.equalTo([NSNumber numberWithFloat:self.frame.size.height*0.4]);
        }];
        //第二分
        [self.label_second mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.bottom.equalTo(self.label_result.mas_top).offset(0);
            make.right.equalTo(@0);
            make.width.equalTo([NSNumber numberWithFloat:self.frame.size.width/2]);
            make.height.equalTo([NSNumber numberWithFloat:self.frame.size.height*0.4]);
            
        }];
        //底部线
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@1);
        }];

        //序号
        [self.label_top mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.bottom.equalTo(self.label_first.mas_top).offset(0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@24);
        }];
    }

}
-(void)setBoard:(Board *)board
{
    _board = board;
    self.label_first.text = board.firstScore;
    self.label_second.text = board.secondScore;
    if (board.firstScore.intValue == 6) {
        self.label_first.text = @"X";
    }
    if (board.secondScore.intValue == 7) {
        self.label_second.text = @"／";
    }
    self.label_result.text = board.resultScore;
}
@end
