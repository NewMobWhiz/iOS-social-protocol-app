//
//  KeychainItems.m
//  KaseyaiPhoneAppWireframe
//
//   2/9/10.


#import "KeychainItems.h"


@implementation KeychainItems

@synthesize username;
@synthesize password;






-(NSMutableArray*)getKeychainItemsAttributes {

	OSStatus keychainErr = noErr;
	NSMutableDictionary *passwordQuery = [[NSMutableDictionary alloc] init];
	[passwordQuery setObject:(id)CFBridgingRelease(kSecClassGenericPassword) forKey:(id)CFBridgingRelease(kSecClass)];
	NSData *keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier length:strlen((const char *)kKeychainItemIdentifier)];
	[passwordQuery setObject:keychainItemID forKey:(id)CFBridgingRelease(kSecAttrGeneric)];
	[passwordQuery setObject:(id)CFBridgingRelease(kSecMatchLimitAll) forKey:(id)CFBridgingRelease(kSecMatchLimit)];
	[passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)CFBridgingRelease(kSecReturnAttributes)];
	NSMutableDictionary *outDictionary = nil;
	
	// If the keychain item exists, return the attributes of the item: 
//	NSArray *keychainDataArray = [[[NSArray alloc] init] autorelease];
	NSMutableArray *keychainDataArray = [[NSMutableArray alloc] init] ;
	keychainErr = SecItemCopyMatching((CFDictionaryRef)CFBridgingRetain(passwordQuery), (void *)&outDictionary);
	if (keychainErr == noErr) {
		// Convert the data dictionary into the format used by the view controller:
				if ([outDictionary count] > 0) {
					for (id dict in outDictionary) {
						[keychainDataArray addObject:[self secItemFormatToDictionary:dict]];
					}
				}
	} else if (keychainErr == errSecItemNotFound) {
		// Put default values into the keychain if no matching
		// keychain item is found:
		NSLog (@" No keychain found.\n");
		keychainDataArray = nil;
	} else {
		// Any other error is unexpected.
		NSLog (@" Serious error reading keychain items.\n");
	}
	//[outArray release];
	//NSLog(@"passwordQuery %@",passwordQuery);
	//NSLog(@"keychainDataArray %@",keychainDataArray);

	return keychainDataArray;
}

//-(void) saveExistingKeychainItem {
//	
//	// build query dictionary
//	OSStatus keychainErr = noErr;
//	NSMutableDictionary *passwordQuery = [[NSMutableDictionary alloc] init];
//	[passwordQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
//	NSData *keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier length:strlen((const char *)kKeychainItemIdentifier)];
//	[passwordQuery setObject:keychainItemID forKey:(id)kSecAttrGeneric];
//	[passwordQuery setObject:(id)kSecMatchLimitAll forKey:(id)kSecMatchLimit];
//	[passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
//	[passwordQuery setObject:self.description forKey:(id)kSecAttrDescription];
//	
//	// delete any existing keychain items
//	keychainErr = SecItemDelete((CFDictionaryRef)passwordQuery);
//	if (keychainErr != noErr) {
//		NSLog(@"Error deleting keychain.\n");
//	}
//	
//	// release objects
//	[passwordQuery release];
//
//}



//-(void) saveExistingKeychainItem {
//
//	// build query dictionary
//	OSStatus keychainErr = noErr;
//	NSMutableDictionary *passwordQuery = [[NSMutableDictionary alloc] init];
//	[passwordQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
//	NSData *keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier length:strlen((const char *)kKeychainItemIdentifier)];
//	[passwordQuery setObject:keychainItemID forKey:(id)kSecAttrGeneric];
//	[passwordQuery setObject:(id)kSecMatchLimitAll forKey:(id)kSecMatchLimit];
//	[passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
//	[passwordQuery setObject:self.description forKey:(id)kSecAttrDescription];
//	NSMutableDictionary *outDictionary = nil;
//	
//	// get existing keychain item
//	keychainErr = SecItemCopyMatching((CFDictionaryRef)passwordQuery, (CFTypeRef *)&outDictionary);
//	NSMutableDictionary *keychainDataSecItem;
//	// if existing keychain item found then
//	if (keychainErr == noErr) {
//		// convert to readaable into temp dict
//		NSMutableDictionary *keychainDataDict = [[NSMutableDictionary alloc] initWithDictionary:[self secItemFormatToDictionary:outDictionary]];
//	
//		// change data and attributes to new values	
//		[keychainDataDict setObject:self.username forKey:(id)kSecAttrLabel];
//		[keychainDataDict setObject:self.password forKey:(id)kSecValueData];
//		
//		// convert back to security format
//        keychainDataSecItem = [self dictionaryToSecItemFormat:keychainDataDict];
//		[keychainDataDict release];
//	// if existing keychain item not found then
//	} else if (keychainErr == errSecItemNotFound) {
//		NSLog(@"Existing keychain was not found.\n");
//	
//	// some other error
//	} else {
//		NSLog(@"Error trying to find existing keychain item.\n");
//	}
//	
//	// update existing keychain item
//	keychainErr = SecItemUpdate((CFDictionaryRef)passwordQuery, (CFDictionaryRef)keychainDataSecItem);
//	if (keychainErr != noErr) {
//		NSLog(@"Error in saving keychain.\n");
//	}
//	
//	// release objects
//	[passwordQuery release];
//	[outDictionary release];
//}

