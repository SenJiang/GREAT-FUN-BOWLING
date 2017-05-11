//
//  ScoreCollectionViewCell.h
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/4.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface ScoreCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_totalScore;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_head;

@property (weak, nonatomic) IBOutlet UITableView *tableView_mark;
@property (weak, nonatomic) IBOutlet UITextField *textfild_name;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_head_Constraint;
@property (copy, nonatomic) void(^cellBlock)(ScoreCollectionViewCell * ,int);

@property (copy, nonatomic) void(^tabVCellBlock)(ScoreCollectionViewCell * ,int);//row

@property (nonatomic, strong) NSArray *dataSource;

@property (strong, nonatomic) Person *person;
@end
