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

- (instancetype)initWithFrame:(CGRect)frame ArrowFrame:(CGRect)ArrowFrame cellRow:(int)row board:(Board *)board
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellFrame = frame;
        self.board = board;
        self.arrowFrame = ArrowFrame;
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
    
        //箭头
    CGFloat arrow_x = self.arrowFrame.origin.x;
    if (self.board.areadyBall== 1) {
        arrow_x += self.arrowFrame.size.width/2;
    }
        UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(arrow_x, 0, 15, 100)];
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
    
    
        CGFloat y = self.frame.size.height -(self.frame.size.height-btnHeight)+1;
        if (ZZN_UI_SCREEN_W<350) {
           y = self.frame.size.height -(self.frame.size.height-btnHeight) + btnHeight/2-2;
        }
        for (int i = 0; i<8; i++) {
            UIButton *btn = [[UIButton alloc]init];
            btn.frame = CGRectMake(btnHeight*i + 10, y, btnHeight , btnHeight);
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
                //第二记球的展示
                btn.selected = YES;
                if ((i==6 || i>(5- self.board.firstScore.intValue))&&i!=7) {
                    btn.selected = NO;
                    btn.userInteractionEnabled = NO;
                }
            }
            
            btn.tag=i;
        }
    
}
-(void)jump:(UIButton *)button
{
    self.btnModel.cellFrame = self.cellFrame;
    CGRect Arrowframe = self.arrowFrame;
    if ((self.arrowFrame.origin.x + Arrowframe.size.width/2>ZZN_UI_SCREEN_W/2)&&self.row<=8) {
         Arrowframe.origin.x = Arrowframe.origin.x - Arrowframe.size.width/2;
    }else{
       
             Arrowframe.origin.x = Arrowframe.origin.x + Arrowframe.size.width/2;
        
    }
    
//    if (self.row>=8) {
//        Arrowframe.origin.x = Arrowframe.origin.x + Arrowframe.size.width/2;
//    }
    self.btnModel.arrowFrame = Arrowframe;
    self.btnModel.buttonTag = (int)button.tag;
    self.btnModel.row = self.row;
    self.btnModel.board = self.board;
    [self.delegate clickBtnRefreshWith:self.btnModel];
    
    return;
    
}
- (void)arrowViewAction
{
    [self removeFromSuperview];
    
}
-(void)dealloc{

}
@end
