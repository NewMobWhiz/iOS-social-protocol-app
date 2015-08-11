//
//  Crypto.h
//  ProtocolPedia
//
//   7/19/10.


#import <Foundation/Foundation.h>


@interface Crypto : NSObject {

}


+ (NSString*) encryptPassword:(NSString*)password withKey: (NSString *)key;
+ (NSString*) decryptPassword:(NSString*)encryptedPassword withKey: (NSString *)key;

+ (NSString*) dataToHex:(NSData*)dataToConvert;
+ (NSData*) hexToData:(NSString*)hexToConvert;
//+(NSString*) hexToString:(NSString*)hexToConvert;
//+(NSString*) stringToHex:(NSString*)stringToConvert;

@end
