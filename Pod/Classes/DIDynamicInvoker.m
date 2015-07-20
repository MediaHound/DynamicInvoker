//
//  DIDynamicInvoker.m
//  DynamicInvoker
//
//  Created by Dustin Bachrach on 10/7/14.
//
//

#import "DIDynamicInvoker.h"

#import <objc/runtime.h>


@implementation DIDynamicInvoker

+ (BOOL)invokeDynamicMethodForFormat:(NSString*)format name:(NSString*)name data:(id)data on:(id)on
{
    NSString* selectorName = [NSString stringWithFormat:format, name];
    SEL selector = NSSelectorFromString(selectorName);
    
    return [self invokeSelector:selector on:on withObject:data];
}

+ (BOOL)invokeSelector:(SEL)selector on:(id)on
{
    if ([on respondsToSelector:selector]) {
        IMP imp = [on methodForSelector:selector];
        void (*func)(id, SEL) = (void*) imp;
        func(on, selector);
        
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)invokeSelector:(SEL)selector on:(id)on withObject:(id)obj
{
    if ([on respondsToSelector:selector]) {
        IMP imp = [on methodForSelector:selector];
        void (*func)(id, SEL, id) = (void*) imp;
        func(on, selector, obj);
        
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)dynamicInvokeFormat:(NSString*)format data:(id)data on:(id)obj
{
    return [self dynamicInvokeFormat:format data:data on:obj emptySelector:nil];
}

+ (BOOL)dynamicInvokeFormat:(NSString*)format data:(id)data on:(id)obj emptySelector:(SEL)emptySelector
{
    return [self dynamicInvokeFormat:format data:data base:data on:obj emptySelector:emptySelector];
}

+ (BOOL)dynamicInvokeFormat:(NSString*)format data:(id)data base:(id)base on:(id)obj
{
    return [self dynamicInvokeFormat:format data:data base:base on:obj emptySelector:nil];
}

+ (BOOL)dynamicInvokeFormat:(NSString*)format data:(id)data base:(id)base on:(id)obj emptySelector:(SEL)emptySelector
{
    if (base == [NSNull null]) {
        if (emptySelector) {
            if ([obj respondsToSelector:emptySelector]) {
                [self invokeSelector:emptySelector on:obj];
                return YES;
            }
        }
        return NO;
    }
    
    Class baseClass = [base class];
    
    static NSCache* methodCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        methodCache = [[NSCache alloc] init];
    });
    
    NSString* cacheKey = [NSString stringWithFormat:@"%@:%@:%@", format, NSStringFromClass([obj class]), NSStringFromClass(baseClass)];
    
    NSString* methodName = [methodCache objectForKey:cacheKey];
    if (methodName) {
        if ([methodName isEqual:[NSNull null]]) {
            // Do nothing
            return NO;
        }
        else {
            [self invokeDynamicMethodForFormat:format name:methodName data:data on:obj];
            return YES;
        }
    }
    
    while (baseClass) {
        NSString* baseClassName = NSStringFromClass(baseClass);
        if ([self invokeDynamicMethodForFormat:format name:baseClassName data:data on:obj]) {
            [methodCache setObject:baseClassName forKey:cacheKey];
            return YES;
        }
        
        unsigned int count;
        Protocol* __unsafe_unretained* protocols = class_copyProtocolList(baseClass, &count);
        
        for (unsigned int i = 0; i < count; i++) {
            const char* cstrName = protocol_getName(protocols[i]);
            NSString* protocolName = [NSString stringWithUTF8String:cstrName];
            
            if ([self invokeDynamicMethodForFormat:format name:protocolName data:data on:obj]) {
                [methodCache setObject:protocolName forKey:cacheKey];
                return YES;
            }
        }
        
        free(protocols);
        
        baseClass = [baseClass superclass];
    }
    
    [methodCache setObject:[NSNull null] forKey:cacheKey];
    return NO;
}

@end
