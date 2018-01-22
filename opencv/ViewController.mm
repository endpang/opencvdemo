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
#import <AFNetworking.h>
#import "ShowController.h"

//@interface ViewController ()
NSString * const CSAlbum = @"opencv";
NSString * const CSAssetIdentifier = @"assetIdentifier";
NSString * const CSAlbumIdentifier = @"albumIdentifier";
NSString *thisurl = @"";
@interface ViewController ()<CvVideoCameraDelegate>{
    NSString *albumId;
    UIImageView *cameraView;
    CvVideoCamera *videoCamera;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"主页"];
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
    videoCamera.defaultAVCaptureSessionPreset =  AVCaptureSessionPreset1280x720; //AVCaptureSessionPresetiFrame1280x720;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.rotateVideo = YES;
   
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
    UIImage *image = cameraView.image;
    NSMutableArray *photos = [NSMutableArray array];
    [photos addObject:image];
    
    //temp为服务器URL;
    NSString *url = @"http://cd-zhiweip-media.bj.opera.org.cn/post.php";
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //参数name：是后台给你的图片在服务器上字段名;
        //参数fileNmae：自己起得一个名字，
        //参数mimeType：这个是决定于后来接收什么类型的图片，接收的时png就用image/png ,接收的时jpeg就用image/jpeg
        
        for (int i = 0; i < photos.count; i++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
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
            thisurl = str;
            [self performSegueWithIdentifier:@"sess" sender:self];
            
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            NSLog(@"%@\n %@", response, str);
            
        }
    }];
    
    [uploadTask resume];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"sess"]) {////这里toVc是拉的那条线的标识符
        ShowController *theVc = segue.destinationViewController;
        [theVc setValue:thisurl forKey:@"url"];
         //theVc.isLastPushToThisVc = YES;////传的参数
    }
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
    //cv::Mat image_copy;
    //cv::Canny(image, image_copy, 100,150);
    //cv::bitwise_not(image_copy, image_copy);

    //image = image_copy;
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
   
    
    //*/
     image_copy = image;
     cv::cvtColor(image_copy, image_copy, cv::COLOR_BGR2BGRA);
     cameraView.image =  MatToUIImage(image_copy);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
