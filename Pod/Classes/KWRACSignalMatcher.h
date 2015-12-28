//
//  KWRACSignalMatcher.h
//  KiwiRACMatchers
//
//  Created by Paul Taykalo on 12/8/15.
//  Copyright © 2015 Paul Taykalo. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface KWRACSignalMatcher : KWMatcher

- (void)complete;
- (void)sendNext:(id)value;
- (void)sendNextAndComplete:(id)value;
- (void)failWithError;
- (void)failWithError:(NSError *)error;

@end
