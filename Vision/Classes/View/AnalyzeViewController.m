//
//  AnalyzeViewController.m
//  Vision
//
//  Created by Habib Ashraf on 03/05/2015.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import "AnalyzeViewController.h"

@interface AnalyzeViewController ()

@end

@implementation AnalyzeViewController

- (void)finishAndUpdate
{
    [super finishAndUpdate];
    
    UIImage *scaledImage = [[self class] imageWithImage:self.capturedImage scaledToWidth:900.0f];
    
    self.textView.text = @"";
    [self.activityIndicator startAnimating];
    [[VisionAPIClient sharedClient] analyzeImage:scaledImage visualFeatures:@[@"All"] success:^(id JSON) {
        self.textView.text = [JSON description];
        [self.activityIndicator stopAnimating];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

@end
