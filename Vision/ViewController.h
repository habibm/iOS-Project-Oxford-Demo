//
//  ViewController.h
//  Vision
//
//  Created by Habib Ashraf on 02/05/2015.
//  Copyright (c) 2015 Habib Ashraf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisionAPIClient.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;

@property (nonatomic) UIImage *capturedImage;

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;

- (void)finishAndUpdate;

@end

