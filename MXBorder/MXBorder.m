//
//  MXBorder.m
//
//  Created by eric on 16/5/9.
//  Copyright © 2016年 smartscreen. All rights reserved.
//

#import "MXBorder.h"
#import <objc/runtime.h>

@interface MXBorderAttribute : NSObject

@property (nonatomic, copy) UIColor *color;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat begin;
@property (nonatomic, assign) CGFloat end;

@end

@implementation MXBorderAttribute

- (instancetype)init
{
    if (self = [super init]) {
        self.color = [UIColor blackColor];
        self.width = 0.5;
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

@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *leftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *rightConstraint;

@end

@implementation MXBorder

- (instancetype)initWithSuperview:(UIView *)superview
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [superview addSubview:self];
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:superview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:superview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:superview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [superview addConstraints:@[constraint, constraint1, constraint2, constraint3]];
        self.topConstraint = constraint;
        self.bottomConstraint = constraint1;
        self.leftConstraint = constraint2;
        self.rightConstraint = constraint3;
    }
    return self;
}

- (NSMutableArray *)attributes
{
    if (!_attributes) {
        _attributes = [NSMutableArray new];
    }
    return _attributes;
}

#define _MIX_EDGE_ATTRIBUTE(__name) \
- (MXBorderAttribute *)__name \
{ \
    if (!_##__name) { \
        _##__name = [MXBorderAttribute new]; \
    } \
    return _##__name; \
}

_MIX_EDGE_ATTRIBUTE(topAttribute)
_MIX_EDGE_ATTRIBUTE(leftAttribute)
_MIX_EDGE_ATTRIBUTE(bottomAttribute)
_MIX_EDGE_ATTRIBUTE(rightAttribute)

#define _MIX_EDGE(__name) \
- (MXBorder *)__name \
{ \
    if (self.inAttbutite) { \
        [self.attributes removeAllObjects]; \
        self.inAttbutite = NO; \
    } \
    if (![self.attributes containsObject:self.__name##Attribute]) { \
        [self.attributes addObject:self.__name##Attribute]; \
    } \
    return self; \
}

_MIX_EDGE(top)
_MIX_EDGE(left)
_MIX_EDGE(bottom)
_MIX_EDGE(right)

#define _MIX_ATTRIBUTE(__class, __att) \
- (MXBorder *(^)(__class))__att \
{ \
    self.inAttbutite = YES; \
    return ^MXBorder *(__class __att) { \
        for (MXBorderAttribute *att in self.attributes) { \
            att.__att = __att; \
        } \
        return self; \
    }; \
}

_MIX_ATTRIBUTE(UIColor *, color)
_MIX_ATTRIBUTE(CGFloat, width)
_MIX_ATTRIBUTE(CGFloat, begin)
_MIX_ATTRIBUTE(CGFloat, end)

- (MXBorder *(^)(CGPoint))offset
{
    self.inAttbutite = YES;
    return ^MXBorder* (CGPoint offset) {
        for (MXBorderAttribute *att in self.attributes) {
            att.begin = offset.x;
            att.end = offset.y;
        }
        return self;
    };
}

- (void)drawLineWithColor:(UIColor *)color width:(CGFloat)width beginPoint:(CGPoint)beginPoint endPoint:(CGPoint)endPoint
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, beginPoint.x, beginPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    CGContextRestoreGState(context); 
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (_topAttribute) {
        self.leftConstraint.constant = MAX(self.leftConstraint.constant, -_topAttribute.begin);
        self.rightConstraint.constant = MIN(self.rightConstraint.constant, _topAttribute.end);
    }
    if (_leftAttribute) {
        self.topConstraint.constant = MAX(self.topConstraint.constant, -_leftAttribute.begin);
        self.bottomConstraint.constant = MIN(self.bottomConstraint.constant, _leftAttribute.end);
    }
    if (_bottomAttribute) {
        self.leftConstraint.constant = MAX(self.leftConstraint.constant, -_bottomAttribute.begin);
        self.rightConstraint.constant = MIN(self.rightConstraint.constant, _bottomAttribute.end);
    }
    if (_rightAttribute) {
        self.topConstraint.constant = MAX(self.topConstraint.constant, -_rightAttribute.begin);
        self.bottomConstraint.constant = MIN(self.bottomConstraint.constant, _rightAttribute.end);
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = self.bounds.size;
    
    CGFloat top = ABS(self.topConstraint.constant);
    CGFloat left = ABS(self.leftConstraint.constant);
    CGFloat bottom = ABS(self.bottomConstraint.constant);
    CGFloat right = ABS(self.rightConstraint.constant);
    
    if (_topAttribute) {
        MXBorderAttribute *att = _topAttribute;
        CGFloat bwidth = att.width / 2;
        CGPoint begin = CGPointMake(att.begin + left, bwidth + top);
        CGPoint end = CGPointMake(size.width - att.end - right, bwidth + top);
        [self drawLineWithColor:att.color width:att.width beginPoint:begin endPoint:end];
    }
    if (_leftAttribute) {
        MXBorderAttribute *att = _leftAttribute;
        CGFloat bwidth = att.width / 2;
        CGPoint begin = CGPointMake(bwidth + left, att.begin + top);
        CGPoint end = CGPointMake(bwidth + left, size.height - att.end - bottom);
        [self drawLineWithColor:att.color width:att.width beginPoint:begin endPoint:end];
    }
    if (_bottomAttribute) {
        MXBorderAttribute *att = _bottomAttribute;
        CGFloat bwidth = att.width / 2;
        CGPoint begin = CGPointMake(att.begin + left, size.height - bwidth - bottom);
        CGPoint end = CGPointMake(size.width - att.end - right, size.height - bwidth - bottom);
        [self drawLineWithColor:att.color width:att.width beginPoint:begin endPoint:end];
    }
    if (_rightAttribute) {
        MXBorderAttribute *att = _rightAttribute;
        CGFloat bwidth = att.width / 2;
        CGPoint begin = CGPointMake(size.width - bwidth - right, att.begin + top);
        CGPoint end = CGPointMake(size.width - bwidth - right, size.height - att.end - bottom);
        [self drawLineWithColor:att.color width:att.width beginPoint:begin endPoint:end];
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
    MXBorder *maker = [[MXBorder alloc] initWithSuperview:self];
    if (block) block(maker);
    self.mix_border = maker;
}

@end
