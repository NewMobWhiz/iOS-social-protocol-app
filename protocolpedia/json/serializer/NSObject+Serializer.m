//
//  NSObject+Serializer.m
//  Untitled
//
//  Created by Pierre-Olivier Marec on 05/10/10.
//  Copyright 2010 HAPLOID. All rights reserved.
//

#import "NSObject+Serializer.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import "NSMutableDictionary+setObjectIfNotNil.h"

static NSDictionary *_SerializeMap = nil;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark IMPLEMENTATION
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSObject (NSObject_Serializer)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark FUNCTIONS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


+ (id)objectWithObjectRepresentation:(id)objectRepresentation andClass:(Class)aClass {
	// Test nullity of objectRepresentation
	if (objectRepresentation == nil || [objectRepresentation isEqual:[NSNull null]])
		return nil;
	
	// If objectRepresentation is an array
	else if ([objectRepresentation isKindOfClass:[NSArray class]]) {
		// We create an array of aClass objects represented by values of objectRepresentation
		NSMutableArray *response = [NSMutableArray arrayWithCapacity:[objectRepresentation count]];
		for (NSObject *arrayValue in (NSArray *)objectRepresentation)
			[response addObject:[[self class] objectWithObjectRepresentation:arrayValue andClass:aClass]];
		return response;
	}
	
	// If objectRepresentation is a dictionary
	else if ([objectRepresentation isKindOfClass:[NSDictionary class]]) {
		if (aClass == nil) {
			NSLog(@"Error : aClass null. Object will not be processed but returned");
		} else {
			// We create a new aClass object
			id response = [[aClass alloc] init];
			// And fill its properties with objectRepresentation values
			for (NSString *key in [(NSDictionary *)objectRepresentation allKeys]) {
				// We convert the key to the property name
				NSString *propertyName = propertyNameForClassAndKey(aClass, key);
				// We get the property
				objc_property_t property = class_getProperty(aClass, [propertyName UTF8String]);
				// If we found a property
				if (property != NULL) {
					// We set the value of this property
					id value = [objectRepresentation objectForKey:key];
					Class valueClass = classForClassAndPropertyName(aClass, propertyName);
					NSObject *valueRepresentation = [NSObject objectWithObjectRepresentation:value andClass:valueClass];
					if (valueRepresentation != nil)
						[response setValue:valueRepresentation forKey:propertyName];
				}
			}
			return [response autorelease];
		}
	}
	
	return [[objectRepresentation retain] autorelease];
}

- (id)objectRepresentation {
	id result = nil;
	
	NSString *selfClassName = [[NSString alloc] initWithCString:class_getName([self class])];
	Class classInThisProjet = [[NSBundle mainBundle] classNamed:selfClassName];
	// Will be nil if class is from a framework (typically primary ones like NSString, NSNumber, etc.)
	[selfClassName release];
	
	if (classInThisProjet == nil) {	// self is not an object of this project
		result = [[self retain] autorelease];
		
	} else if ([self isKindOfClass:[NSArray class]]) {
		result = [NSMutableArray arrayWithCapacity:[(NSArray*)self count]];
		for (NSObject *object in (NSArray*)self)
			[(NSMutableArray*)result addObject:[object objectRepresentation]];
		
	} else if ([self isKindOfClass:[NSDictionary class]]) {
		result = [NSMutableDictionary dictionary];
		for (NSObject *key in [(NSDictionary*)self allKeys])
			[(NSMutableDictionary*)result setObjectIfNotNil:[[(NSDictionary*)self objectForKey:key] objectRepresentation] forKey:key];
		
	} else { // We create a dictionary representing self properties and properties of its superclasses
		result = [NSMutableDictionary dictionary];
		while (classInThisProjet != nil) {
			
			unsigned int outCount, i;
			objc_property_t *properties = class_copyPropertyList(classInThisProjet, &outCount);
			for (i = 0; i < outCount; i++) {
				const char *propertyName = property_getName(properties[i]);
				NSString *propertyNameString = [[NSString alloc] initWithCString:propertyName];
				NSString *mappedPropertyNameString = keyForClassAndPropertyName([self class], propertyNameString);
				[(NSMutableDictionary*)result setObjectIfNotNil:[[self valueForKey:propertyNameString] objectRepresentation] forKey:mappedPropertyNameString];
				[propertyNameString release];
				
			}
			free(properties);
			NSString *selfClassName = [[NSString alloc] initWithCString:class_getName([classInThisProjet superclass])];
			classInThisProjet = [[NSBundle mainBundle] classNamed:selfClassName];
			[selfClassName release];
		}
	}
	return result;
}

