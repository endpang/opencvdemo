//
//  ShowController.m
//  opencv
//
//  Created by zhiwei pang on 2018/1/22.
//  Copyright © 2018年 zhiwei pang. All rights reserved.
//

#import "ShowController.h"

@interface ShowController (){
   
}

@end

@implementation ShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
    CGRect bouds = [UIScreen mainScreen].bounds;
    UIWebView* webView = [[UIWebView alloc]initWithFrame:bouds];
    
    //    2、加载在线资源http内容
    
    NSURL* url = [NSURL URLWithString:self.url];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
    [self.view addSubview: webView];
    [webView loadRequest:request];//加载
     //*/
    CGRect bouds = [UIScreen mainScreen].bounds;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:bouds];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 5.0f;
    [imageView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    NSURL *imageUrl = [NSURL URLWithString:self.url];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    imageView.image = image;
    //NSLog(@"%@",self.url );
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] == NSURLErrorCancelled) {
    
        return;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
