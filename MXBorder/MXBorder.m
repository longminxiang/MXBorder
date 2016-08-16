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

- (NSObject<MXBorderAttributeProtocal> *(^)(UIColor *))mxb_color
{
    return ^MXBorderAttribute *(UIColor *color){
        self.borderColor = color;
        return self;
    };
}

- (NSObject<MXBorderAttributeProtocal> *(^)(CGFloat))mxb_width
{
    return ^MXBorderAttribute *(CGFloat width){
        self.borderWidth = width;
        return self;
    };
}

- (NSObject<MXBorderAttributeProtocal> *(^)(CGFloat))mxb_start
{
    return ^MXBorderAttribute *(CGFloat start){
        self.borderStart = start;
        return self;
    };
}

- (NSObject<MXBorderAttributeProtocal> *(^)(CGFloat))mxb_end
{
    return ^MXBorderAttribute *(CGFloat end){
        self.borderEnd = end;
        return self;
    };
}

- (NSObject<MXBorderAttributeProtocal> *(^)(CGPoint))mxb_dash
{
    return ^MXBorderAttribute *(CGPoint dash){
        self.dash = dash;
        return self;
    };
}

@end

@implementation NSArray (MXBorder)

- (NSObject<MXBorderAttributeProtocal> *(^)(UIColor *))mxb_color
{
    return ^NSArray *(UIColor *color){
        for (MXBorderAttribute *att in self) {
            if (![att isKindOfClass:[MXBorderAttribute class]]) continue;
            att.borderColor = color;
        }
        return self;
    };
}

- (NSObject<MXBorderAttributeProtocal> *(^)(CGFloat))mxb_width
{
    return ^NSArray *(CGFloat width){
        for (MXBorderAttribute *att in self) {
            if (![att isKindOfClass:[MXBorderAttribute class]]) continue;
            att.borderWidth = width;
        }
        return self;
    };
}

- (NSObject<MXBorderAttributeProtocal> *(^)(CGFloat))mxb_start
{
    return ^NSArray *(CGFloat start){
        for (MXBorderAttribute *att in self) {
            if (![att isKindOfClass:[MXBorderAttribute class]]) continue;
            att.borderStart = start;
        }
        return self;
    };
}

- (NSObject<MXBorderAttributeProtocal> *(^)(CGFloat))mxb_end
{
    return ^NSArray *(CGFloat end){
        for (MXBorderAttribute *att in self) {
            if (![att isKindOfClass:[MXBorderAttribute class]]) continue;
            att.borderEnd = end;
        }
        return self;
    };
}

- (NSObject<MXBorderAttributeProtocal> *(^)(CGPoint))mxb_dash
{
    return ^NSArray *(CGPoint dash){
        for (MXBorderAttribute *att in self) {
            if (![att isKindOfClass:[MXBorderAttribute class]]) continue;
            att.dash = dash;
        }
        return self;
    };
}

@end

@interface MXBorderMaker ()

@property (nonatomic, copy) UIColor *defaultColor;

@property (nonatomic, assign) CGFloat defaultWidth;

@end

@implementation MXBorderMaker
@synthesize top = _top, left = _left, bottom = _bottom, right = _right;
@synthesize all = _all;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.defaultColor = [UIColor blackColor];
        self.defaultWidth = 0.5;
    }
    return self;
}

- (MXBorderAttribute *)top
{
    if (!_top) {
        _top = [MXBorderAttribute new];
        _top.mxb_color(self.defaultColor).mxb_width(self.defaultWidth);
    }
    return _top;
}

- (MXBorderAttribute *)left
{
    if (!_left) {
        _left = [MXBorderAttribute new];
        _left.mxb_color(self.defaultColor).mxb_width(self.defaultWidth);
    }
    return _left;
}

- (MXBorderAttribute *)bottom
{
    if (!_bottom) {
        _bottom = [MXBorderAttribute new];
        _bottom.mxb_color(self.defaultColor).mxb_width(self.defaultWidth);
    }
    return _bottom;
}

- (MXBorderAttribute *)right
{
    if (!_right) {
        _right = [MXBorderAttribute new];
        _right.mxb_color(self.defaultColor).mxb_width(self.defaultWidth);
    }
    return _right;
}

- (NSArray *)all
{
    if (!_all) {
        _all = @[self.top, self.bottom, self.left, self.right];
    }
    return _all;
}

- (void)drawLineWithColor:(UIColor *)color width:(CGFloat)width rect:(CGRect)rect dash:(CGPoint)dash
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width * 2);
    CGContextSaveGState(context);
    if (!CGPointEqualToPoint(dash, CGPointZero)) {
        CGContextSetLineDash(context, 0, (CGFloat[]){dash.x, dash.y}, 2);
    }
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGSize size = self.bounds.size;
    
    if (_top) {
        MXBorderAttribute *att = _top;
        CGRect rect = CGRectMake(att.borderStart, 0, size.width - att.borderEnd, 0);
        [self drawLineWithColor:att.borderColor width:att.borderWidth rect:rect dash:att.dash];
    }
    if (_left) {
        MXBorderAttribute *att = _left;
        CGRect rect = CGRectMake(0, att.borderStart, 0, size.height - att.borderEnd);
        [self drawLineWithColor:att.borderColor width:att.borderWidth rect:rect dash:CGPointMake(att.dash.y, att.dash.x)];
    }
    if (_bottom) {
        MXBorderAttribute *att = _bottom;
        CGRect rect = CGRectMake(att.borderStart, size.height, size.width - att.borderEnd, size.height);
        [self drawLineWithColor:att.borderColor width:att.borderWidth rect:rect dash:att.dash];
    }
    if (_right) {
        MXBorderAttribute *att = _right;
        CGRect rect = CGRectMake(size.width, att.borderStart, size.width, size.height - att.borderEnd);
        [self drawLineWithColor:att.borderColor width:att.borderWidth rect:rect dash:CGPointMake(att.dash.y, att.dash.x)];
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
    self.mx_borderMaker.hidden = YES;
    [self.mx_borderMaker removeFromSuperview];
    self.mx_borderMaker = nil;
}

- (void)mx_showBorder:(MXBorderMakerBlock)block
{
    [self mx_removeBoarder];
    MXBorderMaker *maker = [[MXBorderMaker alloc] initWithFrame:self.bounds];
    maker.autoresizingMask = 1|2|4|8|16|32;
    if (block) block(maker);
    [self addSubview:maker];
    self.mx_borderMaker = maker;
}

@end
