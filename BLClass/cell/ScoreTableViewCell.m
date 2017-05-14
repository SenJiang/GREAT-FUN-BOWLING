//
//  ScoreTableViewCell.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/5.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "ScoreTableViewCell.h"
#import "ZZNUIManager.h"

@interface ScoreTableViewCell ()

@property (nonatomic,assign)BOOL isload;

@end
@implementation ScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initUI];
}
- (void)initUI{
    self.label_score_total.layer.borderWidth = 1;
    self.label_score_total.layer.borderColor = ZZN_UI_RGB(160, 160, 160).CGColor;
    
    
}
-(void)setCeellHeight:(CGFloat)ceellHeight
{
    _ceellHeight = ceellHeight;
    self.labe_score_total_Constraint.constant = 0.6*self.ceellHeight;
    self.label_score_first_Constraint.constant = 0.4*self.ceellHeight;
    self.label_score_second_Constraint.constant = 0.4*self.ceellHeight;
}
-(void)setBoard:(Board *)board
{
    _board = board;
    self.label_score_first.text = board.firstScore;
    self.label_score_second.text = board.secondScore;
    if (board.firstScore.intValue == 6) {
        self.label_score_first.text = @"X";
    }
    if (board.secondScore.intValue == 7) {
        self.label_score_second.text = @"／";
    }
    self.label_score_total.text = board.resultScore;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
