//
//  RBundleDownloader.m
//  RPaster
//
//  Created by jasenhuang on 2018/7/23.
//  Copyright © 2018年 jasenhuang. All rights reserved.
//

#import "RBundleDownloader.h"
#import "RBundlePaster.h"
#import "RBundleUtils.h"

@interface RBundleDownloader()
@property(nonatomic, strong) NSURLSession* session;
@end

@implementation RBundleDownloader

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"RBundleDownloader"];
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (NSURLSessionTask*)downloadBundleFromURL:(NSURL*)URL
{
    NSURLSessionTask* task = [self.session downloadTaskWithURL:URL
                                             completionHandler:^(NSURL * _Nullable location,
                                                                 NSURLResponse * _Nullable response,
                                                                 NSError * _Nullable error) {
                                                 
                                                 NSURL *target = [NSURL fileURLWithPath:
                                                                  [NSString stringWithFormat:@"%@/%@",
                                                                   [RBundlePaster bundlePath],
                                                                   location.lastPathComponent
                                                                   ]];
                                                 if ([[NSFileManager defaultManager] fileExistsAtPath:target.path]){
                                                     [[NSFileManager defaultManager] removeItemAtPath:target.path error:nil];
                                                 }
                                                 [[NSFileManager defaultManager] moveItemAtURL:location
                                                                                         toURL:target error:nil];
                                                 if ([[NSFileManager defaultManager] fileExistsAtPath:target.path]){
                                                    [[RBundlePaster sharedInstance] addBundleWithPath:nil];
                                                 }
                                             }];
    [task resume];
    return task;
}

@end
