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

@property (nonatomic, weak) IBOutlet UILabel *label1, *label2;
@property (nonatomic, weak) IBOutlet UILabel *label3;

@property (nonatomic, weak) IBOutlet UILabel *label4;

@property (nonatomic, weak) IBOutlet UILabel *label5;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *label4Leading;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *label4Trailing;

@property (nonatomic, weak) IBOutlet UIView *testView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *testViewEqualWidth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.nameField mix_makeBorder:^(MXBorder *border) {
        border.bottom.color([UIColor lightGrayColor]).begin(-20).end(-20);
    }];
    
    [self.passwordField mix_makeBorder:^(MXBorder *border) {
        border.bottom.color([UIColor lightGrayColor]).begin(-20).end(-20);
    }];
    
    [self.label1 mix_makeBorder:^(MXBorder *border) {
        border.top.bottom.color([UIColor blueColor]).width(1);
    }];
    
    [self.label2 mix_makeBorder:^(MXBorder *border) {
        border.top.bottom.left.right.color([UIColor blueColor]).width(1);
    }];
    
    [self.label3 mix_makeBorder:^(MXBorder *border) {
        border.top.bottom.color([UIColor blueColor]).width(1);
    }];
    
    [self.label4 mix_makeBorder:^(MXBorder *border) {
        border.top.bottom.left.right.width(5).color([UIColor brownColor]);
    }];
    
    [self.label5 mix_makeBorder:^(MXBorder *border) {
        border.top.bottom.left.right.color([UIColor brownColor]);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect frame = self.label4.frame;
        frame.size.width = self.view.frame.size.width - 80 - 80;
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.label4Leading.constant = 80;
            self.label4Trailing.constant = -80;
            self.label4.frame = frame;
        } completion:nil];
        self.label5.text = @"uedkikckcclclclcspssp";
    });
    
    [self.testView mix_makeBorder:^(MXBorder *border) {
        border.top.bottom.left.right.width(5).color([UIColor brownColor]);
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.testViewEqualWidth.constant = 200;
        self.label3.text = @"ccckdd";
        self.label1.text = @"ddddww";
        self.label2.text = @"deeeeeeeeeee";
        self.label5.text = @"ccccccccc\ncccccccc";
    });
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
