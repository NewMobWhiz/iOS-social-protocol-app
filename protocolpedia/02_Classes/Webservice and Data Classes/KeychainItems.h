//
//  KeychainItems.h
//  KaseyaiPhoneAppWireframe
//
//   2/9/10.


#import <Foundation/Foundation.h>


static const UInt8 kKeychainItemIdentifier[]    = "com.protocolpedia";  // what to make this??

@interface KeychainItems : NSObject {

	NSString *username;
	NSString *password;

}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

-(NSMutableArray*)getKeychainItemsAttributes;
//-(void) saveExistingKeychainItem;
-(void) saveNewKeychainItem;
//-(void) deleteKeychainItem;

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;



@end
