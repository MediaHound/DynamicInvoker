//
//  DIDynamicInvoker.h
//  DynamicInvoker
//
//  Created by Dustin Bachrach on 10/7/14.
//
//

#import <Foundation/Foundation.h>


@interface DIDynamicInvoker : NSObject

+ (BOOL)dynamicInvokeFormat:(NSString*)format data:(id)data on:(id)obj;

+ (BOOL)dynamicInvokeFormat:(NSString*)format data:(id)data on:(id)obj emptySelector:(SEL)emptySelector;

+ (BOOL)dynamicInvokeFormat:(NSString*)format data:(id)data base:(id)base on:(id)obj;

+ (BOOL)dynamicInvokeFormat:(NSString*)format data:(id)data base:(id)base on:(id)obj emptySelector:(SEL)emptySelector;

@end
