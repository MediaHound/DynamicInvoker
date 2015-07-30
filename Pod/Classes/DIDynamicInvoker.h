//
//  DIDynamicInvoker.h
//  DynamicInvoker
//
//  Created by Dustin Bachrach on 10/7/14.
//
//

#import <Foundation/Foundation.h>


/**
 * Allow dynamic method overloading on all NSObjects.
 */
@interface NSObject (DIDynamicInvoking)

/**
 * Call a overloaded method on the receiver.
 * @param format A format string for the overloaded method.
 *               Example: @"configureWith%@:" will invoke @selector(configureWithNSString:)
 *               if data is of type NSString.
 * @param data The parameter to be sent to the overloaded method.
 *             This value also determines which overload to call based on the type of data.
 */
- (BOOL)dynamicInvokeFormat:(NSString*)format
                       data:(id)data;

/**
 * Call a overloaded method on the receiver.
 * @param format A format string for the overloaded method.
 *               Example: @"configureWith%@:" will invoke @selector(configureWithNSString:)
 *               if data is of type NSString.
 * @param data The parameter to be sent to the overloaded method.
 *             This value also determines which overload to call based on the type of data.
 * @param emptySelector A selector to invoke if data is NSNull.
 */
- (BOOL)dynamicInvokeFormat:(NSString*)format
                       data:(id)data
              emptySelector:(SEL)emptySelector;

/**
 * Call a overloaded method on the receiver.
 * @param format A format string for the overloaded method.
 *               Example: @"configureWith%@:" will invoke @selector(configureWithNSString:)
 *               if base is of type NSString.
 * @param data The parameter to be sent to the overloaded method.
 * @param emptySelector A selector to invoke if data is NSNull.
 * @param base The object to use to decide which overload to invoke.
 */
- (BOOL)dynamicInvokeFormat:(NSString*)format
                       data:(id)data
              emptySelector:(SEL)emptySelector
                       base:(id)base;

@end
