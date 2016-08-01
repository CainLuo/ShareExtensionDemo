//
//  ViewController.m
//  ShareExtensionDemo
//
//  Created by Cain on 31/7/16.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)ShareAction:(UIButton *)sender {
    
    NSString *string = @"您好";
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[string]
                                                                                     applicationActivities:nil];
    
    [self presentViewController:activityController
                       animated:YES
                     completion:nil];
}

@end
