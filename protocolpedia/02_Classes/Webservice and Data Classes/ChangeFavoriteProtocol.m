//
//  ChangeFavoriteProtocol.m
//  ProtocolPedia
//
//   8/11/10.


#import "ChangeFavoriteProtocol.h"
#import "SQLiteAccess.h"
#import "SOAPRequest.h"
#import "PPAppDelegate.h"

@implementation ChangeFavoriteProtocol

@synthesize protocolId;
@synthesize change;
@synthesize xmlParser;
@synthesize contentOfCurrentProperty;
@synthesize faultCode;
@synthesize faultString;
@synthesize methodName;
@synthesize tableName;
@synthesize success;
@synthesize errorReceived;
@synthesize thisRequest;
@synthesize thenewData;

@synthesize retries;


- (id) init {
	if (self = [super init]) {
		self.protocolId = nil;
		self.change = nil;
	}
	return self;
}


-(void) changeFavoriteProtocolId:(NSString*)thisProtocolId withChange:(NSString*)thisChange withSessionId:(NSString*)thisSessionId {
	PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
	if ([appDelegate.loginTime timeIntervalSinceDate:[NSDate date]] > 7100) {
		appDelegate.sessionId = nil;
		appDelegate.loggedIn = NO;
		appDelegate.loginTime = nil;
		self.errorReceived = @"Your login session has timed out";
		[self methodComplete];
	} else {

		self.protocolId = thisProtocolId;
		self.change = thisChange;
		self.retries = 0;
		self.errorReceived = nil;
		self.methodName = @"ChangeFavoriteProtocol";
		self.tableName = @"FavoriteProtocols";
		NSString *methodString = [NSString stringWithFormat:@"<SessionId xsi:type=\"xsd:string\">%@</SessionId>"
						  "<ProtocolId xsi:type=\"xsd:string\">%@</ProtocolId>"
						  "<Change xsi:type=\"xsd:string\">%@</Change>",
						  thisSessionId,
						  self.protocolId,
						  self.change
						  ];
		NSLog(@"methodString %@",methodString);

		self.thisRequest = [SOAPRequest getSOAPRequestForSOAPMethod:self.methodName withSessionId:methodString withTimeoutInterval:7];

		[self createConnection];
	}
	
	
}



#pragma mark download methods

-(void) createConnection  {
	
	// check if can make connection with server
	if ([GlobalMethods canConnect]) {
		// Create the Connection
		NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:self.thisRequest delegate:self startImmediately:YES];
		if (!conn) {
			self.errorReceived = @"Can't make connection to server";
			[self methodComplete];
		}
		
	} else {
		self.errorReceived = @"Can't make connection to internet";
		[self methodComplete];
	}
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	self.errorReceived = @"Received authentication challenge, Please logout and try again.";
	[self methodComplete];
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.thenewData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.thenewData setLength:0];
	self.thenewData = [NSMutableData data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	if (self.retries > 3) {
		self.errorReceived = [NSString stringWithFormat:@"error received %@",error];
		[self methodComplete];
	} else {
		self.retries++;
		//[GlobalMethods navbarStatusMessage:[NSString stringWithFormat:@"Retry %i to login",self.retries]];
		[self createConnection];
	}
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection  { 
//	NSLog(@"newData %@",[NSString stringWithCString:[self.newData bytes] encoding:NSASCIIStringEncoding]);
	NSXMLParser *tempXmlParser = [[NSXMLParser alloc] initWithData:self.thenewData];
	self.xmlParser =  tempXmlParser;
	[self.xmlParser setDelegate:self];
	[self.xmlParser setShouldResolveExternalEntities: YES];
	[self.xmlParser parse];
}


#pragma mark Parser methods


- (void)parserDidStartDocument:(NSXMLParser *)parser{
	self.contentOfCurrentProperty = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (self.contentOfCurrentProperty) {
        [self.contentOfCurrentProperty appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	int x = [parseError code];
	if (x < 95 && x > 0) {
		self.errorReceived = [parseError localizedDescription];
		[self methodComplete];
	}
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {	
	if (qName) {
        elementName = qName;
    }
	
	if ([elementName isEqualToString:@"Success"] ||
		[elementName isEqualToString:@"faultcode"] ||
		[elementName isEqualToString:@"faultstring"]) {
		self.contentOfCurrentProperty = (NSMutableString*)[NSMutableString string];
	} else {
        self.contentOfCurrentProperty = nil;
    }
}



- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (qName) {
        elementName = qName;
    }
	if ([elementName isEqualToString:@"faultcode"]) {
		self.faultCode = self.contentOfCurrentProperty;
	} else if ([elementName isEqualToString:@"faultstring"]) {
		self.faultString = self.contentOfCurrentProperty;
	}else if ([elementName isEqualToString:@"Success"]) {
		// replace null with empty string if needed.
		if (!self.contentOfCurrentProperty) { 
			self.contentOfCurrentProperty = (NSMutableString*)@"";
		}
		self.success = self.contentOfCurrentProperty;
	}
}



- (void)parserDidEndDocument:(NSXMLParser *)parser  {
//NSLog(@"self.success %@",self.success);

	if(self.faultCode || self.faultString) {
        NSLog(@"fault Code: %@\n faultString: %@ ", self.faultCode, self.faultString);
		self.errorReceived = [NSString stringWithFormat:@"Unable to %@ Favorite %@ from ProtocolPedia Server.", self.change,[SQLiteAccess selectOneValueSQL:[NSString stringWithFormat:@"SELECT Title FROM Protocols WHERE ProtocolID = \"%@\"",self.protocolId]]];
	} else {
		if ([self.success isEqualToString:@"Yes"]) {
			[self enterIntoDatabase];
		} else {
			self.errorReceived = [NSString stringWithFormat:@"Unable to %@ Favorite %@ from ProtocolPedia Server .", self.change,[SQLiteAccess selectOneValueSQL:[NSString stringWithFormat:@"SELECT Title FROM Protocols WHERE ProtocolID = \"%@\"",self.protocolId]]];
		NSLog(@"self.errorReceived %@",self.errorReceived);
		}
	}
	[self methodComplete];
}


-(void) enterIntoDatabase {
//NSLog(@"self.change  %@",self.change );

	if ([self.change isEqualToString:@"Add"]) {
		int returnValue = [[SQLiteAccess insertWithSQL:[NSString stringWithFormat:@"INSERT INTO FavoriteProtocols (ProtocolId) VALUES (\"%@\")",self.protocolId]] intValue];
		if (returnValue == 0) {
		//	NSLog(@"Add FavoriteProtocol returnValue = %i",returnValue);
//			self.errorReceived = [NSString stringWithFormat:@"Unable to %@ Favorite %@.", self.change,[SQLiteAccess selectOneValueSQL:[NSString stringWithFormat:@"SELECT Title FROM Protocols WHERE ProtocolID = \"%@\"",self.protocolId]]];
		}
	} else if ([self.change isEqualToString:@"Remove"]){
		[SQLiteAccess deleteWithSQL:[NSString stringWithFormat:@"DELETE FROM FavoriteProtocols WHERE ProtocolId = \"%@\"",self.protocolId]];
	//	NSLog(@"DELETE FavoriteProtocols:    %@",[NSString stringWithFormat:@"DELETE FROM FavoriteProtocols WHERE ProtocolId = \"%@\"",self.protocolId]);

	}
}



-(void) methodComplete {
	[GlobalMethods postNotification:self.methodName withObject:self];
}




@end
