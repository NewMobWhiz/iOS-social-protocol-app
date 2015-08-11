//
//  ChangeFavoriteProtocol.h
//  ProtocolPedia
//
//   8/11/10.


#import <Foundation/Foundation.h>



@interface ChangeFavoriteProtocol : NSObject <NSXMLParserDelegate> 
{

	NSString *protocolId;
	NSString *change;
	NSXMLParser *xmlParser;
	NSMutableString *contentOfCurrentProperty;
	NSString *faultCode;
	NSString *faultString;
	NSString *methodName;
	NSString *tableName;
	NSString *success;
	NSMutableData *newData;
	NSString *errorReceived;
	NSMutableURLRequest *thisRequest;
	int retries;
	
}

@property(nonatomic,retain) NSString *protocolId;
@property(nonatomic,retain) NSString *change;
@property(nonatomic, retain) NSString *errorReceived;
@property(nonatomic, retain) NSMutableURLRequest *thisRequest;
@property(nonatomic, assign) int retries;
@property(nonatomic,retain) NSXMLParser *xmlParser;
@property(nonatomic,retain) NSMutableString *contentOfCurrentProperty;
@property(nonatomic,retain) NSString *faultCode;
@property(nonatomic,retain) NSString *faultString;
@property(nonatomic,retain) NSString *methodName;
@property(nonatomic,retain) NSString *tableName;
@property(nonatomic,retain) NSString *success;
@property(nonatomic,retain) NSMutableData *thenewData;
	
-(void) changeFavoriteProtocolId:(NSString*)thisProtocolId withChange:(NSString*)thisChange withSessionId:(NSString*)thisSessionId;
-(void) createConnection;
-(void) enterIntoDatabase;
-(void) methodComplete;
	

@end
