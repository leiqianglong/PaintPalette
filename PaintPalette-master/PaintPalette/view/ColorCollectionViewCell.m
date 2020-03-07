//
//  ColorCollectionViewCell.m
//  PaintPalette
//
//  Created by LQL on 2019/8/1.
//  Copyright © 2019 com.lal. All rights reserved.
//

#import "ColorCollectionViewCell.h"

@implementation ColorCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width,self.frame.size.height)];
    self.bgView.layer.cornerRadius = self.frame.size.width * 0.5;
    self.bgView.layer.masksToBounds = YES;
    [self addSubview:self.bgView];
    CGFloat itemSize = 16;
    CGFloat itemXY = (self.frame.size.width-itemSize) * 0.5;
    self.flgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(itemXY, itemXY, itemSize, itemSize )];
    self.flgImageView.image = [UIImage imageNamed:@"wujiaoxing"];
    [self.bgView addSubview:self.flgImageView];
    
}
@end
