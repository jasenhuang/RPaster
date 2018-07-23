//
//  RBundlePaster.h
//  RPaster
//
//  Created by jasenhuang on 2018/7/22.
//  Copyright © 2018年 jasenhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RBundleItem;

@interface RBundlePaster : NSObject
@property(nonatomic, strong, readonly) NSArray<RBundleItem*> *bundleItems;

+ (RBundlePaster*)sharedInstance;


/**
 *  Load all bundles from file
 */
- (void)loadPatchBundleFromFile;

/**
 * Add specific bundle after download
 */
- (void)addBundleWithPath:(NSURL*)fileURL;

/**
 * Bundle Directory
 */
+ (NSString*)bundlePath;

@end
