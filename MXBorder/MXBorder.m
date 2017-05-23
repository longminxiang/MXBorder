//
//  MXBorder.m
//
//  Created by eric on 16/5/9.
//  Copyright © 2016年 smartscreen. All rights reserved.
//

#import "MXBorder.h"
#import <objc/runtime.h>

@interface MXBorderAttribute : NSObject

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat borderStart;
@property (nonatomic, assign) CGFloat borderEnd;

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

@end


@interface MXBorder ()

@property (nonatomic, strong) MXBorderAttribute *topAttribute;
@property (nonatomic, strong) MXBorderAttribute *leftAttribute;
@property (nonatomic, strong) MXBorderAttribute *bottomAttribute;
@property (nonatomic, strong) MXBorderAttribute *rightAttribute;

@property (nonatomic, strong) NSMutableArray *attributes;

@property (nonatomic, assign) BOOL inAttbutite;

@end

@implementation MXBorder

- (NSMutableArray *)attributes
{
    if (!_attributes) {
        _attributes = [NSMutableArray new];
    }
    return _attributes;
}

#define _MIX_EDGE(__att, __name) \
- (MXBorder *)__name \
{ \
    if (!__att) { \
        __att = [MXBorderAttribute new]; \
    } \
    if (self.inAttbutite) { \
        [self.attributes removeAllObjects]; \
        self.inAttbutite = NO; \
    } \
    if (![self.attributes containsObject:__att]) { \
        [self.attributes addObject:__att]; \
    } \
    return self; \
}

_MIX_EDGE(_topAttribute, top)
_MIX_EDGE(_leftAttribute, left)
_MIX_EDGE(_bottomAttribute, bottom)
_MIX_EDGE(_rightAttribute, right)

#define _MIX_ATTRIBUTE(__att, __class, __name) \
- (MXBorder *(^)(__class))__name \
{ \
    self.inAttbutite = YES; \
    return ^MXBorder *(__class __name) { \
        for (MXBorderAttribute *att in self.attributes) { \
            att.__att = __name; \
        } \
        return self; \
    }; \
}

_MIX_ATTRIBUTE(borderColor, UIColor*, color)
_MIX_ATTRIBUTE(borderWidth, CGFloat, width)
_MIX_ATTRIBUTE(borderStart, CGFloat, start)
_MIX_ATTRIBUTE(borderEnd, CGFloat, end)

- (void)drawLineWithColor:(UIColor *)color width:(CGFloat)width rect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    CGContextRestoreGState(context); 
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGSize size = rect.size;
    if (_topAttribute) {
        MXBorderAttribute *att = _topAttribute;
        CGRect rect = CGRectMake(att.borderStart, 0, size.width - att.borderEnd, 0);
        [self drawLineWithColor:att.borderColor width:att.borderWidth rect:rect];
    }
    if (_leftAttribute) {
        MXBorderAttribute *att = _leftAttribute;
        CGRect rect = CGRectMake(0, att.borderStart, 0, size.height - att.borderEnd);
        [self drawLineWithColor:att.borderColor width:att.borderWidth rect:rect];
    }
    if (_bottomAttribute) {
        MXBorderAttribute *att = _bottomAttribute;
        CGRect rect = CGRectMake(att.borderStart, size.height, size.width - att.borderEnd, size.height);
        [self drawLineWithColor:att.borderColor width:att.borderWidth rect:rect];
    }
    if (_rightAttribute) {
        MXBorderAttribute *att = _rightAttribute;
        CGRect rect = CGRectMake(size.width, att.borderStart, size.width, size.height - att.borderEnd);
        [self drawLineWithColor:att.borderColor width:att.borderWidth rect:rect];
    }
}

@end

void mixborder_hook_class_swizzleMethodAndStore(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UIView (MXBorder)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mixborder_hook_class_swizzleMethodAndStore(self, @selector(layoutSubviews), @selector(mixborder_uiview_layoutSubviews));
    });
}

- (void)mixborder_uiview_layoutSubviews
{
    [self mixborder_uiview_layoutSubviews];
    [self bringSubviewToFront:self.mix_border];
    [self.mix_border setNeedsDisplay];
}

- (MXBorder *)mix_border
{
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj;
}

- (void)setMix_border:(MXBorder * _Nullable)mix_border
{
    objc_setAssociatedObject(self, @selector(mix_border), mix_border, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mix_removeBorder
{
    [self.mix_border removeFromSuperview];
    self.mix_border = nil;
}

- (void)mix_makeBorder:(MXBorderBlock)block
{
    [self mix_removeBorder];
    MXBorder *maker = [MXBorder new];
    maker.backgroundColor = [UIColor clearColor];
    [self addSubview:maker];
    maker.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:maker attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:maker attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:maker attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:maker attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [NSLayoutConstraint activateConstraints:@[constraint, constraint1, constraint2, constraint3]];
    if (block) block(maker);
    self.mix_border = maker;
}

@end
