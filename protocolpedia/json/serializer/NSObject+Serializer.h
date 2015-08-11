//
//  NSObject+Serializer.h
//  Untitled
//
//  Created by Pierre-Olivier Marec on 05/10/10.
//  Copyright 2010 HAPLOID. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSerializerMapFileName							@"SerializerMap"
#define kSerializerMapKeyClassToKeyToProperty			@"classToKeyToProperty"
#define kSerializerMapKeyClassToPropertyToClassName		@"classToPropertyToClassName"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark INTERFACE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSObject (NSObject_Serializer)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark FUNCTIONS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Returns an object represented by objectRepresentation (can be an array of objects if objectRepresentation is an array)
// Caution : works only with NSArray, NSDictionary, NSString, NSNumber, NSNull, BOOL and nil in objectRepresentation.
// Recommendation : avoid NSDictionary in your model.
+ (id)objectWithObjectRepresentation:(id)objectRepresentation
							andClass:(Class)aClass;	// Will be used for the object filled by objectRepresentation if it is a dictionary
													// or for the objects contained in objectRepresentation if it is an array

- (id)objectRepresentation;	// The exact opposite of objectWithObjectRepresentation


- (NSString *)descriptionFull;
/*// Subroutines of descriptionFull
- (NSString *)descriptionFullWithIndetation:(int)indentation;
- (NSString *)descriptionFullWithIndetation:(int)indentation withClass:(Class)aClass;*/

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark SerializerMap Functions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Helper function for propertyNameForClassAndKey and classForClassAndPropertyName
NSString *valueForCategoryAndClassAndKeyInSerializerMap(Class class, NSString * key, NSString *category);

// Helper function for keyForClassAndPropertyName
NSString *keyForCategoryAndClassAndValueInSerializerMap(Class class, NSString * value, NSString *category);

// Looks in SerializerMap and returns matching property name for class and key
// Returns key if no matching found
NSString *propertyNameForClassAndKey(Class class, NSString * key);

// Looks in SerializerMap and returns matching class for class and propertyName
// Returns class named propertyName if no matching found
Class classForClassAndPropertyName(Class class, NSString *propertyName);

// Looks in SerializerMap and returns key mapping to propertyName
// Returns propertyName if no matching found
NSString *keyForClassAndPropertyName(Class class, NSString * propertyName);
