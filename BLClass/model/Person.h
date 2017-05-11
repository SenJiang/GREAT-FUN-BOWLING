//
//  Person.h
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/6.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Board : NSObject<NSCopying,NSCoding>

@property (nonatomic,copy)NSString *firstScore;

@property (nonatomic,copy)NSString *secondScore;

@property (nonatomic,copy)NSString *resultScore;

@end

@interface Person : NSObject<NSCopying,NSCoding>

@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *image;

@property (nonatomic, copy)NSString *total;

@property (nonatomic, strong)NSMutableArray *socreData;

@end
