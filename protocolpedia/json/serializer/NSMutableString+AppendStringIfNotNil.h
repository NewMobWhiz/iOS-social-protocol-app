//
//  NSMutableString+AppendStringIfNotNil.h
//  HAPLOID
//
//  Created by Pierre-Olivier Marec on 20/10/10.
//  Copyright 2010 HAPLOID. All rights reserved.
//

#import <Foundation/Foundation.h>

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark INTERFACE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSMutableString (AppendStringIfNotNil)

- (void)appendStringIfNotNil:(NSString *)aString;

@end
