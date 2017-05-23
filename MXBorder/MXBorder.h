//
//  MXBorder.h
//
//  Created by eric on 16/5/9.
//  Copyright © 2016年 smartscreen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXBorderAttribute : NSObject

@property (nonatomic, readonly) MXBorderAttribute *(^color)(UIColor*);
@property (nonatomic, readonly) MXBorderAttribute *(^width)(CGFloat);
@property (nonatomic, readonly) MXBorderAttribute *(^start)(CGFloat);
@property (nonatomic, readonly) MXBorderAttribute *(^end)(CGFloat);

@end

#pragma mark
#pragma mark === MXBorderMaker ===

@interface MXBorderMaker : NSObject

typedef void (^MXBorderMakerBlock)(MXBorderMaker *maker);

@property (nonatomic, readonly) MXBorderAttribute *top;
@property (nonatomic, readonly) MXBorderAttribute *left;
@property (nonatomic, readonly) MXBorderAttribute *bottom;
@property (nonatomic, readonly) MXBorderAttribute *right;

- (void)drawInSize:(CGSize)size context:(CGContextRef)context;

@end

#pragma mark
#pragma mark === UIView+MXBorder ===

@interface UIView (MXBorder)

@property (nonatomic, readonly) MXBorderMaker *mx_borderMaker;

- (void)mx_removeBoarder;

- (void)mx_showBorder:(MXBorderMakerBlock)block;

@end
