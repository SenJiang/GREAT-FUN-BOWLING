//
//  NumView.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/26.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "NumView.h"


@interface NumView ()
@property (nonatomic, strong)NSMutableArray *array_lab;
@end
@implementation NumView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    CGFloat width = self.frame.size.width/13;
    CGFloat height = self.frame.size.height;
    self.array_lab = [[NSMutableArray alloc]init];;
    for (int i = 0; i<13; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width*i, 0, width, height)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        if (i>1) {
            label.text = [NSString stringWithFormat:@"%d",i-1];
            if (i==12) {
                label.text = @"total";
            }
        }
        [self.array_lab addObject:label];
        [self addSubview:label];
    }
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width/13;
    CGFloat height = self.frame.size.height;
    for (int i = 0 ; i<13; i++) {
        UILabel *label = self.array_lab[i];
        label.frame = CGRectMake(width*i, 0, width, height);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
