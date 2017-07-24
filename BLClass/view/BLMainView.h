//
//  BLMainView.h
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/4.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ScoreCollectionViewCell.h"
#import "ScoreBoardView.h"
//#import "NEWCell.h"
#import "BLCollectionViewCell.h"
typedef void(^PhotoBlock)(BLCollectionViewCell *,int , int);
@interface BLMainView : UIView

@property(nonatomic,strong) ScoreBoardView *scoreViewBut;//按钮view

@property (nonatomic , copy)PhotoBlock photoBlock;

@property (nonatomic, copy)void (^greatShowCall)(int, NSString *);

@property (nonatomic, copy)void (^greatShowText)(NSString*);

@property(nonatomic ,strong)UICollectionView *collectionView;

@property (nonatomic , strong)NSArray *scoreArray;


- (void)hideButtonView;
- (void)reload;
@end
