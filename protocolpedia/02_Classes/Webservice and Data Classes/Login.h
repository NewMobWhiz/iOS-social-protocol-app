//
//  Login.h
//  ProtocolPedia
//
//   7/16/10.


#import <Foundation/Foundation.h>



@interface Login : NSObject //<NSXMLParserDelegate> 
{

	NSString *username;
	NSString *password;
	NSString *coveredPassword;
	NSXMLParser *xmlParser;
	NSMutableString *contentOfCurrentProperty;
	NSString *faultCode;
	NSString *faultString;
	NSString *sessionId;
	NSMutableData *receivedRawData;
	NSString *receivedString;
	NSString *errorReceived;
	NSMutableURLRequest *thisRequest;

	int retries;


}

@property(nonatomic,retain) NSString *username;
@property(nonatomic,retain) NSString *password;
@property(nonatomic,retain) NSString *coveredPassword;
@property(nonatomic,retain) NSXMLParser *xmlParser;
@property(nonatomic,retain) NSMutableString *contentOfCurrentProperty;
@property(nonatomic,retain) NSString *faultCode;
@property(nonatomic,retain) NSString *faultString;
@property(nonatomic,retain) NSString *sessionId;
@property(nonatomic, retain) NSMutableData *receivedRawData;
@property(nonatomic, retain) NSString *receivedString;
@property(nonatomic, retain) NSString *errorReceived;
@property(nonatomic, retain) NSMutableURLRequest *thisRequest;

@property(nonatomic, assign) int retries;



-(void) getAuthenticationWithUsername:(NSString*)thisUsername  andPassword:(NSString*)thisPassword;
-(NSMutableURLRequest*) getSOAPRequest;
-(BOOL) canConnect;
-(void) createConnection;
-(void) parseAuthentication;
-(void) loginComplete;




@end
