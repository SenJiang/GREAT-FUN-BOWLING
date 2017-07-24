//
//  ScoreSubCell.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/14.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "ScoreSubCell.h"
#import "ZZNUIManager.h"
@implementation ScoreSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)initUI{
    self.label_result.layer.borderWidth = 1;
    self.label_result.layer.borderColor = ZZN_UI_RGB(160, 160, 160).CGColor;
    
    
}

-(void)setCeellHeight:(CGFloat)ceellHeight
{
    _ceellHeight = ceellHeight;
    self.label_result_contrainst.constant = 0.6*self.ceellHeight;
    self.label_first_contrainst.constant = 0.4*self.ceellHeight;
    
}
-(void)setBoard:(Board *)board
{
    _board = board;
    self.label_first.text = board.firstScore;
    self.labe_second.text = board.secondScore;
    self.label_result.text = board.resultScore;
    self.label_three.text = board.threeScore;
    if (board.firstScore.intValue == 6) {
        self.label_first.text = @"X";
    }
    if (board.secondScore.intValue == 7) {
        self.labe_second.text = @"/";
    }
    if (board.secondScore.intValue == 6) {
        self.labe_second.text = @"X";
    }
    if (board.threeScore.intValue == 6) {
        self.label_three.text = @"X";
    }
    if (board.threeScore.intValue == 7) {
        self.label_three.text = @"/";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
