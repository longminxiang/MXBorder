//
//  MXBorder.h
//
//  Created by eric on 16/5/9.
//  Copyright © 2016年 smartscreen. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark
#pragma mark === MXBorder ===

@interface MXBorder : UIView

@property (nonatomic, readonly, nonnull) MXBorder *top;
@property (nonatomic, readonly, nonnull) MXBorder *left;
@property (nonatomic, readonly, nonnull) MXBorder *bottom;
@property (nonatomic, readonly, nonnull) MXBorder *right;

@property (nonatomic, readonly, nonnull) MXBorder* _Nonnull (^color)(UIColor * _Nullable);
@property (nonatomic, readonly, nonnull) MXBorder* _Nonnull (^width)(CGFloat);
@property (nonatomic, readonly, nonnull) MXBorder* _Nonnull (^start)(CGFloat);
@property (nonatomic, readonly, nonnull) MXBorder* _Nonnull (^end)(CGFloat);

@end

#pragma mark
#pragma mark === UIView+MXBorder ===

@interface UIView (MXBorder)

typedef void (^MXBorderBlock)(MXBorder * _Nonnull border);

@property (nonatomic, readonly, nullable) MXBorder *mix_border;

- (void)mix_removeBorder;

- (void)mix_makeBorder:(MXBorderBlock _Nonnull )block;

@end
