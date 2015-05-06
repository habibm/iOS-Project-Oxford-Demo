//
//  VisionAPIClient.m
//  Vision
//
//  Created by Habib Ashraf on 02/05/2015.
//  Copyright (c) 2015 Habib Ashraf. All rights reserved.
//

#import "VisionAPIClient.h"

static NSString * const APIHost = @"https://api.projectoxford.ai";
static NSString * const SubscriptionKey = @"YOUR_SUBSCRIPTION_KEY_HERE";

@implementation VisionAPIClient

+ (instancetype)sharedClient {
    static VisionAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[VisionAPIClient alloc] initWithBaseURL:[NSURL URLWithString:APIHost]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

- (void)analyzeImageUrl:(NSString *)imageUrl visualFeatures:(NSArray *)features {
    
    NSDictionary *urlParams = @{@"subscription-key":SubscriptionKey,
                             @"visualFeatures":[features componentsJoinedByString:@","]};
    
    NSString *url = [self url:@"/vision/v1/analyses" params:urlParams];
    
    NSDictionary *args = @{@"Url" : imageUrl};
    
    [VisionAPIClient sharedClient].requestSerializer = [AFJSONRequestSerializer serializer];
    [[VisionAPIClient sharedClient].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [[VisionAPIClient sharedClient] POST:url parameters:args success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSLog(@"Response: %@", JSON);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSLog(@"Response: %@", [error localizedDescription]);
    }];
}

- (void)analyzeImage:(UIImage *)image
      visualFeatures:(NSArray *)features
             success:(void (^)(id response))success
             failure:(void (^)(NSError *error))failure {
    
    NSDictionary *urlParams = @{@"subscription-key":SubscriptionKey,
                                @"visualFeatures":[features componentsJoinedByString:@","]};
    
    NSString *url = [self url:@"/vision/v1/analyses" params:urlParams];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    [[VisionAPIClient sharedClient].requestSerializer setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [VisionAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    [[VisionAPIClient sharedClient] POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:imageData name:@"data"];
    } success:^(NSURLSessionDataTask *task, id response) {
        success(response);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)thumbnailImage:(UIImage *)image
                 width:(int)width
                height:(int)height
         smartCropping:(BOOL)smartCropping
               success:(void (^)(id image))success
               failure:(void (^)(NSError *error))failure {
    
    NSDictionary *urlParams = @{@"subscription-key":SubscriptionKey,
                                @"width": [NSString stringWithFormat:@"%d", width],
                                @"height": [NSString stringWithFormat:@"%d", height],
                                @"smartCropping": [NSString stringWithFormat:@"%d", smartCropping]};
    
    NSString *url = [self url:@"/vision/v1/thumbnails" params:urlParams];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    
    [[VisionAPIClient sharedClient].requestSerializer setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [VisionAPIClient sharedClient].responseSerializer = [AFImageResponseSerializer serializer];
    [[VisionAPIClient sharedClient] POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:imageData name:@"data"];
    } success:^(NSURLSessionDataTask *task, id image) {
        success(image);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (NSString *)url:(NSString *)method params:(NSDictionary *)params {
    NSMutableString *url = [NSMutableString new];
    [url appendString:method];
    BOOL start = TRUE;
    for (NSString *key in [params allKeys]) {
        if (start) {
            [url appendString:@"?"];
            start = FALSE;
        }else {
            [url appendString:@"&"];
        }
        [url appendString:key];
        [url appendString:@"="];
        [url appendString:[params[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    }
    return [NSString stringWithString:url];
}

@end
