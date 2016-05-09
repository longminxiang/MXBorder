//
//  ViewController.m
//  BorderTest
//
//  Created by longminxiang on 16/4/19.
//  Copyright © 2016年 smartscreen. All rights reserved.
//

#import "ViewController.h"
#import "MXBorder.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITextField *nameField, *passwordField;

@property (nonatomic, weak) IBOutlet UILabel *label1, *label2, *label3;

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
    [self.nameField mx_showBorder:^(MXBorderMaker *maker) {
        maker.bottom.mxb_width(0.5).mxb_color([UIColor colorWithWhite:0 alpha:0.1]);
    }];
    
    [self.passwordField mx_showBorder:^(MXBorderMaker *maker) {
        maker.bottom.mxb_width(0.5).mxb_color([UIColor colorWithWhite:0 alpha:0.1]);
    }];
    
    [self.label1 mx_showBorder:^(MXBorderMaker *maker) {
        @[maker.top, maker.bottom].mxb_color([UIColor orangeColor]).mxb_width(0.25).mxb_start(10);
    }];
    
    [self.label2 mx_showBorder:^(MXBorderMaker *maker) {
        maker.all.mxb_color([UIColor orangeColor]).mxb_width(0.25);
        maker.left.mxb_start(8).mxb_end(8);
        maker.right.mxb_start(8).mxb_end(8);
    }];
    
    [self.label3 mx_showBorder:^(MXBorderMaker *maker) {
        @[maker.top, maker.bottom].mxb_color([UIColor orangeColor]).mxb_width(0.25).mxb_end(10);
    }];
    
    [self.label4 mx_showBorder:^(MXBorderMaker *maker) {
        maker.all.mxb_color([UIColor brownColor]).mxb_width(5);
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
        maker.all.mxb_width(20).mxb_color([UIColor brownColor]);
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
