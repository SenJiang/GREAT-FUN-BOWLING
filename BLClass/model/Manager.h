//
//  Manager.h
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/11.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Manager : NSObject
+ (instancetype) sharedInstance;
@property (nonatomic,strong)NSArray *managerArr;

@end
