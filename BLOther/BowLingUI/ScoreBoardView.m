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

@property (nonatomic, assign)CGRect cellFrame;//cell 的坐标

@property (nonatomic, assign)CGRect arrowFrame; //cell 在当前坐标系的位置

@property (nonatomic, strong)UIImageView *backimageView;

@property (nonatomic, strong)Board *board;

@property (nonatomic, assign)int row;//第几次记分

@property (nonatomic, strong)NSMutableArray *butArr;

@property (nonatomic, strong)ButtonModel *btnModel;//保留再次创建的参数


@property (nonatomic, strong)UIImageView *arrowView;//箭头

@property (nonatomic, strong)UIImageView *backgroudView;//背景

@property (nonatomic, assign)CGFloat arrow_x;

@property (nonatomic, assign)int columnIndex;
@end

@implementation ScoreBoardView
-(NSMutableArray *)butArr{
    if (!_butArr) {
        _butArr = [[NSMutableArray alloc]init];
    }
    return _butArr;
}
-(ButtonModel *)btnModel{
    if (!_btnModel) {
        _btnModel = [ButtonModel new];
    }
    return _btnModel;
}

- (instancetype)initWithFrame:(CGRect)frame ArrowFrame:(CGRect)ArrowFrame cellRow:(int)row board:(Board *)board columnIndex:(int)columnIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellFrame = frame;
        self.board = board;
        self.arrowFrame = ArrowFrame;
        self.row = row;
        self.columnIndex = columnIndex;
        [self initUIWithFrame];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initUIWithFrame{
    //底部view
    CGFloat backY;
    if (ZZN_UI_SCREEN_W>500) {
        backY = self.cellFrame.origin.y+20;
    }else{
        backY = self.cellFrame.origin.y-self.arrowFrame.size.height/2;
    }
    if (ZZN_UI_SCREEN_W < 350){
        backY = self.cellFrame.origin.y-self.arrowFrame.size.height/2+50;
    }
    self.frame = CGRectMake(25, backY, kScoreBoardWidh, kScoreBoardHeigh);
    UIView *backgroudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScoreBoardWidh, kScoreBoardHeigh)];
    [self addSubview:backgroudView];
    
    //放button的view
    UIImageView *backimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, backgroudView.frame.size.height/3, backgroudView.frame.size.width, backgroudView.frame.size.height/3*2)];
    backimageView.userInteractionEnabled = YES;
    backimageView.image = [UIImage imageNamed:@"ico_input_score_bg"];
    [backgroudView addSubview:backimageView];
    self.backimageView = backimageView;
    //箭头
    CGFloat arrow_x = self.arrowFrame.origin.x;
    
    if (self.row==9) {
        if ([self.board.firstFinish isEqualToString:@"yes"]) {
            arrow_x += self.arrowFrame.size.width/3;
        }
        if ([self.board.secondFinish isEqualToString:@"yes"]) {
            arrow_x += self.arrowFrame.size.width/3;
        }
        
        if (ZZN_UI_SCREEN_W < 350){
            arrow_x -= self.arrowFrame.size.width/4;
        }else{
           arrow_x -= self.arrowFrame.size.width/8;
        }
    }else{
        if ([self.board.firstFinish isEqualToString:@"yes"]) {
            arrow_x += self.arrowFrame.size.width/2;
        }
        if (ZZN_UI_SCREEN_W < 350){
            arrow_x -= self.arrowFrame.size.width/3;
        }else{
             arrow_x -= self.arrowFrame.size.width/6;
        }
       
    }
    self.arrow_x = arrow_x;
    UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(arrow_x, 0, 20, backgroudView.frame.size.height/3+6)];
    arrowView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(arrowViewAction)];
    backgroudView.userInteractionEnabled = YES;
    [backgroudView addGestureRecognizer:tap];
    arrowView.image = [UIImage imageNamed:@"ico_input_score_bg_p"];
    [backgroudView addSubview:arrowView];
    self.arrowView = arrowView;
    
    self.userInteractionEnabled =  YES;
    [self addGestureRecognizer:tap];
    
    
    
    //第四个翻转
    if (self.columnIndex == 3) {
        self.frame = CGRectMake(25, backY - kScoreBoardHeigh, kScoreBoardWidh, kScoreBoardHeigh);
        backimageView.frame = CGRectMake(0, 0, backgroudView.frame.size.width, backgroudView.frame.size.height/3*2);

        arrowView.frame = CGRectMake(arrow_x, backgroudView.frame.size.height/3*2-6, 20, backgroudView.frame.size.height/3+6);
        
         arrowView.image = [UIImage imageNamed:@"ico_input_score_bg_p180"];
    }
    
    
    
    

    
    
       //按钮
    CGFloat btnHeight = (backimageView.frame.size.height - 25 );
    if (ZZN_UI_SCREEN_W>600) {
        btnHeight = (backimageView.frame.size.height -  20);
    }
    
    CGFloat y = (backimageView.frame.size.height-btnHeight)/2;
    if (ZZN_UI_SCREEN_W<350) {
        y = (backimageView.frame.size.height-btnHeight)/2;
    }
    
    for (int i = 0; i<8; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake((backimageView.frame.size.width-10)/8*i+((backimageView.frame.size.width)/8 - btnHeight)/2 +3 , y, btnHeight , btnHeight);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ico_b%dp",i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ico_b%d",i]] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
        [backimageView addSubview:btn];
        
        //第一次球的展示
        if (![self.board.firstFinish isEqualToString:@"yes"]) {
            btn.selected = YES;
            if (i==7) {
                btn.selected = NO;
                btn.userInteractionEnabled = NO;
            }
        }else{
            btn.selected = YES;
            //最后一场打第三个球的展示
            if (self.row == 9 && ![self.board.secondScore isEqualToString:@""]) {
                if (i==7) {
                    btn.selected = NO;
                    btn.userInteractionEnabled = NO;
                }
            }else{
                //第二记球的展示
                if (self.row == 9 &&  self.board.firstScore.intValue == 6) {
                    //最后一场打第一个球为X的情况
                    if (i==7) {
                        btn.selected = NO;
                        btn.userInteractionEnabled = NO;
                    }
                }else{
                    if ((i==6 || i>(5- self.board.firstScore.intValue))&&i!=7) {
                        btn.selected = NO;
                        btn.userInteractionEnabled = NO;
                    }
                    
                }
                
            }
            
        }
        
        btn.tag=i;
    }
    
}
-(void)jump:(UIButton *)button
{
    self.btnModel.cellFrame = self.cellFrame;
    CGRect Arrowframe = self.arrowFrame;
    self.btnModel.arrowFrame = Arrowframe;
    self.btnModel.buttonTag = (int)button.tag;
    self.btnModel.row = self.row;
    self.btnModel.board = self.board;
    [self.delegate clickBtnRefreshWith:self.btnModel];
    
    return;
    
}
- (void)arrowViewAction
{
//    [self removeFromSuperview];
    
}
-(void)setIs4:(BOOL)is4
{
    _is4 = is4;
//    if (self.is4) {
//        self.arrowView.image = [UIImage imageNamed:@"ico_input_score_bg_p180"];
//       self.arrowView.frame = CGRectMake(self.arrow_x, self.backgroudView.frame.size.height/3*2-6, 20, self.backgroudView.frame.size.height/3+6);
//        self.backimageView.frame = CGRectMake(0, 0, self.backgroudView.frame.size.width, self.backgroudView.frame.size.height/3*2);
//    }
}

-(void)dealloc{

}
@end