- (NSString *)descriptionFull {
	return [[self objectRepresentation] description];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark SerializerMap Functions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

NSString *valueForCategoryAndClassAndKeyInSerializerMap(Class class, NSString * key, NSString *category) {
	// Default response
	NSString *response = nil;
	
	// We retrieve the SerializerMap
	if (_SerializeMap == nil || !_SerializeMap)
		_SerializeMap = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kSerializerMapFileName ofType:@"plist"]];
	// We retrieve the dictionary in category
	NSDictionary *CategoryOfSerializerMap = [[_SerializeMap objectForKey:category] retain];
	
	if (CategoryOfSerializerMap != nil) {
		// We retrieve dictionary in class for category
		NSDictionary *classOfCategoryOfSerializerMap = [[CategoryOfSerializerMap objectForKey:[class description]] retain];
		[CategoryOfSerializerMap release];
		if (classOfCategoryOfSerializerMap != nil) {
			// We retrieve the value for key for class and category
			NSString *value = [[classOfCategoryOfSerializerMap objectForKey:key] retain];
			[classOfCategoryOfSerializerMap release];
			if (value != nil) {
				response = [NSString stringWithString:value];
				[value release];
			}
		}
	}
	
	return response;
}

NSString *propertyNameForClassAndKey(Class class, NSString * key) {
	NSString *value = nil;
	Class currentClass = class;
	while (value == nil && currentClass != [NSObject class]) {
		value = valueForCategoryAndClassAndKeyInSerializerMap(currentClass, key, kSerializerMapKeyClassToKeyToProperty);
		currentClass = [currentClass superclass];
	}
	if (value == nil)
		return key;
	return value;
}

Class classForClassAndPropertyName(Class class, NSString *propertyName) {
	NSString *value = nil;
	Class currentClass = class;
	while (value == nil && currentClass != [NSObject class]) {
		value = valueForCategoryAndClassAndKeyInSerializerMap(currentClass, propertyName, kSerializerMapKeyClassToPropertyToClassName);
		currentClass = [currentClass superclass];
	}
	if (value == nil)
		return [[NSBundle mainBundle] classNamed:propertyName];
	return [[NSBundle mainBundle] classNamed:value];
}

NSString *keyForCategoryAndClassAndValueInSerializerMap(Class class, NSString * value, NSString *category) {
	// Default response
	NSString *response = nil;
	
	// We retrieve the SerializerMap
	if (_SerializeMap == nil || !_SerializeMap)
		_SerializeMap = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kSerializerMapFileName ofType:@"plist"]];
	// We retrieve the dictionary in category
	NSDictionary *CategoryOfSerializerMap = [[_SerializeMap objectForKey:category] retain];
	
	if (CategoryOfSerializerMap != nil) {
		// We retrieve dictionary in class for category
		NSDictionary *classOfCategoryOfSerializerMap = [[CategoryOfSerializerMap objectForKey:[class description]] retain];
		[CategoryOfSerializerMap release];
		if (classOfCategoryOfSerializerMap != nil) {
			// We retrieve the key for value for class and category
			NSArray *keys = [[classOfCategoryOfSerializerMap allKeysForObject:value] retain];
			[classOfCategoryOfSerializerMap release];
			if ([keys count] > 0)
				response = [NSString stringWithString:[keys objectAtIndex:0]];
			[keys release];
		}
	}
	
	return response;	
}

NSString *keyForClassAndPropertyName(Class class, NSString * propertyName) {
	NSString *key = nil;
	Class currentClass = class;
	while (key == nil && currentClass != [NSObject class]) {
		key = keyForCategoryAndClassAndValueInSerializerMap(currentClass, propertyName, kSerializerMapKeyClassToKeyToProperty);
		currentClass = [currentClass superclass];
	}
	if (key == nil)
		return propertyName;
	return key;
}
