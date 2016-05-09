//
//  MXBorder.h
//
//  Created by eric on 16/5/9.
//  Copyright © 2016年 smartscreen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MXBorderAttributeProtocal <NSObject>

@property (nonatomic, readonly) NSObject<MXBorderAttributeProtocal> *(^mxb_color)(UIColor*);
@property (nonatomic, readonly) NSObject<MXBorderAttributeProtocal> *(^mxb_width)(CGFloat);
@property (nonatomic, readonly) NSObject<MXBorderAttributeProtocal> *(^mxb_start)(CGFloat);
@property (nonatomic, readonly) NSObject<MXBorderAttributeProtocal> *(^mxb_end)(CGFloat);

@end

@interface MXBorderAttribute : NSObject<MXBorderAttributeProtocal>

@end

@interface NSArray (MXBorder)<MXBorderAttributeProtocal>

@end

#pragma mark
#pragma mark === MXBorderMaker ===

@interface MXBorderMaker : UIView

typedef void (^MXBorderMakerBlock)(MXBorderMaker *maker);

@property (nonatomic, copy) UIColor *defaultColor;

@property (nonatomic, assign) CGFloat defaultWidth;

@property (nonatomic, readonly) MXBorderAttribute *top;
@property (nonatomic, readonly) MXBorderAttribute *left;
@property (nonatomic, readonly) MXBorderAttribute *bottom;
@property (nonatomic, readonly) MXBorderAttribute *right;

@property (nonatomic, readonly) NSArray *all;

@end

#pragma mark
#pragma mark === UIView+MXBorder ===

@interface UIView (MXBorder)

@property (nonatomic, readonly) MXBorderMaker *mx_borderMaker;

- (void)mx_removeBoarder;

- (void)mx_showBorder:(MXBorderMakerBlock)block;

@end