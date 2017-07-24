//
//  BLCollectionViewCell.m
//  GREAT FUN BOWLING
//
//  Created by Mac-hcm on 2017/5/19.
//  Copyright © 2017年 姜森. All rights reserved.
//

#import "BLCollectionViewCell.h"
#import "masonry.h"
#import "ScoreTableViewCell.h"
#import "NEWCell.h"
#import "ZZNUIManager.h"
#import "ScoreBoardView.h"
#import "Manager.h"
#import "NewThreeCell.h"
#import "UIImage+WZ.h"
@interface BLCollectionViewCell ()<UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)ScoreBoardView *scoreView;
@property(nonatomic,assign)BOOL isHengping;
@end
@implementation BLCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景图
        self.backGroudImageView = [UIImageView new];
        self.backGroudImageView.image = [UIImage imageNamed:@"ico_score_bg1"];
        [self addSubview:self.backGroudImageView];

        //昵称
        self.textfild_name = [UITextField new];
        self.textfild_name.textColor = ZZN_UI_COLOR_WHITE;
        self.textfild_name.returnKeyType = UIReturnKeyDone;
        self.textfild_name.font = [UIFont systemFontOfSize:18 ];
        self.textfild_name.backgroundColor = BOWLING_RANK_COLOR;
        [self addSubview:self.textfild_name];
        
        //total
        self.label_total = [UILabel new];
        self.label_total.textColor = ZZN_UI_COLOR_WHITE;
        self.label_total.text = @"total";
        [self addSubview:self.label_total];
        //总分
        self.label_totalScore = [UILabel new];
        self.label_totalScore.textColor = ZZN_UI_COLOR_ORANGE;
        self.label_totalScore.textAlignment = NSTextAlignmentCenter;
        self.label_totalScore.font = [UIFont fontWithName:@"PingFang SC" size:26];
        self.label_totalScore.backgroundColor = BOWLING_BACKGROUD_COLOR;
        self.label_totalScore.layer.borderWidth = 1;
        self.label_totalScore.layer.borderColor = BOWLING_LINE_COLOR.CGColor;
        [self addSubview:self.label_totalScore];
        
        //头像
        self.imageView_head = [UIImageView new];
        self.imageView_head.userInteractionEnabled = YES;
        self.imageView_head.layer.borderWidth = 2;
        self.imageView_head.layer.borderColor = ZZN_UI_COLOR_BLACK.CGColor;
        self.imageView_head.clipsToBounds = YES;
        self.imageView_head.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView_head];
        [self setTabview];
        
        //横屏时的左边背景图
        self.view_leftbackgroud = [UIView new];
        self.view_leftbackgroud.backgroundColor = BOWLING_RANK_COLOR;
        [self addSubview:self.view_leftbackgroud];
        
        //横屏时的得分标记图
        self.imageView_left = [UIImageView new];
        [self.view_leftbackgroud addSubview:self.imageView_left];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageView_headAction)];
        [self.imageView_head addGestureRecognizer:tap];

    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        BLWeak
        self.isHengping  = NO;
        self.backGroudImageView.hidden = NO;
//        self.imageView_left.hidden = YES;
        //背景图片
        [self.backGroudImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
        //total
        [self.label_total mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.right.equalTo(@-20);
            make.width.equalTo(@50);
            make.height.equalTo(@25);
        }];
        self.label_total.hidden = NO;
        
        //name
        [self.textfild_name mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(@70);
            make.height.equalTo(@25);
        }];
        
        
        //头像
        
        [self.imageView_head mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.top.equalTo(self.textfild_name.mas_bottom).offset(0);
            make.right.equalTo(self.textfild_name.mas_right).offset(-5);
            make.left.equalTo(self.textfild_name.mas_left).offset(5);
            make.bottom.equalTo(@-25);
        }];
        if (ZZN_UI_SCREEN_W < 350) {
            [self.imageView_head mas_remakeConstraints:^(MASConstraintMaker *make) {
                BLStrong
                make.top.equalTo(self.textfild_name.mas_bottom).offset(0);
                make.right.equalTo(self.textfild_name.mas_right).offset(-5);
                make.left.equalTo(self.textfild_name.mas_left).offset(5);
                make.bottom.equalTo(@-22);
            }];
        }
        if (ZZN_UI_SCREEN_W >400) {
            [self.imageView_head mas_remakeConstraints:^(MASConstraintMaker *make) {
                BLStrong
                make.top.equalTo(self.textfild_name.mas_bottom).offset(0);
                make.right.equalTo(self.textfild_name.mas_right).offset(-5);
                make.left.equalTo(self.textfild_name.mas_left).offset(5);
                make.bottom.equalTo(@-28);
            }];
        }
        
        //总分
        [self.label_totalScore mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.top.equalTo(self.label_total.mas_bottom).offset(2);
            make.width.equalTo(@70);
            make.right.equalTo(@-20);
            make.bottom.equalTo(self.imageView_head.mas_bottom).offset(0);
        }];
        
        
        //中间记分板
        [self.collecView mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.top.equalTo(@2);
            make.left.equalTo(self.textfild_name.mas_right).offset(0);
            make.right.equalTo(self.label_totalScore.mas_left).offset(0);
            make.bottom.equalTo(self.imageView_head.mas_bottom).offset(0);
        }];
        [self.collecView reloadData];
        
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        self.isHengping = YES;
        self.backGroudImageView.hidden = YES;
        BLWeak
        CGFloat with = (ZZN_UI_SCREEN_W - ZZN_UI_SCREEN_W/13/2)/13;
        NSNumber *num_with = [NSNumber numberWithFloat:with];
        //背景图片
        [self.backGroudImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
        //total
        self.label_total.hidden = YES;
        
        
        //name
        [self.textfild_name mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(num_with);
            make.height.equalTo(@25);
        }];
        
        //横屏时的左边背景图
        [self.view_leftbackgroud mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(num_with);
            make.bottom.equalTo(self.textfild_name.mas_top).offset(-2);
        }];
        
        //昵称上方的标记图
        [self.imageView_left mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.bottom.equalTo(@0);
        }];
        
        //头像
        [self.imageView_head mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            make.top.equalTo(@0);
            make.width.equalTo(num_with);
            make.left.equalTo(self.textfild_name.mas_right).offset(0);
            make.bottom.equalTo(@0);
        }];
      
        //总分
        [self.label_totalScore mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.width.equalTo(num_with);
            make.right.equalTo(@0);;
            make.bottom.equalTo(@0);
        }];
        
        
        //中间记分板
        [self.collecView mas_remakeConstraints:^(MASConstraintMaker *make) {
            BLStrong
            
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.left.equalTo(self.imageView_head.mas_right).offset(0);
            make.right.equalTo(self.label_totalScore.mas_left).offset(0);
        }];
        
    }
    
}

