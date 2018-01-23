//
//  ShowController.m
//  opencv
//
//  Created by zhiwei pang on 2018/1/22.
//  Copyright © 2018年 zhiwei pang. All rights reserved.
//

#import "ShowController.h"
#import <opencv2/opencv.hpp>
#include <opencv2/imgcodecs/ios.h>

@interface ShowController (){
    CvScalar Scalar1;
    UIButton *button;
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
    self.imageView = imageView;
   
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    NSURL *imageUrl = [NSURL URLWithString:self.url];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    imageView.image = image;
    //imageView.backgroundColor = [UIColor colorWithPatternImage:image];
    imageView.userInteractionEnabled = YES;
    /**
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
    [pinchGestureRecognizer setDelegate:self];
    [imageView addGestureRecognizer:pinchGestureRecognizer];
  
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureDetected:)];
    [rotationGestureRecognizer setDelegate:self];
    [imageView addGestureRecognizer:rotationGestureRecognizer];
    //*/
     /**
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    [panGestureRecognizer setDelegate:self];
    [imageView addGestureRecognizer:panGestureRecognizer];
    //*/
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
    [imageView addGestureRecognizer:singleTap];
    
    
    
    button= [[UIButton alloc]init];
    [button setTitle:@"换色" forState:UIControlStateNormal];
    //UIImage *imgNormal = [UIImage imageNamed:@"108"];
    //UIImage *imgHighlighted = [UIImage imageNamed:@"109"];
    button.backgroundColor = UIColor.blueColor;
    //[button setBackgroundImage:imgNormal forState:UIControlStateNormal];
    //[button setBackgroundImage:imgHighlighted forState:UIControlStateHighlighted];
    button.frame = CGRectMake(280, 600, 100, 100);
    
    [button addTarget:self action:@selector(buttonPrint) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    //*/
    //NSLog(@"%@",self.url );
    // Do any additional setup after loading the view.
}
- (void)buttonPrint{
    cv::RNG rng(time(0));
    int a = rng.uniform(0,255);
    int b = rng.uniform(0,255);
    int c = rng.uniform(0,255);
    Scalar1 = CvScalar(a,b,c);
    //button.backgroundColor = UIColor.
}
-(void)onClickImage:(UITapGestureRecognizer *)recognizer{
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    //NSLog("%f%f",location.x,location.y);
    NSLog(@"%f\n %f", location.x, location.y);
    
    UIImage *image  =  self.imageView.image;
    NSLog(@"%f\n %f", image.size.width, image.size.height);
    
    cv::Mat image_copy;
    UIImageToMat(image, image_copy);
    cv::cvtColor(image_copy, image_copy, cv::COLOR_BGRA2BGR);

    cv::circle(image_copy,cv::Point(location.x * 2.5, location.y * 2.5), 8,Scalar1,2);
    //cv::rectangle(image_copy, cv::Point(location.x * 2.5, location.y * 2.5), cv::Point(location.x * 2.8, location.y * 2.8), cv::Scalar(255, 0, 0,0),-1);
    //cv::cvtColor(image_copy, image_copy, cv::COLOR_BGRA2RGBA);
    image = MatToUIImage(image_copy);
    self.imageView.image = image;
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)pinchGestureDetected:(UIPinchGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, scale, scale)];
        [recognizer setScale:1.0];
    }
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        [recognizer.view setTransform:CGAffineTransformTranslate(recognizer.view.transform, translation.x, translation.y)];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }
}

- (void)rotationGestureDetected:(UIRotationGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat rotation = [recognizer rotation];
        [recognizer.view setTransform:CGAffineTransformRotate(recognizer.view.transform, rotation)];
        [recognizer setRotation:0];
    }
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
