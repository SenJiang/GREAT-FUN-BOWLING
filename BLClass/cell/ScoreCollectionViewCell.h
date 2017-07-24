//
//  ScoreCollectionViewCell.h
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/4.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "ScoreTableViewCell.h"
@interface ScoreCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_totalScore;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_head;

@property (weak, nonatomic) IBOutlet UITableView *tableView_mark;
@property (weak, nonatomic) IBOutlet UITextField *textfild_name;
@property (weak, nonatomic) IBOutlet UIImageView *backgroudimageview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_head_Constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabView_top_costraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabview_left_constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabview_right_constraint;
@property (copy, nonatomic) void(^cellBlock)(ScoreCollectionViewCell * ,int);

@property (copy, nonatomic) void(^tabVCellBlock)(ScoreCollectionViewCell *,CGRect  ,int);//row

@property (copy, nonatomic) void(^scrollDidEndCall)(ScoreTableViewCell *,UITableView *);

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) int offSetRow;

@property (strong, nonatomic) Person *person;
@end
