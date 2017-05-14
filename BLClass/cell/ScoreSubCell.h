//
//  ScoreSubCell.h
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/14.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
@interface ScoreSubCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labe_num;
@property (weak, nonatomic) IBOutlet UILabel *label_first;
@property (weak, nonatomic) IBOutlet UILabel *labe_second;
@property (weak, nonatomic) IBOutlet UILabel *label_three;
@property (weak, nonatomic) IBOutlet UILabel *label_result;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_first_contrainst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label_result_contrainst;
@property (nonatomic, assign)CGFloat ceellHeight;
@property (nonatomic, strong)Board *board;
@end
