//
//  NSMutableDictionary+setObjectIfNotNil.h
//  HAPLOID
//
//  Created by Pierre-Olivier Marec on 06/10/10.
//  Copyright 2010 HAPLOID. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (NSMutableDictionary_setObjectIfNotNil)

// Call set object for key if anObject is not nil
- (void)setObjectIfNotNil:(id)anObject forKey:(id)aKey;
- (void)filterKeysWithKeys:(NSArray *)keys;	// Keep only objects and keys of key present in keys

@end
