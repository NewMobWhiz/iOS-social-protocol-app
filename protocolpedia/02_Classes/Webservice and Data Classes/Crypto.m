//
//  Crypto.m
//  ProtocolPedia
//
//   7/19/10.


#import "Crypto.h"
#import <CommonCrypto/CommonCryptor.h>



@implementation Crypto

+ (NSString*) encryptPassword:(NSString*)password withKey: (NSString *)key {
	
//	NSLog(@"key lengtha %i",[key length]);

	
	NSMutableData *passwordData = (NSMutableData*)[password dataUsingEncoding:NSASCIIStringEncoding];
	
	char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	

	
	NSUInteger dataLength = [passwordData length];
	size_t bufferSize = kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	size_t numBytesEncrypted = 0;
	
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
										  keyPtr, kCCKeySizeAES128,
										  NULL /* initialization vector (optional) */,
										  [passwordData bytes], dataLength, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesEncrypted);
										  
//	NSLog(@"numBytesEncrypted %i",numBytesEncrypted);
//	NSLog(@"bufferSize %i",bufferSize);


	
	if (cryptStatus == kCCSuccess) {
		NSMutableString *hexString = (NSMutableString*)[self dataToHex:[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted]];
		NSString *encryptedPassword = [[NSString alloc] initWithString:hexString];
		return encryptedPassword;
	}
	return nil;
}


+ (NSString*) decryptPassword:(NSString*)encryptedPassword withKey: (NSString *)key {
	
	
	// convert hex to NSData
	NSMutableData *encryptedPasswordData = (NSMutableData*)[self hexToData:encryptedPassword];
	
	char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	NSUInteger dataLength = [encryptedPasswordData length];
	size_t bufferSize = dataLength;
	void *buffer = malloc(bufferSize);
	size_t numBytesDecrypted = 0;
	
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
										  keyPtr, kCCKeySizeAES128,
										  NULL /* initialization vector (optional) */,
										  [encryptedPasswordData bytes], dataLength, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesDecrypted);
	
	if (cryptStatus == kCCSuccess) {
		NSString *password = [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted] encoding:NSASCIIStringEncoding];
		return password;
	}
	return nil;
}



+(NSString*) dataToHex:(NSData*)dataToConvert {
	
	NSMutableString *hexStringTemp = [[NSMutableString alloc] init];
	char tempByte;

	for (int b = 0;b < [dataToConvert length];b++) {
		[dataToConvert getBytes:&tempByte range:NSMakeRange(b, 1)]; 
		
		NSUInteger highNibbleTemp =  tempByte >> 4;  // shift 4 bits to the left
		NSUInteger highNibble = highNibbleTemp & 0xF;  // look at only 4 least signifcant bits
		NSUInteger lowNibble =  tempByte & 0xF; // look at only 4 least signifcant bits 
		NSString *result1 = @"";
		NSString *result2 = @"";
		
		switch (highNibble)  {
			case 0: result1 = @"0"; break;
			case 1: result1 = @"1"; break;
			case 2: result1 = @"2"; break;
			case 3: result1 = @"3"; break;
			case 4: result1 = @"4"; break;
			case 5: result1 = @"5"; break;
			case 6: result1 = @"6"; break;
			case 7: result1 = @"7"; break;
			case 8: result1 = @"8"; break;
			case 9: result1 = @"9"; break;
			case 10: result1 = @"A"; break;
			case 11:  result1 = @"B"; break;
			case 12:  result1 = @"C"; break;
			case 13:  result1 = @"D"; break;
			case 14:  result1 = @"E"; break;
			case 15:  result1 = @"F"; break;
        }
		[hexStringTemp appendString:result1];
//		result1 = @"";
		
		
		switch (lowNibble) {
			case 0: result2 = @"0"; break;
			case 1: result2 = @"1"; break;
			case 2: result2 = @"2"; break;
			case 3: result2 = @"3"; break;
			case 4: result2 = @"4"; break;
			case 5: result2 = @"5"; break;
			case 6: result2 = @"6"; break;
			case 7: result2 = @"7"; break;
			case 8: result2 = @"8"; break;
			case 9: result2 = @"9"; break;
			case 10: result2 = @"A"; break;
			case 11:  result2 = @"B"; break;
			case 12:  result2 = @"C"; break;
			case 13:  result2 = @"D"; break;
			case 14:  result2 = @"E"; break;
			case 15:  result2 = @"F"; break;
		}
		[hexStringTemp appendString:result2];
//		result2 = @"";
		
	}
	NSString *hexString = [[NSString alloc] initWithString:hexStringTemp];
	return hexString;
}


