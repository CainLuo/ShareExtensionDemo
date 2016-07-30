//
//  ShareViewController.m
//  ShareExtension
//
//  Created by Cain on 30/6/16.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ShareViewController ()

@property (nonatomic, strong) UIImage *attachedImage;

@end

static NSInteger const maxCharactersAllowed = 40;
static NSString *uploadURL = @"http://requestb.in/1hx20w61";

@implementation ShareViewController

/**
 *  检测文本框的内容变化, 和UITextView或UITextField的代理方法有些类似, 但这个是用来控制右上角是否可分享的按钮
 *
 *  @return BOOL
 */
- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    
//    self.placeholder = @"这是一个测试数据";
    
    NSInteger length = self.contentText.length;
    
    self.charactersRemaining = @(maxCharactersAllowed - length);
    
    return self.charactersRemaining.integerValue < 0 ? NO : YES;
}

/**
 *  点击发送
 */
- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    NSString *configName = @"com.demoProject.ShareExtensionDemo.ShareExtension.BackgroundSessionConfig";
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:configName];
    
    sessionConfig.sharedContainerIdentifier = @"group.ShareExtensionGroup";
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSURLRequest *urlRequest = [self urlRequestWithImage:self.attachedImage text:self.contentText];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:urlRequest];
    
    [task resume];
    
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

/**
 *  返回一个URL请求
 *
 *  @param image 需要上传的Image
 *  @param text  需要上传的Text
 *
 *  @return NSURLRequest
 */
- (NSURLRequest *)urlRequestWithImage:(UIImage *)image text:(NSString *)text {
    
    NSURL *url = [NSURL fileURLWithPath:uploadURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *jsonObject = [NSMutableDictionary dictionary];
    
    jsonObject[@"text"] = text;
    
    if (image) {
        
        jsonObject[@"image_details"] = [self extractDatalsFromImage:image];
    }
    
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

- (NSDictionary *)extractDatalsFromImage:(UIImage *)image {

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    dictionary[@"height"]      = @(image.size.height);
    dictionary[@"width"]       = @(image.size.width);
    dictionary[@"orientation"] = @(image.imageOrientation);
    dictionary[@"scale"]       = @(image.scale);
    dictionary[@"description"] = image.description;
    
    return dictionary;
}

/**
 *  点击取消
 */
- (void)didSelectCancel {
    
    NSLog(@"点击取消");
    
    NSError *error =[[NSError alloc] init];
    
    [self.extensionContext cancelRequestWithError:error];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

/**
 *  当你选择分享的图片展示完的时候就会调用
 */
- (void)presentationAnimationDidFinish {
    
    NSExtensionItem *extensionItem = self.extensionContext.inputItems[0];
    
    [self imagefromExtensionItem:extensionItem callBack:^(UIImage *image) {
        
        if (image) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.attachedImage = image;
            });
        }
    }];
}

- (void)imagefromExtensionItem:(NSExtensionItem *)item callBack:(void (^)(UIImage *image))callBackImage{
    
    for (NSItemProvider *attachment in item.attachments) {
        
        if ([attachment hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [attachment loadItemForTypeIdentifier:(NSString *)kUTTypeImage
                                              options:nil
                                    completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                                        
                                        UIImage *image = nil;
                                        
                                        if (error) {
                                            
                                            NSLog(@"Item loading error: %@", error);
                                        }
                                        
                                        image = (UIImage *)item;
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            callBackImage(image);
                                        });
                                    }];
            });
        }
    }
}

@end
