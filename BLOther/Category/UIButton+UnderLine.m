//
//  UIButton+UnderLine.m
//  viocebutton
//
//  Created by 姜森 on 17/1/8.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "UIButton+UnderLine.h"

@implementation UIButton (UnderLine)
- (void)underLineButtonWithString:(NSString *)string;
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [self setAttributedTitle:str forState:UIControlStateNormal];
//    [_awardDisplayBtn setAttributedTitle:str forState:UIControlStateNormal];
    
}
@end
