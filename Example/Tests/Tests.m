//
//  DynamicInvokerTests.m
//  DynamicInvokerTests
//
//  Created by Dustin Bachrach on 07/20/2015.
//  Copyright (c) 2015 Dustin Bachrach. All rights reserved.
//

// https://github.com/Specta/Specta

#import <DynamicInvoker/DIDynamicInvoker.h>

static NSInteger s_Value = 0;

void clearValue() {
    s_Value = 0;
}

@interface TestObj : NSObject

- (void)doWithNSString:(NSString*)str;
- (void)doWithNSDictionary:(NSDictionary*)dict;

@end

@implementation TestObj

- (void)doWithNSString:(NSString*)str
{
    s_Value = 111;
}

- (void)doWithNSDictionary:(NSDictionary*)dict
{
    s_Value = 222;
}

- (void)doEmpty
{
    s_Value = 333;
}

@end

SpecBegin(InitialSpecs)

describe(@"DynamicInvoker", ^{
    
    TestObj* receiver = [[TestObj alloc] init];
    
    it(@"calls the proper method for object types via category", ^{
        [receiver dynamicInvokeFormat:@"doWith%@:"
                                 data:@"Hello String"];
        expect(s_Value).to.equal(111);
        clearValue();
        
        [receiver dynamicInvokeFormat:@"doWith%@:"
                                 data:@{@"key": @"value"}];
        expect(s_Value).to.equal(222);
        clearValue();
    });
    
    it(@"calls the emptySelector for null data", ^{
        [receiver dynamicInvokeFormat:@"doWith%@:"
                                 data:[NSNull null]
                        emptySelector:@selector(doEmpty)];
        expect(s_Value).to.equal(333);
        clearValue();
        
        [receiver dynamicInvokeFormat:@"doNOTFOUNDWith%@:"
                                 data:[NSNull null]
                        emptySelector:@selector(doEmpty)];
        expect(s_Value).to.equal(333);
        clearValue();
    });
    
    it(@"calls the proper method for object types based on the base parameter", ^{
        [receiver dynamicInvokeFormat:@"doWith%@:"
                                 data:@"Hello String"
                        emptySelector:nil
                                 base:@{@"key": @"value"}];
        expect(s_Value).to.equal(222);
        clearValue();
        
        [receiver dynamicInvokeFormat:@"doWith%@:"
                                 data:@"Hello String"
                        emptySelector:@selector(doEmpty)
                                 base:[NSNull null]];
        expect(s_Value).to.equal(333);
        clearValue();
    });
    
});

SpecEnd

