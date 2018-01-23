//
//  ShowController.h
//  opencv
//
//  Created by zhiwei pang on 2018/1/22.
//  Copyright © 2018年 zhiwei pang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowController : UIViewController <UIGestureRecognizerDelegate>  
@property (weak, nonatomic) NSString *url;
@property (weak, nonatomic) IBOutlet UIImageView *imageView; 
@end