- (void)setTabview{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView *collec = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collec.delegate = self;
    collec.dataSource = self;
    collec.backgroundColor = [UIColor clearColor];
    collec.showsVerticalScrollIndicator = NO;
    collec.bounces = NO;
    [self addSubview:collec];
    self.collecView = collec;
    [collec registerClass:[NEWCell class] forCellWithReuseIdentifier:@"cellid"];
    [collec registerClass:[NewThreeCell class] forCellWithReuseIdentifier:@"threeCellId"];


    
}


#pragma mark - Action

- (void)imageView_headAction{
    BLWeak
    [[ZZNUIManager sharedInstance] showAlertSelect:nil leftTitle:@"Take a New Picture" rightTitle:@"Selected Picture" leftBlock:^{
        BLStrong
        if (self.cellBlock) {
            self.cellBlock(self,2);
        }
    } rightBlock:^{
        BLStrong
        if (self.cellBlock) {
            self.cellBlock(self,1);
        }
    }];
}

- (void)setPerson:(Person *)person{
    _person = person;
        UIImage *image = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/bowling%d.png",person.image.intValue]]];
        if (image) {
            self.imageView_head.image = image;
        }else{
            self.imageView_head.image = [UIImage imageNamed:@"ico_boll.jpg"];
        }
        self.textfild_name.text = person.name;

        self.label_totalScore.text = person.total;
        if ([person.name_enabled isEqualToString:@"yes"]) {
            self.textfild_name.enabled = YES;
        }else{
            self.textfild_name.enabled = NO;
        }
       
        
}
-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self.collecView reloadData];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 9) {
        NewThreeCell *threeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"threeCellId" forIndexPath:indexPath];
        threeCell.label_top.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        threeCell.height_imageView_head = self.imageView_head.frame.size.height;
        threeCell.board = self.dataSource[indexPath.row];
        
        return threeCell;
    }else{
    
        NEWCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
        cell.height_imageView_head = self.imageView_head.frame.size.height;
        cell.label_top.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        cell.height_imageView_head = self.imageView_head.frame.size.height;
        cell.board = self.dataSource[indexPath.row];
        return cell;
    }
    

}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.isHengping) {
        if (indexPath.row == 9) {
            return CGSizeMake(self.collecView.frame.size.width/3/2+self.collecView.frame.size.width/3, self.imageView_head.frame.origin.y +self.imageView_head.frame.size.height);
        }else{
            return CGSizeMake(self.collecView.frame.size.width/3, self.imageView_head.frame.origin.y +self.imageView_head.frame.size.height);
        }
        
    }else{
        if (indexPath.row == 9) {
            return CGSizeMake(self.collecView.frame.size.width/21*3, self.collecView.frame.size.height);
        }else{
            return CGSizeMake(self.collecView.frame.size.width/21*2, self.collecView.frame.size.height);
        }
    }
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsZero;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    CGRect rectInTableView = [collectionView convertRect:cell.frame toView:collectionView];    
    CGRect rect = [collectionView convertRect:rectInTableView toView:[collectionView superview]];
    if (self.tabVCellBlock) {
        self.tabVCellBlock(self,rect,(int)indexPath.row);
    }

}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"contentOffset==%@",NSStringFromCGPoint(scrollView.contentOffset));

     NEWCell *cell = (NEWCell *)[self.collecView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.offSetRow inSection:0]];
    if (self.scrollDidEndCall) {
        self.scrollDidEndCall(cell,self.collecView);
    }
    
}





@end