-(void) saveNewKeychainItem {


	// delete any existing keychain items
	// build query dictionary
	OSStatus keychainErr = noErr;
	NSMutableDictionary *passwordQuery = [[NSMutableDictionary alloc] init];
	[passwordQuery setObject:(id)CFBridgingRelease(kSecClassGenericPassword) forKey:(id)CFBridgingRelease(kSecClass)];
	NSData *keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier length:strlen((const char *)kKeychainItemIdentifier)];
	[passwordQuery setObject:keychainItemID forKey:(id)CFBridgingRelease(kSecAttrGeneric)];
	[passwordQuery setObject:(id)CFBridgingRelease(kSecMatchLimitAll) forKey:(id)CFBridgingRelease(kSecMatchLimit)];
	[passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)CFBridgingRelease(kSecReturnAttributes)];
	[passwordQuery setObject:self.description forKey:(id)CFBridgingRelease(kSecAttrDescription)];
	
	// delete any existing keychain items
	keychainErr = SecItemDelete((CFDictionaryRef)CFBridgingRetain(passwordQuery));
	if (keychainErr != noErr) {
		NSLog(@"Error deleting keychain.\n");
	}
	
	
	// add new keychain item
	NSMutableDictionary *keychainDataDict = [[NSMutableDictionary alloc] init]; 
	
	// add data and attributes	
	[keychainDataDict setObject:self.username forKey:(id)CFBridgingRelease(kSecAttrLabel)];
	[keychainDataDict setObject:self.password forKey:(id)CFBridgingRelease(kSecValueData)];
		
	// convert to security format
	NSMutableDictionary *keychainDataSecItem = [self dictionaryToSecItemFormat:keychainDataDict];
	
	// add new keychain item
	OSStatus keychainErr2 = noErr;
	keychainErr2 = SecItemAdd((CFDictionaryRef)CFBridgingRetain(keychainDataSecItem), NULL);
	if (keychainErr2 != noErr) {
		NSLog(@"Error in saving new keychain.\n");
	}
	
}

//-(void) deleteKeychainItem {
//	
//	// build query dictionary
//	OSStatus keychainErr = noErr;
//	NSMutableDictionary *passwordQuery = [[NSMutableDictionary alloc] init];
//	[passwordQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
//	NSData *keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier length:strlen((const char *)kKeychainItemIdentifier)];
//	[passwordQuery setObject:keychainItemID forKey:(id)kSecAttrGeneric];
//	[passwordQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
//	[passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
//	[passwordQuery setObject:self.username forKey:(id)kSecAttrLabel];
//
//
//
//	// delete existing keychain item
//	keychainErr = SecItemDelete((CFDictionaryRef)passwordQuery);
//	if (keychainErr != noErr) {
//		NSLog(@"Error in deleting keychain.\n");
//	}
//	//NSLog(@"keychainErr %@",keychainErr);
//	[passwordQuery release];
//}



- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert {
	
    // Create the return dictionary:
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
	
    // Add the keychain item class and the generic attribute:
    NSData *keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier length:strlen((const char *)kKeychainItemIdentifier)];
    [returnDictionary setObject:keychainItemID forKey:(id)CFBridgingRelease(kSecAttrGeneric)];
    [returnDictionary setObject:(id)CFBridgingRelease(kSecClassGenericPassword) forKey:(id)CFBridgingRelease(kSecClass)];
	
    // Convert the password NSString to NSData to fit the API paradigm:
    NSString *passwordString = [dictionaryToConvert objectForKey:(id)CFBridgingRelease(kSecValueData)];
    [returnDictionary setObject:[passwordString dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)CFBridgingRelease(kSecValueData)];
    return returnDictionary;
}


- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert {
	
    // Create a return dictionary populated with the attributes:
    NSMutableDictionary *returnDictionary = [NSMutableDictionary
											 dictionaryWithDictionary:dictionaryToConvert];
	
    [returnDictionary setObject:(id)kCFBooleanTrue forKey:(id)CFBridgingRelease(kSecReturnData)];
    [returnDictionary setObject:(id)CFBridgingRelease(kSecClassGenericPassword) forKey:(id)CFBridgingRelease(kSecClass)];
	
    // Then call Keychain Services to get the password:
    NSData *passwordData = NULL;
    OSStatus keychainError = noErr; //
    keychainError = SecItemCopyMatching((CFDictionaryRef)CFBridgingRetain(returnDictionary),
										(void *)&passwordData);
    if (keychainError == noErr)
    {
        // Remove the kSecReturnData key; we don't need it anymore:
        [returnDictionary removeObjectForKey:(id)CFBridgingRelease(kSecReturnData)];
		
        // Convert the password to an NSString and add it to the return dictionary:
        NSString *passwordtemp = [[NSString alloc] initWithBytes:[passwordData bytes]
														   length:[passwordData length] encoding:NSUTF8StringEncoding];
        [returnDictionary setObject:passwordtemp forKey:(id)CFBridgingRelease(kSecValueData)];
    }

    else if (keychainError == errSecItemNotFound) {
		NSAssert(NO, @"Nothing was found in the keychain.\n");
    }

    else
    {
        NSAssert(NO, @"Serious error.\n");
    }
	
    return returnDictionary;
}




@end
