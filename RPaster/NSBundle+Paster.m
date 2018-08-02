//
//  NSBundle+Paster.m
//  RPaster
//
//  Created by jasenhuang on 2018/7/23.
//  Copyright © 2018年 jasenhuang. All rights reserved.
//

#import "NSBundle+Paster.h"
#import <objc/runtime.h>
#import "RBundlePaster.h"
#import "RBundleItem.h"

void swizzleClassMethod(Class cls, SEL origSelector, SEL newSelector)
{
    if (!cls) return;
    Method originalMethod = class_getClassMethod(cls, origSelector);
    Method swizzledMethod = class_getClassMethod(cls, newSelector);
    
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    if (class_addMethod(metacls,
                        origSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* swizzing super class method, added if not exist */
        class_replaceMethod(metacls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(metacls,
                            newSelector,
                            class_replaceMethod(metacls,
                                                origSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}

void swizzleInstanceMethod(Class cls, SEL origSelector, SEL newSelector)
{
    if (!cls) {
        return;
    }
    /* if current class not exist selector, then get super*/
    Method originalMethod = class_getInstanceMethod(cls, origSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, newSelector);
    
    /* add selector if not exist, implement append with method */
    if (class_addMethod(cls,
                        origSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* replace class instance method, added if selector not exist */
        /* for class cluster , it always add new selector here */
        class_replaceMethod(cls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(cls,
                            newSelector,
                            class_replaceMethod(cls,
                                                origSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}

@implementation NSBundle (Paster)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleInstanceMethod([NSBundle class], @selector(URLForResource:withExtension:subdirectory:), @selector(hookURLForResource:withExtension:subdirectory:));
        swizzleInstanceMethod([NSBundle class], @selector(URLForResource:withExtension:subdirectory:localization:), @selector(hookURLForResource:withExtension:subdirectory:localization:));
        
        swizzleInstanceMethod([NSBundle class], @selector(URLsForResourcesWithExtension:subdirectory:), @selector(hookURLsForResourcesWithExtension:subdirectory:));
        swizzleInstanceMethod([NSBundle class], @selector(URLsForResourcesWithExtension:subdirectory:localization:), @selector(hookURLsForResourcesWithExtension:subdirectory:localization:));
    });
}

- (NSURL*)hookURLForResource:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subpath
{
    NSURL* URL;
    if ([name isEqualToString:@"Assets"] && [ext isEqualToString:@"car"]){
        URL = [self hookURLForResource:name withExtension:ext subdirectory:subpath];
        return URL;
    }
    for (RBundleItem* item in [RBundlePaster sharedInstance].bundleItems.reverseObjectEnumerator.allObjects) {
        URL = [item.bundle hookURLForResource:name withExtension:ext subdirectory:subpath];
        if (URL) break;
    }
    if (!URL) URL = [self hookURLForResource:name withExtension:ext subdirectory:subpath];
    return URL;
}

- (NSURL*)hookURLForResource:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subpath localization:(NSString *)localizationName
{
    NSURL* URL;
    if ([name isEqualToString:@"Assets"] && [ext isEqualToString:@"car"]){
        URL = [self hookURLForResource:name withExtension:ext subdirectory:subpath localization:localizationName];
        return URL;
    }
    for (RBundleItem* item in [RBundlePaster sharedInstance].bundleItems.reverseObjectEnumerator.allObjects) {
        URL = [item.bundle hookURLForResource:name withExtension:ext subdirectory:subpath localization:localizationName];
        if (URL) break;
    }
    if (!URL) URL = [self hookURLForResource:name withExtension:ext subdirectory:subpath localization:localizationName];
    return URL;
}

- (NSArray<NSURL*>*)hookURLsForResourcesWithExtension:(NSString *)ext subdirectory:(NSString *)subpath
{
    NSMutableArray<NSURL*>* URLs = [NSMutableArray array];
    for (RBundleItem* item in [RBundlePaster sharedInstance].bundleItems.reverseObjectEnumerator.allObjects) {
        NSArray<NSURL*>* bundleURLs = [item.bundle hookURLsForResourcesWithExtension:ext subdirectory:subpath];
        [URLs addObjectsFromArray:bundleURLs];
    }
    NSArray<NSURL*>* bundleURLs = [self hookURLsForResourcesWithExtension:ext subdirectory:subpath];
    [URLs addObjectsFromArray:bundleURLs];
    return URLs;
}

- (NSArray<NSURL*>*)hookURLsForResourcesWithExtension:(NSString *)ext subdirectory:(NSString *)subpath localization:(NSString *)localizationName
{
    NSMutableArray<NSURL*>* URLs = [NSMutableArray array];
    for (RBundleItem* item in [RBundlePaster sharedInstance].bundleItems.reverseObjectEnumerator.allObjects) {
        NSArray<NSURL*>* bundleURLs = [item.bundle hookURLsForResourcesWithExtension:ext subdirectory:subpath localization:localizationName];
        [URLs addObjectsFromArray:bundleURLs];
    }
    NSArray<NSURL*>* bundleURLs = [self hookURLsForResourcesWithExtension:ext subdirectory:subpath localization:localizationName];
    [URLs addObjectsFromArray:bundleURLs];
    return URLs;
}

@end

@implementation UIImage (Paster)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleClassMethod([UIImage class], @selector(imageNamed:inBundle:compatibleWithTraitCollection:), @selector(hookimageNamed:inBundle:compatibleWithTraitCollection:));
    });
}

+ (UIImage*)hookimageNamed:(NSString *)name inBundle:(NSBundle *)bundle compatibleWithTraitCollection:(UITraitCollection *)traitCollection
{
    UIImage* image;
    for (RBundleItem* item in [RBundlePaster sharedInstance].bundleItems.reverseObjectEnumerator.allObjects) {
        image = [self hookimageNamed:name inBundle:item.bundle compatibleWithTraitCollection:traitCollection];
        if (image) break;
    }
    if (!image) image = [self hookimageNamed:name inBundle:bundle compatibleWithTraitCollection:traitCollection];
    return image;
}

@end
