//
//  BLCollectionViewCell.h
//  GREAT FUN BOWLING
//
//  Created by Mac-hcm on 2017/5/19.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NEWCell.h"
#import "Person.h"
@interface BLCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *label_total;
@property (strong, nonatomic) UILabel *label_totalScore;    //total
@property (strong, nonatomic) UITextField *textfild_name;   //p1
@property (strong, nonatomic) UITableView *tabView;
@property (strong, nonatomic) UICollectionView *collecView;    //10个
@property (strong, nonatomic) UIImageView *backGroudImageView; // 背景
@property (strong, nonatomic) UIImageView *imageView_head;      //头像

//横屏
@property (strong, nonatomic) UIView *view_leftbackgroud;
@property (strong, nonatomic) UIImageView *imageView_left;      //横屏时左边的标记图


@property (copy, nonatomic) void(^cellBlock)(BLCollectionViewCell * ,int);

@property (copy, nonatomic) void(^tabVCellBlock)(BLCollectionViewCell *,CGRect  ,int);//row

@property (copy, nonatomic) void(^scrollDidEndCall)(NEWCell *,UICollectionView *);

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) int offSetRow;

@property (strong, nonatomic) Person *person;
@end
