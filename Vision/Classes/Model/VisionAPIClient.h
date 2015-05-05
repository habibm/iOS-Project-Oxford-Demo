//
//  VisionAPIClient.h
//  Vision
//
//  Created by Habib Ashraf on 02/05/2015.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface VisionAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (void)analyzeImageUrl:(NSString *)imageUrl
         visualFeatures:(NSArray *)features;

- (void)analyzeImage:(UIImage *)image
      visualFeatures:(NSArray *)features
             success:(void (^)(id response))success
             failure:(void (^)(NSError *error))failure;

- (void)thumbnailImage:(UIImage *)image
                 width:(int)width
                height:(int)height
         smartCropping:(BOOL)smartCropping
               success:(void (^)(id image))success
               failure:(void (^)(NSError *error))failure;
@end
