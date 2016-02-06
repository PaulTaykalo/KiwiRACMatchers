//
//  KWRACSignalMatcher.m
//  KiwiRACMatchers
//
//  Created by Paul Taykalo on 12/8/15.
//  Copyright © 2015 Paul Taykalo. All rights reserved.
//

#import "KWRACSignalMatcher.h"
#import <ReactiveCocoa/RACEXTScope.h>

typedef NS_ENUM(NSInteger, KWRACSignalState) {
    KWRACSignalStateReading,
    KWRACSignalStateCompleted,
    KWRACSignalStateFailed,
};

@interface KWRACValueWrapper : NSObject

@property(nonatomic, strong) id value;

@end

@implementation KWRACValueWrapper

- (BOOL)isEqual:(KWRACValueWrapper *)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;
    if (other.value == self.value) {
        return YES;
    }
    return [other.value isEqual:self.value];
}

@end

@interface KWRACSignalMatcher ()
@property(nonatomic, assign) KWRACSignalState matcherState;
@property(nonatomic, strong) NSMutableArray<KWRACValueWrapper *> *values;
@property(nonatomic, strong) NSError *error;
@property(nonatomic, copy) NSString *expectation;
@property(nonatomic, copy) BOOL (^verificationBlock)(KWRACSignalMatcher *);
@end

@implementation KWRACSignalMatcher

+ (BOOL)canMatchSubject:(id)anObject {
    return [anObject isKindOfClass:RACSignal.class];
}

- (id)initWithSubject:(RACSignal *)anObject {
    NSAssert([anObject isKindOfClass:RACSignal.class], @"Matcher %@ doesn't support objects of class %@", self, anObject);
    self = [super initWithSubject:anObject];
    if (self) {

        self.values = [NSMutableArray array];
        self.matcherState = KWRACSignalStateReading;

        @weakify(self);
        [[anObject
            takeUntil:self.rac_willDeallocSignal]
            subscribeNext:^(id x) {
                @strongify(self);
                KWRACValueWrapper *wrapper = [KWRACValueWrapper new];
                wrapper.value = x;
                [self.values addObject:wrapper];

            } error:^(NSError *error) {
            @strongify(self);
            self.matcherState = KWRACSignalStateFailed;
            self.error = error;
        }       completed:^{
            @strongify(self);
            self.matcherState = KWRACSignalStateCompleted;
        }];
    }
    return self;
}

#pragma mark - Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return @[
        @"sendNext:",
        @"sendNextValuePassingTest:"
        @"complete",
        @"failWithError",
        @"failWithError:",
        @"sendNextAndComplete:"
        ];
}


#pragma mark - Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected signal to %@", self.expectation];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"expected signal not to %@", self.expectation];
}

#pragma mark - Matching

- (BOOL)evaluate {
    NSAssert(self.verificationBlock, @"No matchers were set, please user one of %@", [[self class] matcherStrings] );
    return self.verificationBlock(self);
}


#pragma mark - Matchers

- (void)complete {
    self.expectation = @"complete";
    self.verificationBlock = ^BOOL(KWRACSignalMatcher *matcher) {
        return matcher.matcherState == KWRACSignalStateCompleted;
    };
}

- (void)sendNext:(id)value {
    self.expectation = [NSString stringWithFormat:@"send %@ value", value];
    self.verificationBlock = ^BOOL(KWRACSignalMatcher *matcher) {
        KWRACValueWrapper *wrapper = [[KWRACValueWrapper alloc] init];
        wrapper.value = value;
        return [matcher.values containsObject:wrapper];
    };
}

- (void)sendNextValuePassingTest:(BOOL(^)(id))verificationBlock {
    [self sendNextValuePassingTest:verificationBlock description:nil];
}

- (void)sendNextValuePassingTest:(BOOL(^)(id))verificationBlock description:(NSString *)description {
    if (description) {
        self.expectation = [NSString stringWithFormat:@"send value %@", description];
    } else {
        self.expectation = [NSString stringWithFormat:@"send value passing test"];
    }
    self.verificationBlock = ^BOOL(KWRACSignalMatcher *matcher) {
        for (KWRACValueWrapper *valueWrapper in matcher.values) {
            if (verificationBlock(valueWrapper.value)) {
                return YES;
            }
        }
        return NO;
    };
}


- (void)sendNextAndComplete:(id)value {
    self.expectation = [NSString stringWithFormat:@"send %@ value and complete", value];
    self.verificationBlock = ^BOOL(KWRACSignalMatcher *matcher) {
        KWRACValueWrapper *wrapper = [[KWRACValueWrapper alloc] init];
        wrapper.value = value;
        return [matcher.values containsObject:wrapper] && matcher.matcherState == KWRACSignalStateCompleted;
    };
}

- (void)failWithError {
    self.expectation = @"fail";
    self.verificationBlock = ^BOOL(KWRACSignalMatcher *matcher) {
        return matcher.matcherState == KWRACSignalStateFailed;
    };
}

- (void)failWithError:(NSError *)error {
    self.expectation = [NSString stringWithFormat:@"fail with error %@", error];
    self.verificationBlock = ^BOOL(KWRACSignalMatcher *matcher) {
        return matcher.matcherState == KWRACSignalStateFailed && error == matcher.error || [error isEqual:matcher.error];
    };
}

@end
