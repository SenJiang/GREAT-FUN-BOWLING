//
//  ScoreBoardView.h
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/6.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZNUIManager.h"
#import "Person.h"
#import "ButtonModel.h"
#define kScoreBoardHeigh 90
#define kScoreBoardWidh ZZN_UI_SCREEN_W - 50




@protocol ScoreBoardViewDelegate <NSObject>

- (void)clickBtnRefreshWith:(ButtonModel *)btnModel;

@end

@interface ScoreBoardView : UIView

@property(nonatomic,copy)void (^boardBtnCall)(int);

@property(nonatomic,weak)id <ScoreBoardViewDelegate>delegate;

@property (nonatomic, assign)BOOL is4;

- (instancetype)initWithFrame:(CGRect)frame ArrowFrame:(CGRect)ArrowFrame cellRow:(int)row board:(Board *)board columnIndex:(int)columnIndex;

@end
