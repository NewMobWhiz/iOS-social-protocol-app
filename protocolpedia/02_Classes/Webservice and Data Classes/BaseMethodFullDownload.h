//
//  BaseMethodFullDownload.h
//  ProtocolPedia
//
//   8/18/10.


#import <Foundation/Foundation.h>

//#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0
//@protocol NSXMLParserDelegate
//@end
//#endif


@interface BaseMethodFullDownload : NSObject //<NSXMLParserDelegate> 
{

	NSXMLParser *xmlParser;
	NSMutableString *contentOfCurrentProperty;
	NSMutableDictionary *object;
	NSString *faultCode;
	NSString *faultString;
	NSString *key;
	NSString *value;
	NSString *sqlStatement;
	NSString *methodName;
	NSString *postingName;
	NSString *tableName;
	NSString *sessionId;
	NSString *lastElement;
	NSMutableData *receivedRawData;
	NSString *receivedString;
	NSString *errorReceived;
	NSMutableURLRequest *thisRequest;
			
	int numberOfFields;
	int counter;
	int firstCheck;
	int retries;
	

	
}

@property(nonatomic, retain) NSMutableData *receivedRawData;
@property(nonatomic, retain) NSString *errorReceived;
@property(nonatomic, retain) NSMutableURLRequest *thisRequest;
@property(nonatomic,retain) NSXMLParser *xmlParser;
@property(nonatomic,retain) NSMutableString *contentOfCurrentProperty;
@property(nonatomic,retain) NSMutableDictionary *object;
@property(nonatomic,retain) NSString *faultCode;
@property(nonatomic,retain) NSString *faultString;
@property(nonatomic,retain) NSString *key;
@property(nonatomic,retain) NSString *value;
@property(nonatomic,retain) NSString *sqlStatement;
@property(nonatomic,retain) NSString *methodName;
@property(nonatomic,retain) NSString *tableName;
@property(nonatomic,retain) NSString *sessionId;
@property(nonatomic,retain) NSString *postingName;

@property(nonatomic,assign) int numberOfFields;
@property(nonatomic,assign) int counter;
@property(nonatomic,assign) int firstCheck;
@property(nonatomic, assign) int retries;


-(void) loadProperties;
-(void) getMethodNow;
-(void) deleteCurrentDatabase;
-(void) enterIntoDatabase;
-(NSString*) getSQL;

-(void) createConnection;


-(void) methodComplete;


@end
