//
//  PPImageView.h
//  PaintPalette
//
//  Created by LQL on 2019/8/1.
//  Copyright © 2019 com.lal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PPImageViewDelegate <NSObject>
@required
- (void)touches:(CGPoint)point;
@end
@interface PPImageView : UIImageView
@property(nonatomic,weak)id <PPImageViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
