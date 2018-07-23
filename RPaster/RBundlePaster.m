//
//  RBundlePaster.m
//  RPaster
//
//  Created by jasenhuang on 2018/7/22.
//  Copyright © 2018年 jasenhuang. All rights reserved.
//

#import "RBundlePaster.h"
#import "RBundleItem.h"

static NSRegularExpression *Regex;

@interface RBundlePaster()
@property(nonatomic, strong, readwrite) NSArray<RBundleItem*> *bundleItems;
@end

@implementation RBundlePaster
+ (RBundlePaster*)sharedInstance
{
    static RBundlePaster *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [RBundlePaster new];
        Regex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d+(\\.\\d+){0,3}).bundle" options:0 error:nil];
    });
    return instance;
}

- (void)loadPatchBundleFromFile
{
    NSURL* path = [NSURL URLWithString:[RBundlePaster bundlePath]];
    NSArray<NSString *> *resourceKeys = @[NSURLNameKey, NSURLIsDirectoryKey, NSURLContentModificationDateKey];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:path
                                                             includingPropertiesForKeys:nil
                                                                                options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           errorHandler:nil];
    NSError *error;
    RBundleItem* bundleItem;
    NSMutableArray* bundleItems = [NSMutableArray array];
    for (NSURL *fileURL in enumerator){
        NSDictionary<NSString *, id> *values = [fileURL resourceValuesForKeys:resourceKeys error:&error];
        
        // Skip non directories and errors.
        if (error || !values || ![values[NSURLIsDirectoryKey] boolValue]) {
            continue;
        }
        NSArray<NSTextCheckingResult*>* items = [Regex matchesInString:values[NSURLNameKey]
                                        options:0
                                          range:NSMakeRange(0, [values[NSURLNameKey] length])];
        if (!items.count) continue;
        
        NSLog(@"Loading Patch Bundle: %@", values[NSURLNameKey]);
        
        bundleItem = [[RBundleItem alloc] init];
        bundleItem.name = values[NSURLNameKey];
        bundleItem.version = [bundleItem.name substringToIndex:bundleItem.name.length - 7];
        bundleItem.modifiedTime = [values[NSURLContentModificationDateKey] timeIntervalSince1970];
        bundleItem.bundle = [RPatchBundle bundleWithURL:fileURL];
        [bundleItems addObject:bundleItem];
    }
    [bundleItems sortUsingComparator:^NSComparisonResult(RBundleItem*  _Nonnull obj1, RBundleItem*  _Nonnull obj2) {
        return [RBundlePaster compareVersion:obj1.version another:obj2.version];
    }];
    self.bundleItems = bundleItems;
}

- (void)addBundleWithPath:(NSURL*)fileURL
{
    NSArray<NSTextCheckingResult*>* items = [Regex matchesInString:fileURL.lastPathComponent
                                                           options:0
                                                             range:NSMakeRange(0, [fileURL.lastPathComponent length])];
    if (!items.count) {
        NSLog(@"Invalid Patch Bundle");
        return ;
    }
    RBundleItem *bundleItem = [[RBundleItem alloc] init];
    bundleItem.name = fileURL.lastPathComponent;
    bundleItem.version = [bundleItem.name substringToIndex:bundleItem.name.length - 7];
    [[NSFileManager defaultManager] attributesOfItemAtPath:fileURL.path error:nil];
    bundleItem.modifiedTime = [[NSDate date] timeIntervalSince1970];
    bundleItem.bundle = [RPatchBundle bundleWithURL:fileURL];
    
    NSMutableArray* bundleItems = [NSMutableArray arrayWithArray:self.bundleItems];
    [bundleItems addObject:bundleItem];
    
    [bundleItems sortUsingComparator:^NSComparisonResult(RBundleItem*  _Nonnull obj1, RBundleItem*  _Nonnull obj2) {
        return [RBundlePaster compareVersion:obj1.version another:obj2.version];
    }];
    self.bundleItems = bundleItems;
}

#pragma mark - util
+ (NSString*)bundlePath
{
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [NSString stringWithFormat:@"%@/RPaster", doc];
}

+ (NSComparisonResult)compareVersion:(NSString*)one another:(NSString*)another
{
    NSArray *version1 = [one componentsSeparatedByString:@"."];
    NSArray *version2 = [another componentsSeparatedByString:@"."];
    for(NSInteger i = 0 ; i < version1.count || i < version2.count; ++ i){
        NSInteger value1 = 0;
        NSInteger value2 = 0;
        if(i < version1.count){
            value1 = [version1[i] integerValue];
        }
        if(i < version2.count){
            value2 = [version2[i] integerValue];
        }
        if(value1  == value2){
            continue;
        }else{
            if(value1 > value2){
                return NSOrderedDescending;
            }else{
                return NSOrderedAscending;
            }
        }
    }
    return NSOrderedSame;
}


@end
