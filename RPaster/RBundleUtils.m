//
//  RBundleUtils.m
//  RPaster
//
//  Created by jasenhuang on 2018/8/17.
//  Copyright © 2018 jasenhuang. All rights reserved.
//

#import "RBundleUtils.h"

#import <CommonCrypto/CommonDigest.h>

#define MD5_CHAR_TO_STRING_16 [NSString stringWithFormat:               \
@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",    \
result[0], result[1], result[2], result[3],                             \
result[4], result[5], result[6], result[7],                             \
result[8], result[9], result[10], result[11],                           \
result[12], result[13], result[14], result[15]]                         \

#define MD5_CHAR_TO_STRING_20 [NSString stringWithFormat:               \
@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",    \
result[0], result[1], result[2], result[3],                             \
result[4], result[5], result[6], result[7],                             \
result[8], result[9], result[10], result[11],                           \
result[12], result[13], result[14], result[15],                         \
result[16], result[17], result[18], result[19]]                         \


@implementation RBundleUtils

+ (NSString*) RBString_MD5:(NSString*)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return MD5_CHAR_TO_STRING_16;
}
+ (NSString*) RBString_SHA1:(NSString*)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[20];
    CC_SHA1(cStr, (CC_LONG)strlen(cStr), result);
    return MD5_CHAR_TO_STRING_20;
}

+ (NSString*) RBData_MD5:(NSData*)data
{
    unsigned char result[16];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return MD5_CHAR_TO_STRING_16;
}
+ (NSString*) RBData_SHA1:(NSData*)data
{
    unsigned char result[20];
    CC_SHA1(data.bytes, (CC_LONG)data.length, result);
    return MD5_CHAR_TO_STRING_20;
}

@end