+(NSData*) hexToData:(NSString*)hexToConvert {
	
	NSMutableData *nonHexData = [[NSMutableData alloc] init];
	
	NSString *highCharacter;
	NSString *lowCharacter;
	NSUInteger result1 = 0;
	NSUInteger result2 = 0;
	
	for (int d=0; d < [hexToConvert length]/2; d++) {
		highCharacter = [hexToConvert substringWithRange:NSMakeRange(d*2, 1)];
		lowCharacter = [hexToConvert substringWithRange:NSMakeRange(d*2+1, 1)];
		
		if ([highCharacter isEqualToString:@"0"]) {result1 = 0;}
		else if ([highCharacter isEqualToString:@"1"]) {result1 = 1;}
		else if ([highCharacter isEqualToString:@"2"]) {result1 = 2;}
		else if ([highCharacter isEqualToString:@"3"]) {result1 = 3;}
		else if ([highCharacter isEqualToString:@"4"]) {result1 = 4;}
		else if ([highCharacter isEqualToString:@"5"]) {result1 = 5;}
		else if ([highCharacter isEqualToString:@"6"]) {result1 = 6;}
		else if ([highCharacter isEqualToString:@"7"]) {result1 = 7;}
		else if ([highCharacter isEqualToString:@"8"]) {result1 = 8;}
		else if ([highCharacter isEqualToString:@"9"]) {result1 = 9;}
		else if ([highCharacter isEqualToString:@"A"]) {result1 = 10;}
		else if ([highCharacter isEqualToString:@"B"]) {result1 = 11;}
		else if ([highCharacter isEqualToString:@"C"]) {result1 = 12;}
		else if ([highCharacter isEqualToString:@"D"]) {result1 = 13;}
		else if ([highCharacter isEqualToString:@"E"]) {result1 = 14;}
		else if ([highCharacter isEqualToString:@"F"]) {result1 = 15;}
		
		if ([lowCharacter isEqualToString:@"0"]) {result2 = 0;}
		else if ([lowCharacter isEqualToString:@"1"]) {result2 = 1;}
		else if ([lowCharacter isEqualToString:@"2"]) {result2 = 2;}
		else if ([lowCharacter isEqualToString:@"3"]) {result2 = 3;}
		else if ([lowCharacter isEqualToString:@"4"]) {result2 = 4;}
		else if ([lowCharacter isEqualToString:@"5"]) {result2 = 5;}
		else if ([lowCharacter isEqualToString:@"6"]) {result2 = 6;}
		else if ([lowCharacter isEqualToString:@"7"]) {result2 = 7;}
		else if ([lowCharacter isEqualToString:@"8"]) {result2 = 8;}
		else if ([lowCharacter isEqualToString:@"9"]) {result2 = 9;}
		else if ([lowCharacter isEqualToString:@"A"]) {result2 = 10;}
		else if ([lowCharacter isEqualToString:@"B"]) {result2 = 11;}
		else if ([lowCharacter isEqualToString:@"C"]) {result2 = 12;}
		else if ([lowCharacter isEqualToString:@"D"]) {result2 = 13;}
		else if ([lowCharacter isEqualToString:@"E"]) {result2 = 14;}
		else if ([lowCharacter isEqualToString:@"F"]) {result2 = 15;}
		
		char temp = result1 << 4 | result2;
		NSData *tempData = [NSData dataWithBytes:&temp length:1];
		[nonHexData appendData:tempData];
	}
	return nonHexData;
}
//
//
//
//+(NSString*) hexToString:(NSString*)hexToConvert {
//
//	
//	NSMutableString *nonHexString = (NSMutableString*)[[[NSMutableString alloc] init] autorelease];
////	NSMutableString *testHexString = (NSMutableString*)[[NSMutableString alloc] init];
//	
//	NSString *highCharacter;
//	NSString *lowCharacter;
//	NSUInteger result1;
//	NSUInteger result2;
//
//	
//	for (int d=0; d < [hexToConvert length]/2; d++) {
//		highCharacter = [hexToConvert substringWithRange:NSMakeRange(d*2, 1)];
//		lowCharacter = [hexToConvert substringWithRange:NSMakeRange(d*2+1, 1)];
//		
//		if ([highCharacter isEqualToString:@"0"]) {result1 = 0;}
//		else if ([highCharacter isEqualToString:@"1"]) {result1 = 1;}
//		else if ([highCharacter isEqualToString:@"2"]) {result1 = 2;}
//		else if ([highCharacter isEqualToString:@"3"]) {result1 = 3;}
//		else if ([highCharacter isEqualToString:@"4"]) {result1 = 4;}
//		else if ([highCharacter isEqualToString:@"5"]) {result1 = 5;}
//		else if ([highCharacter isEqualToString:@"6"]) {result1 = 6;}
//		else if ([highCharacter isEqualToString:@"7"]) {result1 = 7;}
//		else if ([highCharacter isEqualToString:@"8"]) {result1 = 8;}
//		else if ([highCharacter isEqualToString:@"9"]) {result1 = 9;}
//		else if ([highCharacter isEqualToString:@"A"] || [highCharacter isEqualToString:@"a"]) {result1 = 10;}
//		else if ([highCharacter isEqualToString:@"B"] || [highCharacter isEqualToString:@"b"]) {result1 = 11;}
//		else if ([highCharacter isEqualToString:@"C"] || [highCharacter isEqualToString:@"c"]) {result1 = 12;}
//		else if ([highCharacter isEqualToString:@"D"] || [highCharacter isEqualToString:@"d"]) {result1 = 13;}
//		else if ([highCharacter isEqualToString:@"E"] || [highCharacter isEqualToString:@"e"]) {result1 = 14;}
//		else if ([highCharacter isEqualToString:@"F"] || [highCharacter isEqualToString:@"f"]) {result1 = 15;}
//		
//		if ([lowCharacter isEqualToString:@"0"]) {result2 = 0;}
//		else if ([lowCharacter isEqualToString:@"1"]) {result2 = 1;}
//		else if ([lowCharacter isEqualToString:@"2"]) {result2 = 2;}
//		else if ([lowCharacter isEqualToString:@"3"]) {result2 = 3;}
//		else if ([lowCharacter isEqualToString:@"4"]) {result2 = 4;}
//		else if ([lowCharacter isEqualToString:@"5"]) {result2 = 5;}
//		else if ([lowCharacter isEqualToString:@"6"]) {result2 = 6;}
//		else if ([lowCharacter isEqualToString:@"7"]) {result2 = 7;}
//		else if ([lowCharacter isEqualToString:@"8"]) {result2 = 8;}
//		else if ([lowCharacter isEqualToString:@"9"]) {result2 = 9;}
//		else if ([lowCharacter isEqualToString:@"A"] || [lowCharacter isEqualToString:@"a"]) {result2 = 10;}
//		else if ([lowCharacter isEqualToString:@"B"] || [lowCharacter isEqualToString:@"b"]) {result2 = 11;}
//		else if ([lowCharacter isEqualToString:@"C"] || [lowCharacter isEqualToString:@"c"]) {result2 = 12;}
//		else if ([lowCharacter isEqualToString:@"D"] || [lowCharacter isEqualToString:@"d"]) {result2 = 13;}
//		else if ([lowCharacter isEqualToString:@"E"] || [lowCharacter isEqualToString:@"e"]) {result2 = 14;}
//		else if ([lowCharacter isEqualToString:@"F"] || [lowCharacter isEqualToString:@"f"]) {result2 = 15;}
//		
////		char temp = result1 << 4 | result2;
//		unsigned char temp = result1 << 4 | result2;
//		
////		int test1 = result1 << 4 | result2;
////		int test2 = 0;
////		test2 = (int)temp;
//
////		if (test > 127) {
////			NSLog(@"hex value %i",temp);
////		}
////		NSString *warning;
////		if ((test1 - test2) != 0) {
////			warning = @"NO MATCH!";
////		} else {
////			warning = @"";
////		}
////
////		[testHexString appendFormat:@" %i, %C,  %i, %@       ",test1,temp, test2, warning];
//		
//		[nonHexString appendFormat:@"%C",temp];
//	}
////	NSError *myError;
////	[testHexString appendFormat:@",   %@",nonHexString];
//	
////	NSLog(@"testHexString %@\n\n\n",testHexString);
//////	NSString *testHexStringPath = [GlobalMethods dataFilePathofBundle:@"testHex.txt"]; 
//////	BOOL ok = [testHexString writeToFile:testHexStringPath atomically:YES encoding:NSASCIIStringEncoding error:&myError];
//////	if (ok != YES) {NSLog(@"testHexStringTemp did not save!");}
////	[testHexString release];
//	
//// NSLog(@"nonHexString %@",nonHexString);
//	return nonHexString;
//	
//
//
//}
//
//
//+(NSString*) stringToHex:(NSString*)stringToConvert {
//	
//	NSMutableString *hexStringTemp = [[NSMutableString alloc] init];
//	
////	NSLog(@"string %@",stringToConvert);
////	NSLog(@"string length %i",[stringToConvert length]);
//	
//	char tempByte;
//	NSMutableData *stringData = (NSMutableData*)[stringToConvert dataUsingEncoding:NSASCIIStringEncoding];
////	NSLog(@"string # of bytes %i", [stringData length]);
//	
//		for (int b = 0;b < [stringData length];b++) {
//			[stringData getBytes:&tempByte range:NSMakeRange(b, 1)]; 
//		
//		NSUInteger highNibbleTemp =  tempByte >> 4;  // shift 4 bits to the left
//		NSUInteger highNibble = highNibbleTemp & 0xF;  // look at only 4 least signifcant bits
//		NSUInteger lowNibble =  tempByte & 0xF; // look at only 4 least signifcant bits 
//		NSString *result1;
//		NSString *result2;
//		
//		switch (highNibble)  {
//			case 0: result1 = @"0"; break;
//			case 1: result1 = @"1"; break;
//			case 2: result1 = @"2"; break;
//			case 3: result1 = @"3"; break;
//			case 4: result1 = @"4"; break;
//			case 5: result1 = @"5"; break;
//			case 6: result1 = @"6"; break;
//			case 7: result1 = @"7"; break;
//			case 8: result1 = @"8"; break;
//			case 9: result1 = @"9"; break;
//			case 10: result1 = @"A"; break;
//			case 11:  result1 = @"B"; break;
//			case 12:  result1 = @"C"; break;
//			case 13:  result1 = @"D"; break;
//			case 14:  result1 = @"E"; break;
//			case 15:  result1 = @"F"; break;
//        }
//		[hexStringTemp appendString:result1];
//		result1 = @"";
//		
//		
//		switch (lowNibble) {
//			case 0: result2 = @"0"; break;
//			case 1: result2 = @"1"; break;
//			case 2: result2 = @"2"; break;
//			case 3: result2 = @"3"; break;
//			case 4: result2 = @"4"; break;
//			case 5: result2 = @"5"; break;
//			case 6: result2 = @"6"; break;
//			case 7: result2 = @"7"; break;
//			case 8: result2 = @"8"; break;
//			case 9: result2 = @"9"; break;
//			case 10: result2 = @"A"; break;
//			case 11:  result2 = @"B"; break;
//			case 12:  result2 = @"C"; break;
//			case 13:  result2 = @"D"; break;
//			case 14:  result2 = @"E"; break;
//			case 15:  result2 = @"F"; break;
//		}
//		[hexStringTemp appendString:result2];
//		result2 = @"";
//		
//	}
//	NSString *hexString = [[[NSString alloc] initWithString:hexStringTemp] autorelease];
//	[hexStringTemp release];
////	
////	NSMutableData *stringDatatemp = (NSMutableData*)[hexString dataUsingEncoding:NSASCIIStringEncoding];
////	NSLog(@"hexString length %i",[hexString length]);
////	NSLog(@"hexString number of bytes %i",[stringDatatemp length]);
//	
//	return hexString;
//}


@end
