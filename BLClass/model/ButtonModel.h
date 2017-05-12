//
//  ButtonModel.h
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/12.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface ButtonModel : NSObject


@property(nonatomic,assign)CGRect cellFrame;

@property(nonatomic,assign)CGRect arrowFrame;

@property(nonatomic,assign)int row;

@property(nonatomic,assign)int buttonTag;

@property(nonatomic,strong)Board *board;
@end
