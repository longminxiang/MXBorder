//
//  UIView+MXBorderHooker.m
//  MXBorderDemo
//
//  Created by eric on 16/5/9.
//  Copyright © 2016年 smartscreen. All rights reserved.
//

#import "UIView+MXBorderHooker.h"
#import "MXBorder.h"
#import <objc/runtime.h>

void mxborder_hook_class_swizzleMethodAndStore(Class class, SEL originalSelector, SEL swizzledSelector)
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

@implementation UIView (MXBorderHooker)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mxborder_hook_class_swizzleMethodAndStore(self, @selector(layoutSubviews), @selector(mxborder_uiview_layoutSubviews));
    });
}

- (void)mxborder_uiview_layoutSubviews
{
    [self mxborder_uiview_layoutSubviews];
    if (self.mx_borderMaker) {
        [self bringSubviewToFront: self.mx_borderMaker];
        [self.mx_borderMaker setNeedsDisplay];
    }
}

@end

@implementation UILabel (MXBorder)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mxborder_hook_class_swizzleMethodAndStore(self, @selector(drawTextInRect:), @selector(mxborder_uilabel_drawTextInRect:));
    });
}

- (void)mxborder_uilabel_drawTextInRect:(CGRect)rect
{
    [self mxborder_uilabel_drawTextInRect:rect];
    if (self.mx_borderMaker) {
        [self bringSubviewToFront:self.mx_borderMaker];
    }
}

@end