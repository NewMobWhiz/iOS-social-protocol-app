//
//  GlobalMethods.h
//  ProtocolPedia
//
//   7/9/10.


#import <Foundation/Foundation.h>


@interface GlobalMethods : NSObject {

}

+ (NSString *)dataFilePathofDocuments:(NSString *)nameoffile;
+ (NSString *)dataFilePathofBundle:(NSString *)nameoffile;
+ (void) navbarStatusMessage:(NSString*)message;
+ (void) postNotification:(NSString*)postMessage withObject:(id)thisObject;
+ (void) receivedError:(NSString*)errorName;
+ (void) displayMessage:(NSString*)messageName;
+ (NSString *)zstringFromDate:(NSDate *)date;
+ (NSDate *)zdateFromString:(NSString *)stringDate;
+ (NSString*) getTimeElapsedFor:(NSDate*)startTime;
+ (BOOL) canConnect;

@end
