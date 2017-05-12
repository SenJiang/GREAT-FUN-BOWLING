//
//  ScoreCollectionViewCell.m
//  GREAT FUN BOWLING
//
//  Created by 姜森 on 17/5/4.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "ScoreCollectionViewCell.h"
#import "ScoreTableViewCell.h"
#import "Masonry.h"
#import "ZZNUIManager.h"
#import "ScoreBoardView.h"
#import "Manager.h"
@interface ScoreCollectionViewCell ()<UITableViewDelegate ,UITableViewDataSource>

@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property(nonatomic,strong)ScoreBoardView *scoreView;

@end
@implementation ScoreCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initUI];
}
- (void)initUI{
    self.label_totalScore.layer.borderColor = ZZN_UI_RGB(160, 160, 160).CGColor;
    self.imageView_head.layer.borderColor = ZZN_UI_RGB(0, 0, 60).CGColor;;
    
    
    self.tableView_mark.delegate = self;
    self.tableView_mark.dataSource = self;
    self.tableView_mark.bounces = NO;
    self.tableView_mark.backgroundColor = ZZN_UI_RGB(35, 24, 23);
    self.tableView_mark.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.tableView_mark.showsVerticalScrollIndicator = NO;
    self.tableView_mark.transform = CGAffineTransformMakeRotation(-M_PI / 2);
   
    [self.tableView_mark registerNib:[UINib nibWithNibName:@"ScoreTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"markCell"];
   
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.tableView_mark setFrame:CGRectMake(self.textfild_name.frame.size.width, 0, self.label_totalScore.frame.origin.x-self.textfild_name.frame.size.width, self.imageView_head.frame.size.height +self.imageView_head.frame.origin.y)];
        
    });
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageView_headAction)];
    [self.imageView_head addGestureRecognizer:tap];
    
    
    if (ZZN_UI_SCREEN_W > 400) {
        self.imageView_head_Constraint.constant = self.imageView_head_Constraint.constant + 5;
    }
    
    if (ZZN_UI_SCREEN_W < 350) {
        self.imageView_head_Constraint.constant = self.imageView_head_Constraint.constant - 2;
    }
    
}


#pragma mark - Action

- (void)imageView_headAction{
    [[ZZNUIManager sharedInstance] showAlertSelect:nil leftTitle:@"Take a New Picture" rightTitle:@"Selected Picture" leftBlock:^{
        if (self.cellBlock) {
            self.cellBlock(self,2);
        }
    } rightBlock:^{
        if (self.cellBlock) {
            self.cellBlock(self,1);
        }
    }];
}

- (void)setPerson:(Person *)person{
    _person = person;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImage *image = [UIImage imageWithContentsOfFile:person.image];
        if (image) {
            self.imageView_head.image = image;
        }else{
            self.imageView_head.image = [UIImage imageNamed:@"ico_boll.jpg"];
        }
        self.imageView_head.contentMode = UIViewContentModeRedraw;
        self.textfild_name.text = person.name;
        
        self.label_totalScore.text = person.total;
        
    });
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"markCell" forIndexPath:indexPath];
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label_number.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    cell.ceellHeight = self.imageView_head.frame.size.height;
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView_mark.frame.size.width/3;;
}
#pragma mark - UITableViewDataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Board *board = [Manager sharedInstance].managerArr[indexPath.row];

    
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    
    
    CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
    if (self.tabVCellBlock) {
        self.tabVCellBlock(self,rect,(int)indexPath.row);
    }
 
}
-(void)dealloc{
    
}
@end
