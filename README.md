# DynamicInvoker

[![CI Status](http://img.shields.io/travis/Dustin Bachrach/DynamicInvoker.svg?style=flat)](https://travis-ci.org/Dustin Bachrach/DynamicInvoker)
[![Version](https://img.shields.io/cocoapods/v/DynamicInvoker.svg?style=flat)](http://cocoapods.org/pods/DynamicInvoker)
[![License](https://img.shields.io/cocoapods/l/DynamicInvoker.svg?style=flat)](http://cocoapods.org/pods/DynamicInvoker)
[![Platform](https://img.shields.io/cocoapods/p/DynamicInvoker.svg?style=flat)](http://cocoapods.org/pods/DynamicInvoker)

## What is DynamicInvoker

Objective-C does not have a way to perform method overloading. DynamicInvoker aims to fill that gap. Typically we would do something like this:

```objc
@implementation MyObject

- (void)doSomething:(id)obj
{
    if ([obj isKindOfClass:NSString.class]) {
        NSString* str = (NSString*)obj;
        // do string based logic
    }
    else if ([obj isKindOfClass:NSDictionary.class]) {
        NSDictionary* dict = (NSDictionary*)obj;
        // do dictionary based logic
    }
}

@end
```

```objc
MyObject* myObj = /* get a MyObject */;
[myObj doSomething:@"a string"];
[myObj doSomething:@{ @"aKey: @"aValue" }];
```

With DynamicInvoker, you declare your methods with proper types and let DI figure out which should be invoked.

```objc
@implementation MyObject

- (void)doSomethingWithNSString:(NSString*)str {
    // do string based logic
}

- (void)doSomethingWithNSDictionary:(NSDictionary*)dict {
    // do dictionary based logic
}

@end
```

```objc
// Invoke DI
MyObject* myObj = /* get a MyObject */;
[myObj dynamicInvokeFormat:@"doSomethingWith%@:" data:@"a string"];
[myObj dynamicInvokeFormat:@"doSomethingWith%@:" data:@{ @"aKey: @"aValue" }];
```

DynamicInvoker can even handle protocols:

```objc
@protocol ShowOffable <NSObject>

@end

// ...

@implementation MyObject

- (void)doSomethingWithShowOffable:(id<ShowOffable>)showOff {
    // do ShowOffable based logic
}

// ...

id<ShowOffable> showOff = /* get a showoff */;
[myObj dynamicInvokeFormat:@"doSomethingWith:%@" data:showOff];
```

## Installation

DynamicInvoker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DynamicInvoker"
```

## Shoutout

If you like libraries that let you be more declarative with your types, check out [castaway](https://github.com/dbachrach/castaway).

## Author

Dustin Bachrach, dustin@mediahound.com

## License

DynamicInvoker is available under the Apache License 2.0. See the LICENSE file for more info.
