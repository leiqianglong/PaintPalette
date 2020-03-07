//
//  PPImageView.m
//  PaintPalette
//
//  Created by LQL on 2019/8/1.
//  Copyright © 2019 com.lal. All rights reserved.
//

#import "PPImageView.h"

@implementation PPImageView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
      if (touches.count == 1)//单指操作
      {
          UITouch *touch = [touches anyObject];
          CGPoint point = [touch preciseLocationInView:self];
          if (![self pointInside:point withEvent:event]) {
              NSLog(@"点远了");
              return;
          }
          NSLog(@"%@",NSStringFromCGPoint(point));
          
          
          if ([self.delegate respondsToSelector:@selector(touches:)]) {
              [self.delegate touches:point];
          }
      }
    
   
}
@end
