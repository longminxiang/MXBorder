//
//  MXBorder.m
//
//  Created by eric on 16/5/9.
//  Copyright © 2016年 smartscreen. All rights reserved.
//

#import "MXBorder.h"
#import <objc/runtime.h>

@interface MXBorderAttribute ()

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat borderStart;
@property (nonatomic, assign) CGFloat borderEnd;

@property (nonatomic, assign) CGPoint dash;

@end

@implementation MXBorderAttribute

- (instancetype)init
{
    if (self = [super init]) {
        self.borderColor = [UIColor blackColor];
        self.borderWidth = 0.5;
    }
    return self;
}

- (MXBorderAttribute *(^)(UIColor *))color
{
    return ^MXBorderAttribute *(UIColor *color){
        self.borderColor = color;
        return self;
    };
}

- (MXBorderAttribute *(^)(CGFloat))width
{
    return ^MXBorderAttribute *(CGFloat width){
        self.borderWidth = width;
        return self;
    };
}

- (MXBorderAttribute *(^)(CGFloat))start
{
    return ^MXBorderAttribute *(CGFloat start){
        self.borderStart = start;
        return self;
    };
}

- (MXBorderAttribute *(^)(CGFloat))end
{
    return ^MXBorderAttribute *(CGFloat end){
        self.borderEnd = end;
        return self;
    };
}

@end

@interface MXBorderMaker ()

@end

@implementation MXBorderMaker
@synthesize top = _top, left = _left, bottom = _bottom, right = _right;

- (MXBorderAttribute *)top
{
    if (!_top) {
        _top = [MXBorderAttribute new];
    }
    return _top;
}

- (MXBorderAttribute *)left
{
    if (!_left) {
        _left = [MXBorderAttribute new];
    }
    return _left;
}

- (MXBorderAttribute *)bottom
{
    if (!_bottom) {
        _bottom = [MXBorderAttribute new];
    }
    return _bottom;
}

- (MXBorderAttribute *)right
{
    if (!_right) {
        _right = [MXBorderAttribute new];
    }
    return _right;
}

- (void)drawLineWithColor:(UIColor *)color width:(CGFloat)width rect:(CGRect)rect context:(CGContextRef)context
{
//    if (!context) {
        context = UIGraphicsGetCurrentContext();
//    }
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width * 2);
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
//    CGContextClosePath(context);
    CGContextStrokePath(context);
//    CGContextRestoreGState(context); 
}

- (void)drawInSize:(CGSize)size context:(CGContextRef)context
{
    if (_top) {
        MXBorderAttribute *att = _top;
        CGRect rect = CGRectMake(att.borderStart, 0, size.width - att.borderEnd, 0);
        [self drawLineWithColor:att.borderColor width:att.borderWidth rect:rect context:context];
    }
    if (_left) {
        MXBorderAttribute *att = _left;
        CGRect rect = CGRectMake(0, att.borderStart, 0, size.height - att.borderEnd);
        [self drawLineWithColor:att.borderColor width:att.borderWidth rect:rect context:context];
    }
    if (_bottom) {
        MXBorderAttribute *att = _bottom;
        CGRect rect = CGRectMake(att.borderStart, size.height, size.width - att.borderEnd, size.height);
        [self drawLineWithColor:att.borderColor width:att.borderWidth rect:rect context:context];
    }
    if (_right) {
        MXBorderAttribute *att = _right;
        CGRect rect = CGRectMake(size.width, att.borderStart, size.width, size.height - att.borderEnd);
        [self drawLineWithColor:att.borderColor width:att.borderWidth rect:rect context:context];
    }
}

@end

@implementation UIView (MXBorder)

- (MXBorderMaker *)mx_borderMaker
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj;
}

- (void)setMx_borderMaker:(MXBorderMaker *)mx_borderMaker
{
    objc_setAssociatedObject(self, @selector(mx_borderMaker), mx_borderMaker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mx_removeBoarder
{
    self.mx_borderMaker = nil;
}

- (void)mx_showBorder:(MXBorderMakerBlock)block
{
    [self mx_removeBoarder];
    MXBorderMaker *maker = [MXBorderMaker new];
    if (block) block(maker);
    self.mx_borderMaker = maker;
    [self setNeedsDisplay];
}

@end
