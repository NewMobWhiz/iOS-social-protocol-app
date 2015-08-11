//
//  NSThread+withBlocks.h
//  IDLogistics
//


#import <Foundation/Foundation.h>

@interface NSThread (withBlocks)

- (void)performBlock: (void (^)()) block waitUntilDone: (BOOL) wait;

@end


@implementation NSThread (withBlocks)

- (void) _plblock_execute: (void (^)()) block {
    block();
}

- (void)performBlock: (void (^)()) block waitUntilDone: (BOOL) wait {
	[self performSelector: @selector(_plblock_execute:)
                 onThread: self
               withObject: [block copy]
            waitUntilDone: wait];
}

@end
