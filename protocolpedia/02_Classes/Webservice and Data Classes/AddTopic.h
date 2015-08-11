//
//  AddTopic.h
//  ProtocolPedia
//
//   9/10/10.


#import <Foundation/Foundation.h>
#import "GetForumDiscussions.h"



@interface AddTopic : NSObject <NSXMLParserDelegate>
{

	NSString *categoryId;
	NSString *subject;
	NSString *messageText;
	NSString *photo;
	NSXMLParser *xmlParser;
	NSMutableString *contentOfCurrentProperty;
	NSString *faultCode;
	NSString *faultString;
	NSString *methodName;
	NSString *threadId;
	NSMutableData *newData;
	NSString *errorReceived;
	NSMutableURLRequest *thisRequest;
	int retries;
	GetForumDiscussions *getForumDiscussions;
	
}

@property(nonatomic, retain) NSString *categoryId;
@property(nonatomic, retain) NSString *subject;
@property(nonatomic, retain) NSString *messageText;
@property(nonatomic, retain) NSString *photo;
@property(nonatomic, retain) NSString *errorReceived;
@property(nonatomic, retain) NSMutableURLRequest *thisRequest;
@property(nonatomic, assign) int retries;
@property(nonatomic,retain) NSXMLParser *xmlParser;
@property(nonatomic,retain) NSMutableString *contentOfCurrentProperty;
@property(nonatomic,retain) NSString *faultCode;
@property(nonatomic,retain) NSString *faultString;
@property(nonatomic,retain) NSString *methodName;
@property(nonatomic,retain) NSString *threadId;
@property(nonatomic,retain) NSMutableData *thenewData;
@property(nonatomic, retain) GetForumDiscussions *getForumDiscussions;

-(void) addTopicToThisForumCategory:(NSString*)thisCategoryId withSubject:(NSString*)thisSubject withMessageText:(NSString*)thisMessageText withPhoto:(NSData*)thisPhoto withSessionId:(NSString*)thisSessionId;
-(void) createConnection;
-(void) getForumDiscussionsMethod;
-(void) getForumDiscussionsComplete:(NSNotification *)notification;
-(void) methodComplete;
- (NSString *) base64StringFromData: (NSData *)data length: (int)length;

@end
