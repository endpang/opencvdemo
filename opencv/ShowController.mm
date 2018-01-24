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
#import <AFNetworking.h>

@interface ShowController (){
    cv::Scalar Scalar1;
    UIButton *button;
    //UIImage *colorimage;
    cv::Mat colorimage;
    int aa;
    int bb;
    int cc;
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
    
    colorimage = cv::Mat(1831,1030,CV_8UC4,cv::Scalar(255,255,255,0));//[UIImage imageNamed:@"kong"];
    
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
    bb = 255;
    //[button setBackgroundImage:imgNormal forState:UIControlStateNormal];
    //[button setBackgroundImage:imgHighlighted forState:UIControlStateHighlighted];
    button.frame = CGRectMake(314, 676, 100, 60);
    
    [button addTarget:self action:@selector(buttonPrint) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *button2 = [[UIButton alloc]init];
    //[button setTitle:@"" forState:UIControlStateNormal];
    UIImage *imgNormal = [UIImage imageNamed:@"108"];
    UIImage *imgHighlighted = [UIImage imageNamed:@"109"];
    
    [button2 setBackgroundImage:imgNormal forState:UIControlStateNormal];
    [button2 setBackgroundImage:imgHighlighted forState:UIControlStateHighlighted];
    button2.frame = CGRectMake(280, 600, 50, 50);
    
    [button2 addTarget:self action:@selector(buttonRe) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:button2];
    //*/
    //NSLog(@"%@",self.url );
    // Do any additional setup after loading the view.
}


- (void)buttonRe{

    for(int ii = 0;ii < 1832 ; ii++){
        for(int jj = 0;jj < 1032 ; jj++){
            //print( colorimage.at<cv::Vec4b>(ii, jj));
            if( colorimage.at<cv::Vec4b>(ii,jj)[0] == 255
               && colorimage.at<cv::Vec4b>(ii, jj)[1] == 255
               && colorimage.at<cv::Vec4b>(ii, jj)[2] == 255){
                colorimage.at<cv::Vec4b>(ii, jj)[3] = 0;
                //NSLog(@"one\n");
            }
          
        }
    }
    
  
    
    UIImage *image =  MatToUIImage(colorimage);

    NSMutableArray *photos = [NSMutableArray array];
    [photos addObject:image];
    
    //temp为服务器URL;
    
    NSString *url = @"http://cd-zhiweip-media.bj.opera.org.cn/re.php";
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //参数name：是后台给你的图片在服务器上字段名;
        //参数fileNmae：自己起得一个名字，
        //参数mimeType：这个是决定于后来接收什么类型的图片，接收的时png就用image/png ,接收的时jpeg就用image/jpeg
      
        for (int i = 0; i < photos.count; i++) {
            //NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            //formatter.dateFormat=@"yyyyMMddHHmmss";
            //NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.png",self.imageid];
            UIImage *image = photos[i];
            //NSData *imageData = UIImageJPEGRepresentation(image, 0.28);
            NSData *imageData = UIImagePNGRepresentation(image);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"upload%d",i+1] fileName:fileName mimeType:@"image/png"];
            
        }
        //        [formData appendPartWithFileData:imageData name:@"Filedata" fileName:@"Filedate.png" mimeType:@"image/png"];
        
        
    } error:nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //设置服务器返回内容的接受格式
    AFHTTPResponseSerializer *responseSer = [AFHTTPResponseSerializer serializer];
    responseSer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.responseSerializer = responseSer;
    
    //    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
            
        } else {
            
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            //thisurl = str;
            //thisimageid = str;
            //thisurl = [NSString stringWithFormat:@"%@=%@",@"http://cd-zhiweip-media.bj.opera.org.cn/jpg.php?id",str];
            
            //[self performSegueWithIdentifier:@"sess" sender:self];
            
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            NSLog(@"result: %@\n %@", response, str);
            
            NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@=%@",@"http://cd-zhiweip-media.bj.opera.org.cn/jpg.php?id",str]];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            self.imageView.image = image;
            colorimage = cv::Mat(1831,1030,CV_8UC4,cv::Scalar(255,255,255,0));
            
        }
    }];
    
    [uploadTask resume];
}
- (void)buttonPrint{
    cv::RNG rng(time(0));
    int a = rng.uniform(0,255);
    int b = rng.uniform(0,255);
    int c = rng.uniform(0,255);
    aa = a;
    bb = b;
    cc = c;
    Scalar1 = cv::Scalar(a,b,c,1);
    button.backgroundColor = [UIColor colorWithRed:a/255.0f green:b/255.0f blue:c/255.0f alpha:1];
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
    
    //UIImageToMat(colorimage, image_copy);
    //cv::cvtColor(image_copy, image_copy, cv::COLOR_BGRA2BGR);
    //colorimage[location.x * 2.5, location.y * 2.5] = Scalar1;
    
    
    cv::cvtColor(colorimage, colorimage, cv::COLOR_BGRA2BGR);
    cv::circle(colorimage,cv::Point(location.x * 2.5, location.y * 2.5), 2,Scalar1,-1);
    cv::cvtColor(colorimage, colorimage, cv::COLOR_BGR2BGRA);
    
    /**
    print(colorimage.at<cv::Scalar>((int)(location.x * 2.5), (int)(location.y * 2.5)));

    colorimage.at<cv::Scalar>((int)(location.x * 2.5), (int)(location.y * 2.5)) = cv::Scalar(aa,bb,cc,1);
    print(colorimage.at<cv::Scalar>((int)(location.x * 2.5), (int)(location.y * 2.5)));
    
    NSLog(@"x::%f",location.x);
    NSLog(@"y::%f",location.y);
    //*/
    //UIImage *mm = MatToUIImage(colorimage);
    //self.imageView.image = mm;

    
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
