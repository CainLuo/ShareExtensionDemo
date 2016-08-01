#<p align=“center”>玩转iOS开发：iOS 8 新特性《Share Extension》</p>

- [作者感言](#作者感言)
- [简介](#简介)
- [创建新工程](#创建新工程)
- [创建Share Extension](#创建Share Extension)
- [配置主应用](#配置主应用)
- [配置Share Extension](#配置Share Extension)
- [配置NSExtension](#配置NSExtension)
- [Share Extension逻辑](#Share Extension逻辑)
	- [填写限制字数长度的逻辑](#填写限制字数长度的逻辑)
	- [填写上传信息的逻辑](#填写上传信息的逻辑)
	- [自定义UI](#自定义UI)
- [补充篇文章](#补充篇文章)

---

### 作者感言

> 在前阵子我写了另外一篇文章也是关于iOS 8新特性的, 叫做**[玩转iOS开发：iOS 8 新特性《Today Extension》](https://github.com/CainRun/TodayExtensionExample/blob/master/README.md)**, 这里面讲解就是iOS 8其中一个特性, 由于工作比较忙, 所以一直在拖着, 没有继续往下研究, 现在终于有时间抽出来可以研究一下
> 
 > **<font color=purple>最后:</font>**
> **<font color=purple>如果你有更好的建议或者对这篇文章有不满的地方, 请联系我, 我会参考你们的意见再进行修改, 联系我时, 请备注`Share Extension`, 祝大家学习愉快~谢谢~</font>**

<p align="right">Cain(罗家辉)</p>
<p align="right">zhebushimengfei@qq.com: 联系方式</p>
<p align="right">350116542: 腾讯QQ</p>

---
### 简介
> 什么是**`Share Extension`**? 在iOS 8的时候, 苹果开放了几个新特性, 其中一个就是**`Share Extension`**, 大家可以打开苹果自己自带的浏览器**`Safari`**, 随便选中一个网站, 点击分享, 就会出现一个分享界面, 中间的那条**`iCon`**栏目就是系统自带的**`Share Extension`**(如图所示), 说白了就是把**`Safari`**的网站地址分享出去罢了, 所以说**`Share Extension`**其实就是系统自带的社会化SDK罢了, 说那么多道理, 还不如直接上代码~

![1 | center | 480x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/1.jpg)

---
###创建新工程

> 首先我们需要先创建一个新的工程, 由于**`Share Extension`**不是一个独立的应用, 它是需要依赖于主程序, 创建新工程的顺序我就省略了, 这里的新工程叫做**`ShareExtensionDemo`**.

![2 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/2.png)


---
### 创建Share Extension
>  创建完新工程之后, 我们现在来创建**`Share Extension`**和**`Today Extension`**一样, 系统是有自带的模板给我们自己选择

![3 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/3.png)

![4 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/4.png)

![5 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/5.png)

![6 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/6.png)

---
### 配置主应用
> 现在新工程和**`Share Extension`**已经创建完成, 现在我们可以在主应用当中调起**`Share Extension`**来看看效果, 这里我为了方便, 所以使用的是**`StoryBoard`**.

> 拖一个**`UIButton`**到**`StoryBoard`**, 改名为**`Share`**, 然后关联**`Action`**事件到**`ViewController`**, 添加对应的代码.
![7 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/7.png)

![8 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/8.png)

![9 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/9.png)

![10 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/10.png)


```objectivec
- (IBAction)ShareAction:(UIButton *)sender {
    
    NSString *string = @"您好";
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[string]
                                                                                     applicationActivities:nil];
    
    [self presentViewController:activityController
                       animated:YES
                     completion:nil];
}
```

> 现在让我们来看看对应的效果吧~~

![11 | center | 480x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/11.png)

![12 | center | 480x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/12.png)

![13 | center | 480x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/13.png)

> 现在我们看到了**`Share Extension`**展示出来的效果, 但酱紫还是不够的, 继续继续~

---
### 配置Share Extension

> 在配置**`Share Extension`**之前, 我们需要看看里面的几个方法, 不然我们完全都是蒙圈的

![14 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/14.png)

```objectivec
// 如果是return No, 那么发送按钮就无法点击, 如果return YES, 那么发送按钮就可以点击
- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}
```

```objectivec
// 发送按钮的Action事件
- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}
```

```objectivec
// 这个方法是用来返回items的一个方法, 而且返回值是数组
- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}
```

---
### 配置NSExtension
> 我们知道了上面那几个方法之后, 现在来配置一下我们可传送的内容规则, 这些规则分别是

| iOS扩展插件支持媒体类型配置键 | 描述 | 说明 |
| :---: | :---: | :---: |
| NSExtensionActivationSupportsAttachmentsWithMaxCount | 附件最多限制: 20 | 附件包括下面的File、Image和Movie三大类，单一、混选总量不超过20
| NSExtensionActivationSupportsAttachmentsWithMinCount | 附件最多限制: 上面非零时default=1 | 默认至少选择1个附件，[Share Extension]中才显示扩展插件图标
| NSExtensionActivationSupportsWebURLWithMaxCount | Web链接最多限制: default=0 | 默认不支持分享超链接，例如[Safari]
| NSExtensionActivationSupportsFileWithMaxCount | 文件最多限制: 20 | 单一、多选均不超过20
| NSExtensionActivationSupportsWebPageWithMaxCount | Web页面最多限制: default=0 | 默认不支持Web页面分享，例如[Safari]
| NSExtensionActivationSupportsImageWithMaxCount | 图片最多限制: 20 | 单一、多选均不超过20
| NSExtensionActivationSupportsVideoWithMaxCount | 视频最多限制: 20 | 单一、多选均不超过20
| NSExtensionActivationSupportsText | 文本类型: default=0 | 默认不支持文本分享，例如[备忘录]

> 其实这个表格在**[官网文档](https://developer.apple.com/library/ios/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html)**都是可以找到的~~

![15 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/15.png)

---
# <center>Share Extension逻辑</center>

### 填写限制字数长度的逻辑

> 首先我们来填写一个东东, 就是限制**`Share Extension`**的可输入字数长度, 然后添加一个分享路径
> 
> 这里特别需要强调一点哈, 因为**http://requestb.in/1hx20w61**这个链接是需要自己去手动申请的, 而且是居然时效性的, 如果失效了, 那就自己去**http://requestb.in**再申请一个就好了.

```objectivec
// 限制字数, 最多只能输入40个
static NSInteger const maxCharactersAllowed = 40;
// 这是一个测试连接, 并不是固定的, 你可以去http://requestb.in申请, 然后替换到你最新申请的连接即可
static NSString *uploadURL = @"http://requestb.in/1hx20w61";
```

> 声明完了字数长度, 我们需要去**`- (BOOL)isContentValid`**方法中实现

```objectivec
- (BOOL)isContentValid {
    
    NSInteger length = self.contentText.length;
    
    self.charactersRemaining = @(maxCharactersAllowed - length);
    
    return self.charactersRemaining.integerValue < 0 ? NO : YES;
}
```

---
### 填写上传信息的逻辑
> 在这里我用原生的网络请求进行请求发送, 大家也可以去使用**[AFNetWorking](https://github.com/AFNetworking/AFNetworking)**, Swift的话可以去使用另外一个网络请求框架**[Alamofire](https://github.com/Alamofire/Alamofire)**, 作者都是同一个大神
> 
> 在写逻辑之前, 我们需要打开App的一个Group功能, 并且填写对应的参数, 不然没法传送数据.


![16 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/16.png)
![17 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/17.png)

> 同样的, **`Share Extension`**也需要同样的操作, 这里就不做重复的操作了, 现在我们继续来填写对应的网络操作逻辑

![18 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/18.png)

> 首先, 我们需要封装一个返回**`NSURLRequest`**的方法

```objectivec
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
```
> 然后在**`- (void)didSelectPost `**点击事件中去调用
```objectivec
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
```

> 这样子就完事了, 由于我这里不知道为啥用模拟器一直没法进行网络请求, 只能用真机测试了, 不知道是不是我配置的问题, 如果有知道的大神麻烦请告知一声, 谢谢啦~~现在我们再来重复一下刚开始的操作, 发送请求到指定的**`URL`**里去.

![19 | center | 480x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/19.png)

![20 | center | 1080x0](https://github.com/CainRun/ShareExtensionDemo/blob/master/images-folder/20.png)

> 酱紫我们就搞定了**`Share Extension`**, 灰常的简单

---
### 自定义UI

> 这里补充一点, 其实**`Share Extension`**说白了就是一个**`UIViewController`**, 所以你可以根据你的喜好来进行UI定制, 详细资料大家可以去苹果官网或者**`Google`**搜搜, 百度的话, 你们懂得


---
### 补充篇文章

> 这里再补充篇文章, 关于Share Extension的, 是用Swift写的, 里面有一些问题, 会导致**`NSURLRequest`**返回为**`nil`**, 大家单步调试一下就知道为什么了

[iOS8 Day-by-Day– Day2 — 分享应用扩展](http://letsswift.com/2014/09/ios8-day-by-day-day2/)

---
### GitHub地址
Share Extension工程地址: https://github.com/CainRun/ShareExtensionDemo