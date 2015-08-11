//
//  NSMutableDictionary+setObjectIfNotNil.m
//  HAPLOID
//
//  Created by Pierre-Olivier Marec on 06/10/10.
//  Copyright 2010 HAPLOID. All rights reserved.
//

#import "NSMutableDictionary+setObjectIfNotNil.h"


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark IMPLEMENTATION
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSMutableDictionary (NSMutableDictionary_setObjectIfNotNil)

- (void)setObjectIfNotNil:(id)anObject forKey:(id)aKey {
	if (anObject != nil)
		[self setObject:anObject forKey:aKey];
}

- (void)filterKeysWithKeys:(NSArray *)keys {
	NSMutableDictionary *keysToRemove = [[NSMutableDictionary alloc] initWithDictionary:self];
	[keysToRemove removeObjectsForKeys:keys];
	[self removeObjectsForKeys:[keysToRemove allKeys]];
}

@end
