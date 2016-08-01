//
//  ShareViewController.m
//  ShareExtension
//
//  Created by Cain on 31/7/16.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ShareViewController ()

@end

// 限制字数, 最多只能输入40个
static NSInteger const maxCharactersAllowed = 40;
// 这是一个测试连接, 并不是固定的, 你可以去http://requestb.in申请, 然后替换到你最新申请的连接即可
static NSString *uploadURL = @"http://requestb.in/1hx20w61";

@implementation ShareViewController

- (BOOL)isContentValid {
    
    NSInteger length = self.contentText.length;
    
    self.charactersRemaining = @(maxCharactersAllowed - length);
    
    return self.charactersRemaining.integerValue < 0 ? NO : YES;
}

- (void)didSelectPost {

    NSString *configName = @"com.shareExtension.ShareExtensionDemo.BackgroundSessionConfig";

    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:configName];
    
    sessionConfig.sharedContainerIdentifier = @"group.ShareExtension";
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSURLRequest *urlRequest = [self urlRequestWithString:self.contentText];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:urlRequest];
    
    [task resume];
    
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

/**
 *  返回一个NSURLRequest方法, 需要传入一个NSString对象
 *
 *  @param string 需要发送出去的字符串
 *
 *  @return NSURLRequest
 */
- (NSURLRequest *)urlRequestWithString:(NSString *)string {
    
    NSURL *url = [NSURL URLWithString:uploadURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *jsonObject = [NSMutableDictionary dictionary];
    
    jsonObject[@"text"] = string;
    
    NSError *jsonError;
    NSData *jsonData;
    
    jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    if (jsonData) {
        
        request.HTTPBody = jsonData;
    } else {
        
        NSLog(@"JSON Error: %@", jsonError.localizedDescription);
    }
    
    return request;
}

- (NSArray *)configurationItems {
    
    return @[];
}

@end
