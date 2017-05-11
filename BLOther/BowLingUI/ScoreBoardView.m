//
//  ScoreBoardView.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/6.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "ScoreBoardView.h"
#import "Manager.h"

@interface ScoreBoardView ()

@property (nonatomic, assign)CGRect cellFrame;

@property (nonatomic, strong)UIImageView *backimageView;

@property (nonatomic, strong)Board *board;

@property (nonatomic, assign)int row;

@property (nonatomic, strong)NSMutableArray *butArr;
@end

@implementation ScoreBoardView
-(NSMutableArray *)butArr{
    if (_butArr) {
        _butArr = [[NSMutableArray alloc]init];
    }
    return _butArr;
}

- (instancetype)initWithFrame:(CGRect)frame cellRow:(int)row board:(Board *)board
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellFrame = frame;
        self.board = board;
        self.row = row;
        [self initUIWithFrame];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initUIWithFrame{
        UIImageView *backimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.cellFrame.origin.y+30, kScoreBoardWidh, kScoreBoardHeigh)];
        backimageView.contentMode = UIViewContentModeScaleToFill;
        backimageView.userInteractionEnabled = YES;
        backimageView.image = [UIImage imageNamed:@"ico_input_score_bg"];
        [self addSubview:backimageView];
        
        UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 0, 15, 100)];
        arrowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(arrowViewAction)];
        arrowView.contentMode = UIViewContentModeScaleToFill;
        arrowView.image = [UIImage imageNamed:@"ico_input_score_bg_p"];
        [backimageView addSubview:arrowView];
        
        CGFloat btnHeight = (self.frame.size.width - 30)/8;
    
         UIImageView *view  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScoreBoardWidh, self.frame.size.height-btnHeight*2)];
        view.userInteractionEnabled = YES;
        [backimageView addSubview:view];
        [view addGestureRecognizer:tap];
    
        for (int i = 0; i<8; i++) {
            UIButton *btn = [[UIButton alloc]init];
            btn.frame = CGRectMake(btnHeight*i + 10, self.frame.size.height -(self.frame.size.height-btnHeight)+1, btnHeight , btnHeight);
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ico_b%dp",i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ico_b%d",i]] forState:UIControlStateSelected];
            
            [btn addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
            [backimageView addSubview:btn];
            
            
            
            if (self.board.firstScore == 0) {
                btn.selected = YES;
            }
            if (i==7) {
                btn.selected = NO;
                btn.userInteractionEnabled = NO;
            }
                
            btn.tag=i;
        }
    
}
-(void)jump:(UIButton *)button
{
    
    [self.delegate clickBtnRefresh];
    
    //是否还能下一个
    if (!self.board.firstScore&&!self.board.secondScore) {
        //重新刷新
        [self refrshButton:YES];
        self.board.firstScore =[NSString stringWithFormat:@"%d",(int)button.tag];
        if (self.boardBtnCall) {
            self.boardBtnCall((int)button.tag);
        }
    }else{
        [self refrshButton:NO];
    }
    
    
    
    
}
- (void)refrshButton:(BOOL )allRefresh
{
    if (allRefresh) {
        for (int i = 0; i<self.butArr.count; i++) {
            UIButton *btn = self.butArr[i];
            btn.selected = YES;
            if (i==7) {
                btn.selected = NO;
                 btn.userInteractionEnabled = NO;
            }
        }
    }else{
        if (self.board.firstScore) {//第一个数有了，给弹框
            
        }else{
            
        }
        
    }
    
}
- (void)arrowViewAction
{
    self.hidden = YES;
    
}
-(void)dealloc{

}
@end
