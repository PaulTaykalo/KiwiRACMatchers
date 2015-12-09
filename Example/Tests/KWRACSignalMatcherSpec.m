//
//  KWRACSignalMatcherSpecSpec.m
//  KiwiRACMatchers
//
//  Created by Paul Taykalo on 12/8/15.
//  Copyright 2015 Paul Taykalo. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KWRACSignalMatcher.h"


SPEC_BEGIN(KWRACSignalMatcherSpec)

describe(@"KWRACSignalMatcher", ^{
    
    context(@"When asked about supported types", ^{
        it(@"should work with RACSignal", ^{
            [[theValue([KWRACSignalMatcher canMatchSubject:[RACSignal return:@NO]]) should] beTrue];
        });
        it(@"should not work with simple objects", ^{
            [[theValue([KWRACSignalMatcher canMatchSubject:[NSObject new]]) should] beFalse];
        });
    });

});

SPEC_END
