//
//  ViewController.m
//  ShareExtensionDemo
//
//  Created by Cain on 30/6/16.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *shareImage;

@end

@implementation ViewController

- (IBAction)popActivityController:(UIButton *)sender {
    
    [self shareContent:@"Highland Cow" image:self.shareImage.image];
}

- (void)shareContent:(NSString *)string image:(UIImage *)image {
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[string, image]
                                                                                     applicationActivities:nil];
    
    [self presentViewController:activityController
                       animated:YES
                     completion:nil];
}

@end
