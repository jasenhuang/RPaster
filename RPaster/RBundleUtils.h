//
//  RBundleUtils.h
//  RPaster
//
//  Created by jasenhuang on 2018/8/17.
//  Copyright © 2018 jasenhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBundleUtils : NSObject

+ (NSString*) RBString_MD5:(NSString*)str;
+ (NSString*) RBString_SHA1:(NSString*)str;

+ (NSString*) RBData_MD5:(NSData*)data;
+ (NSString*) RBData_SHA1:(NSData*)data;

@end

NS_ASSUME_NONNULL_END
