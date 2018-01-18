//
//  ViewController.m
//  CustomPhotoAlbum
//
//  Created by Balaji Malliswamy on 21/10/15.
//  Copyright © 2015 CodeSkip. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "CustomAlbum.h"
#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>
#include <opencv2/imgcodecs/ios.h>

NSString * const CSAlbum = @"Code Skip";
NSString * const CSAssetIdentifier = @"assetIdentifier";
NSString * const CSAlbumIdentifier = @"albumIdentifier";

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *albumId;
    NSString *recentImg;
}

@property (nonatomic, strong) PHPhotoLibrary* library;


@end

@implementation ViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createAlbum];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnOnClick:(id)sender
{
    if (albumId)
    {
        [self createAlbum];
    }
    else
    {
    [self Open_Library];
    }
}
- (IBAction)getRecentImg:(id)sender
{
    if (recentImg)
    {
        [CustomAlbum getImageWithIdentifier:recentImg onSuccess:^(UIImage *image) {
            cv::Mat image_m;
            cv::Mat image_copy;
            cv::Mat thresholdImg;
            std::vector< std::vector< cv::Point> > contours;
            cv::Mat image_binary;
            //首先将图片由RGBA转成GRAY
            UIImageToMat(image, image_m);
            cv::cvtColor(image_m, image_copy, cv::COLOR_BGR2GRAY);
            
            cv::adaptiveThreshold(image_copy, thresholdImg, 255, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY_INV, 7, 7);
            cv::findContours(thresholdImg, contours, CV_RETR_LIST, CV_CHAIN_APPROX_NONE);
            
            
            
            thresholdImg = cv::Scalar::all(0);
            cv::drawContours(thresholdImg, contours, -1, cv::Scalar::all(255));
            
            //反转图片
            
            cv::bitwise_not(thresholdImg, thresholdImg);
            cv::GaussianBlur(thresholdImg, thresholdImg, cv::Size(5,5), 1.2,1.2);
            //将处理后的图片赋值给image，用来显示
            //cv::medianBlur(thresholdImg, thresholdImg, 5); 中值滤波
            
            cv::cvtColor(thresholdImg, image_m, cv::COLOR_GRAY2BGR);
            image = MatToUIImage(image_m);
           
            [self.imgView setImage:image];
        } onError:^(NSError *error) {
            NSLog(@"Not found!");
        }];
    }
}


#pragma -
#pragma mark Image picker delegate methdos
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [CustomAlbum addNewAssetWithImage:image toAlbum:[CustomAlbum getMyAlbumWithName:CSAlbum] onSuccess:^(NSString *ImageId) {
        NSLog(@"%@",ImageId);
        recentImg = ImageId;
    } onError:^(NSError *error) {
        NSLog(@"probelm in saving image");
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)Open_Library
{
    // Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    // Delegate is self
    
    // Allow editing of image ?
    imagePicker.allowsEditing = true;
    // Show image picker
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}





@end
