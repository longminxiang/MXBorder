//
//  ViewController.m
//  BorderTest
//
//  Created by longminxiang on 16/4/19.
//  Copyright © 2016年 smartscreen. All rights reserved.
//

#import "ViewController.h"
#import "MXBorder.h"

@interface ViewController ()<CALayerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *nameField, *passwordField;

@property (nonatomic, weak) IBOutlet UILabel *label1, *label2;
@property (nonatomic, weak) IBOutlet UILabel *label3;

@property (nonatomic, weak) IBOutlet UILabel *label4;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *label4Leading;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *label4Trailing;

@property (nonatomic, weak) IBOutlet UIView *testView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *testViewEqualWidth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.nameField.layer.allowsEdgeAntialiasing = YES;
//    self.nameField.layer.borderColor = [UIColor blueColor].CGColor;
//    self.nameField.layer.borderWidth = 1;
//    self.nameField.layer.edgeAntialiasingMask = kCALayerBottomEdge | kCALayerTopEdge;
    
    [self.nameField mx_showBorder:^(MXBorderMaker *maker) {
        maker.bottom.width(0.5).color([UIColor blueColor]);
    }];
    
    [self.passwordField mx_showBorder:^(MXBorderMaker *maker) {
        maker.bottom.width(0.5).color([UIColor blackColor]);
    }];
    
    [self.label1 mx_showBorder:^(MXBorderMaker *maker) {
        maker.left.start(8).end(8);
        maker.right.start(8).end(8);
        maker.right.color([UIColor blueColor]).width(2).end(10);
        maker.bottom.color([UIColor grayColor]).width(3).end(10);
    }];
    
    [self.label2 mx_showBorder:^(MXBorderMaker *maker) {
        maker.left.start(8).end(8);
        maker.right.start(8).end(8);
        maker.right.color([UIColor blueColor]).width(2).end(10);
        maker.bottom.color([UIColor grayColor]).width(3).end(10);
    }];
    
    [self.label3 mx_showBorder:^(MXBorderMaker *maker) {
        maker.top.color([UIColor orangeColor]).width(0.25).end(10);
        maker.right.color([UIColor blueColor]).width(2).end(10);
        maker.bottom.color([UIColor grayColor]).width(3).end(10);
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect frame = self.label4.frame;
        frame.size.width = self.view.frame.size.width - 80 - 80;
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.label4Leading.constant = 80;
            self.label4Trailing.constant = -80;
            self.label4.frame = frame;
        } completion:nil];
    });
    
    [self.testView mx_showBorder:^(MXBorderMaker *maker) {
        maker.top.width(0.5).color([UIColor brownColor]);
    }];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
