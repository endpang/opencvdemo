//
//  ViewController.m
//  opencv
//
//  Created by zhiwei pang on 2018/1/15.
//  Copyright © 2018年 zhiwei pang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ViewController.h"
#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc/types_c.h>
#import <Photos/Photos.h>
#import "CustomAlbum.h"
#import <UIKit/UIKit.h>

//@interface ViewController ()
NSString * const CSAlbum = @"opencv";
NSString * const CSAssetIdentifier = @"assetIdentifier";
NSString * const CSAlbumIdentifier = @"albumIdentifier";
@interface ViewController ()<CvVideoCameraDelegate>{
    NSString *albumId;
    UIImageView *cameraView;
    CvVideoCamera *videoCamera;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAlbum];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [[UIButton alloc]init];
    //[button setTitle:@"" forState:UIControlStateNormal];
    UIImage *imgNormal = [UIImage imageNamed:@"108"];
    UIImage *imgHighlighted = [UIImage imageNamed:@"109"];
    
    [button setBackgroundImage:imgNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imgHighlighted forState:UIControlStateHighlighted];
    button.frame = CGRectMake(280, 600, 100, 100);
    
    [button addTarget:self action:@selector(buttonPrint) forControlEvents:UIControlEventTouchUpInside];
    

    cameraView = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:cameraView];
    [self.view addSubview:button];
    
    videoCamera = [[CvVideoCamera alloc] initWithParentView:cameraView];
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;// AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1280x720;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
   
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
    videoCamera.delegate = self;
}

- (void)createAlbum
{
    [CustomAlbum makeAlbumWithTitle:CSAlbum onSuccess:^(NSString *AlbumId)
     {
         albumId = AlbumId;
     }
                            onError:^(NSError *error) {
                                NSLog(@"probelm in creating album");
                            }];
}

- (void)buttonPrint{

    /**/
   
    [CustomAlbum addNewAssetWithImage:cameraView.image toAlbum:[CustomAlbum getMyAlbumWithName:CSAlbum] onSuccess:^(NSString *ImageId) {
        NSLog(@"imageId:%@",ImageId);
        //recentImg = ImageId;
    } onError:^(NSError *error) {
        
        NSLog(@"probelm in saving image 11111: %@",error);
    }];
     //*/
    printf("测试打印");
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [videoCamera start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [videoCamera stop];
}

#pragma mark -  CvVideoCameraDelegate
- (void)processImage:(cv::Mat&)image {
    
    /**/
    //在这儿我们将要添加图形处理的代码
    cv::Mat image_copy;
    cv::Mat thresholdImg;
    std::vector< std::vector< cv::Point> > contours;
    cv::Mat image_binary;
    //首先将图片由RGBA转成GRAY
    cv::cvtColor(image, image_copy, cv::COLOR_BGR2GRAY);
    
    cv::adaptiveThreshold(image_copy, thresholdImg, 255, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY_INV, 7, 7);
    cv::findContours(thresholdImg, contours, CV_RETR_LIST, CV_CHAIN_APPROX_NONE);
    

    
    thresholdImg = cv::Scalar::all(0);
    cv::drawContours(thresholdImg, contours, -1, cv::Scalar::all(255));
    
    //反转图片
    
    cv::bitwise_not(thresholdImg, thresholdImg);
    cv::GaussianBlur(thresholdImg, thresholdImg, cv::Size(5,5), 1.2,1.2);
    //将处理后的图片赋值给image，用来显示
    //cv::medianBlur(thresholdImg, thresholdImg, 5); 中值滤波
    cv::cvtColor(thresholdImg, image, cv::COLOR_GRAY2BGR);
    cameraView.image =  MatToUIImage(image);
    
    //*/
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end