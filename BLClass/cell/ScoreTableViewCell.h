//
//  ScoreTableViewCell.h
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/5.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Person.h"
@interface ScoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_number;
@property (weak, nonatomic) IBOutlet UILabel *label_score_first;
@property (weak, nonatomic) IBOutlet UILabel *label_score_second;
@property (weak, nonatomic) IBOutlet UILabel *label_score_total;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labe_score_total_Constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_score_first_Constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_score_second_Constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_score_second_Constraint_right;

@property (nonatomic, assign)BOOL isLastCell;

@property (nonatomic, assign)CGFloat ceellHeight;
@property (nonatomic, strong)Board *board;
@end
