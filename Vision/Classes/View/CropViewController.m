//
//  CropViewController.m
//  Vision
//
//  Created by Habib Ashraf on 03/05/2015.
//  Copyright (c) 2015 Habib Ashraf. All rights reserved.
//

#import "CropViewController.h"

@interface CropViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailView;

@end

@implementation CropViewController

- (void)finishAndUpdate
{
    [super finishAndUpdate];
    
    UIImage *scaledImage = [[self class] imageWithImage:self.capturedImage scaledToWidth:900.0f];
    
    self.thumbnailView.image = nil;
    [self.activityIndicator startAnimating];
    [[VisionAPIClient sharedClient] thumbnailImage:scaledImage width:200 height:200 smartCropping:YES success:^(id image) {
        [self.activityIndicator stopAnimating];
        self.thumbnailView.image = image;
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

@end
