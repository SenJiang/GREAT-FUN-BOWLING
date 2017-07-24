//
//  NEWCell.h
//  GREAT FUN BOWLING
//
//  Created by Mac-hcm on 2017/5/19.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
@interface NEWCell : UICollectionViewCell

@property (nonatomic, strong)UILabel *label_top;
@property (nonatomic, strong)UIView *ViewH;

@property (nonatomic, strong)UIView *ViewV;

@property (nonatomic, strong)UILabel *label_first;
@property (nonatomic, strong)UILabel *label_second;
@property (nonatomic, strong)UILabel *label_result;
@property (nonatomic, strong)UILabel *label_three;


@property (nonatomic, assign)CGFloat height_imageView_head;
@property (nonatomic, assign)BOOL isLastCell;
@property (nonatomic, strong)Board *board;
@end
