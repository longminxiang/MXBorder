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
//
//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        mxborder_hook_class_swizzleMethodAndStore(self, @selector(drawLayer:inContext:), @selector(mxborder_uiview_drawLayer:inContext:));
//    });
//}
//
//- (void)mxborder_uiview_drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//{
//    [self mxborder_uiview_drawLayer:layer inContext:ctx];
//    NSLog(@"ccccccccc");
//}

@end

@implementation UILabel (MXBorder)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mxborder_hook_class_swizzleMethodAndStore(self, @selector(drawTextInRect:), @selector(mxborder_uilabel_drawTextInRect:));
        mxborder_hook_class_swizzleMethodAndStore(self, @selector(drawRect:), @selector(mxborder_uilabel_drawRect:));
    });
}

- (void)mxborder_uilabel_drawTextInRect:(CGRect)rect
{
    [self mxborder_uilabel_drawTextInRect:rect];
}

- (void)mxborder_uilabel_drawRect:(CGRect)rect
{
    [self.mx_borderMaker drawInSize:rect.size context:nil];
    [self mxborder_uilabel_drawRect:rect];
}

@end

@implementation UITextField (MXBorder)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mxborder_hook_class_swizzleMethodAndStore(self, @selector(drawRect:), @selector(mxborder_uilabel_drawRect:));
    });
}

- (void)mxborder_uilabel_drawRect:(CGRect)rect
{
    [self.mx_borderMaker drawInSize:rect.size context:nil];
    [self mxborder_uilabel_drawRect:rect];
}

@end
