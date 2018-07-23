//
//  RBundleItem.h
//  RPaster
//
//  Created by jasenhuang on 2018/7/23.
//  Copyright © 2018年 jasenhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RPatchBundle : NSBundle

@end

@interface RBundleItem : NSObject
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* version;
@property(nonatomic, strong) NSBundle* bundle;
@property(nonatomic, assign) NSTimeInterval modifiedTime;
@end

NS_ASSUME_NONNULL_END
