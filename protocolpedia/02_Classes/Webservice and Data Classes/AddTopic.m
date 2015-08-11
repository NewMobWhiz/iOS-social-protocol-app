//
//  AddTopic.m
//  ProtocolPedia
//
//   9/10/10.


#import "AddTopic.h"
#import "SQLiteAccess.h"
#import "SOAPRequest.h"
#import "PPAppDelegate.h"


static char base64EncodingTable[64] = {
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
	'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
	'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
	'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation AddTopic

@synthesize categoryId;
@synthesize subject;
@synthesize messageText;
@synthesize photo;
@synthesize xmlParser;
@synthesize contentOfCurrentProperty;
@synthesize faultCode;
@synthesize faultString;
@synthesize methodName;
@synthesize threadId;
@synthesize errorReceived;
@synthesize thisRequest;
@synthesize thenewData;
@synthesize getForumDiscussions;

@synthesize retries;

-(void) addTopicToThisForumCategory:(NSString*)thisCategoryId withSubject:(NSString*)thisSubject withMessageText:(NSString*)thisMessageText withPhoto:(NSData*)thisPhoto withSessionId:(NSString*)thisSessionId {	
	PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
	if ([appDelegate.loginTime timeIntervalSinceDate:[NSDate date]] > 7100) {
		appDelegate.sessionId = nil;
		appDelegate.loggedIn = NO;
		appDelegate.loginTime = nil;
		self.errorReceived = @"Your login session has timed out";
		[self methodComplete];
	} else {
		
		self.subject = thisSubject;
		self.retries = 0;
		self.errorReceived = nil;

		NSString *photoString = [self base64StringFromData:thisPhoto length:[thisPhoto length]];

		NSString *methodString = [NSString stringWithFormat:@"<SessionId xsi:type=\"xsd:string\">%@</SessionId>"
								  "<CategoryId xsi:type=\"xsd:string\">%@</CategoryId>"
								  "<Subject xsi:type=\"xsd:string\">%@</Subject>"
								  "<MessageText xsi:type=\"xsd:string\">%@</MessageText>"
								  "<Photo xsi:type=\"xsd:string\">%@</Photo>",
								  thisSessionId,
								  thisCategoryId,
								  thisSubject,
								  thisMessageText,
								  photoString
								  ];
		NSLog(@"msthodString = %@",methodString);

		self.thisRequest = [SOAPRequest getSOAPRequestForSOAPMethod:@"AddToTopic" withSessionId:methodString withTimeoutInterval:7];
		
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
	
	if ([elementName isEqualToString:@"ThreadId"] ||
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
	}else if ([elementName isEqualToString:@"ThreadId"]) {
		// replace null with empty string if needed.
		if (!self.contentOfCurrentProperty) { 
			self.contentOfCurrentProperty = (NSMutableString*)@"";
		}
		self.threadId = self.contentOfCurrentProperty;
	}
}



- (void)parserDidEndDocument:(NSXMLParser *)parser  {
	//NSLog(@"self.success %@",self.success);
	
	if(self.faultCode || self.faultString) {
		self.errorReceived = [NSString stringWithFormat:@"Unable to add Forum Subject %@", self.subject];
		NSLog(@"faultcode %@",self.faultCode);
		NSLog(@"faultString %@",self.faultString);
		[self methodComplete];
	} else {
		NSLog(@"self.threadId %@",self.threadId);
		if ([self.threadId length]>0) {
			[self getForumDiscussionsMethod];
		} else {
			self.errorReceived = [NSString stringWithFormat:@"Unable to add Forum Subject %@", self.subject];
			NSLog(@"self.errorReceived %@",self.errorReceived);
			[self methodComplete];
		}
	}
	
}



-(void) getForumDiscussionsMethod {
	@autoreleasepool {
	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter addObserver:self selector:@selector(getForumDiscussionsComplete:) name:@"GetForumDiscussions" object:nil];
	
	GetForumDiscussions *tempGetForumDiscussions = [[GetForumDiscussions alloc] init];
	self.getForumDiscussions = tempGetForumDiscussions;
	[self.getForumDiscussions getMethodNow];	
	
	}
	
}


-(void) getForumDiscussionsComplete:(NSNotification *)notification {
		//NSLog(@"GetForumDiscussions received in AddTopic Instance");
		@autoreleasepool {
            NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
		[myNotificationCenter removeObserver:self name:@"GetForumDiscussions" object:nil];
		self.errorReceived = [[notification object] errorReceived];
		}[self methodComplete];
		
}	

-(void) methodComplete {
	[GlobalMethods postNotification:@"AddTopicDelegate" withObject:self.errorReceived];
	[GlobalMethods postNotification:@"AddTopic" withObject:self.errorReceived];

}

- (NSString *) base64StringFromData: (NSData *)data length: (int)length {
	unsigned long ixtext, lentext;
	long ctremaining;
	unsigned char input[3], output[4];
	short i, charsonline = 0, ctcopy;
	const unsigned char *raw;
	NSMutableString *result;
	
	lentext = [data length]; 
	if (lentext < 1)
		return @"";
	result = [NSMutableString stringWithCapacity: lentext];
	raw = [data bytes];
	ixtext = 0; 
	
	while (true) {
		ctremaining = lentext - ixtext;
		if (ctremaining <= 0) 
			break;        
		for (i = 0; i < 3; i++) { 
			unsigned long ix = ixtext + i;
			if (ix < lentext)
				input[i] = raw[ix];
			else
				input[i] = 0;
		}
		output[0] = (input[0] & 0xFC) >> 2;
		output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
		output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
		output[3] = input[2] & 0x3F;
		ctcopy = 4;
		switch (ctremaining) {
			case 1: 
				ctcopy = 2; 
				break;
			case 2: 
				ctcopy = 3; 
				break;
		}
		
		for (i = 0; i < ctcopy; i++)
			[result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
		
		for (i = ctcopy; i < 4; i++)
			[result appendString: @"="];
		
		ixtext += 3;
		charsonline += 4;
		
		if ((length > 0) && (charsonline >= length))
			charsonline = 0;
		
		
	}
	return result;
}

@end
