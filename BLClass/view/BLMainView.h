//
//  BLMainView.h
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/4.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreCollectionViewCell.h"

typedef void(^PhotoBlock)(ScoreCollectionViewCell *,int , int);
@interface BLMainView : UIView
@property (nonatomic , copy)PhotoBlock photoBlock;

@property(nonatomic ,strong)UICollectionView *collectionView;

@property (nonatomic , strong)NSArray *scoreArray;

- (void)reload;
@end
