//
//  Login.m
//  ProtocolPedia
//
//   7/16/10.


#import "Login.h"
#import "Crypto.h"
#import "SQLiteAccess.h"
#import "PPAppDelegate.h"


@implementation Login


@synthesize username;
@synthesize password;
@synthesize coveredPassword;
@synthesize xmlParser;
@synthesize contentOfCurrentProperty;
@synthesize faultCode;
@synthesize faultString;
@synthesize sessionId;
@synthesize receivedRawData;
@synthesize receivedString;
@synthesize errorReceived;
@synthesize thisRequest;

@synthesize retries;


-(void) getAuthenticationWithUsername:(NSString*)thisUsername  andPassword:(NSString*)thisPassword {

	self.retries = 0;
	self.password = thisPassword;
	self.username = thisUsername;
	self.errorReceived = nil;
	
	self.coveredPassword = [Crypto encryptPassword:self.password withKey:@"1234567890"];

//	NSLog(@"self.username  %@",self.username);
//	NSLog(@"self.password  %@",self.password);
//	NSLog(@"self.coveredPassword  %@",self.coveredPassword);

	@autoreleasepool {
        self.thisRequest = [self getSOAPRequest];
        [self createConnection];

	}
}


#pragma mark Connection methods


-(void) createConnection   {
	
	// check if can make connection with server
	if ([self canConnect]) {
		// Create the Connection
		NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:self.thisRequest delegate:self startImmediately:YES];
		if (!conn) {
			self.errorReceived = @"Can't make connection to server";
			[self loginComplete];
		}
		
	} else {
		[self loginComplete];
	}
}

// canConnect - Test to check for a network connection
-(BOOL) canConnect;	{
	NSData			*dataReply;
	NSURLResponse	*response;
	NSError			*error;
	BOOL			flag;
	
	// create the request
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.protocolpedia.com/protocolservice/protocolservice.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:7.0];
	
	// Make the connection
	dataReply = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
	
	if (response != nil) 
	{
		flag = YES;
	} else {
		self.errorReceived = [NSString stringWithFormat:@"Can't make connection to server - %@", [error localizedDescription]];
		NSLog(@"%@", [error description]);
		flag = NO;
    }
	
	return flag;
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	self.errorReceived = @"Received Authentication Challenge, Please logout and try again.";
	[self loginComplete];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.receivedRawData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.receivedRawData setLength:0];
	self.receivedRawData = [NSMutableData data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	if (self.retries > 3) {
		self.errorReceived = [NSString stringWithFormat:@"error received %@",error];
		[self loginComplete];
	} else {
		self.retries++;
		//[GlobalMethods postNotification:@"downloadStatusMessage" withObject:[NSString stringWithFormat:@"Retry %i to login",self.retries]];
		//[GlobalMethods navbarStatusMessage:[NSString stringWithFormat:@"Retry %i to login",self.retries]];
		[self createConnection];
	}
	
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection  {  
	
	// convert to string for testing only /////////////////
	
	NSString *receivedStringTemp = [[NSString alloc] initWithData:self.receivedRawData encoding:NSASCIIStringEncoding];
	self.receivedString = receivedStringTemp;
	//		if ([self.thisRequestingObject isEqualToString:@"Categories"]) {
//	NSLog(@"receivedString did finish  %@",self.receivedString);	
	//		}
	
	///////////// previous for testing only
//	NSLog(@"self.errorReceived %@",self.errorReceived);

	if (!self.errorReceived) {
		[self parseAuthentication];
	} else {
		[self loginComplete];
	}
	
}



#pragma mark Parser methods

 -(void) parseAuthentication {

	 NSXMLParser *tempParser = [[NSXMLParser alloc] initWithData:self.receivedRawData];
	 self.xmlParser = tempParser;
	 [self.xmlParser setDelegate:self];
	 [self.xmlParser setShouldResolveExternalEntities: YES];
	 [self.xmlParser parse];
	 
 }
		 

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
		[self loginComplete];
	}
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {	
    if (qName) {
        elementName = qName;
    }
	
	if ([elementName isEqualToString:@"SessionId"] ||
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
	}else if ([elementName isEqualToString:@"SessionId"]) {
        self.sessionId = self.contentOfCurrentProperty;
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser  {
	
	PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
	
	if(!self.faultCode && !self.faultString) {
		appDelegate.sessionId = self.sessionId;
		appDelegate.loggedIn = YES;
		appDelegate.loginTime = [NSDate date];
//		NSLog(@"SessionId  %@",self.sessionId);
	} else {
		NSLog(@"Authentication faultcode: %@,  faultString: %@",self.faultCode,self.faultString);
		self.errorReceived = [NSString stringWithFormat:@"Received Authentication faultcode: %@",self.faultCode];
		appDelegate.loggedIn = NO;
	}
	[self loginComplete];
}


-(void) loginComplete {
	[GlobalMethods postNotification:@"loginComplete" withObject:self];
}


-(NSMutableURLRequest*) getSOAPRequest {
	
	NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
							 "<SOAP-ENV:Envelope xmlns:SOAP-ENV="
							 "\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"urn:protocolpedia\" xmlns:xsd="
							 "\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC="
							 "\"http://schemas.xmlsoap.org/soap/encoding/\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"
								"<SOAP-ENV:Body>\n"
								"<ns1:Login>\n"
									"<Username xsi:type=\"xsd:string\">\n"
										"%@\n"
									"</Username>\n"
									"<CoveredPassword xsi:type=\"xsd:string\">\n"
										"%@\n"
									"</CoveredPassword>\n"									
								"</ns1:Login>\n"
								"</SOAP-ENV:Body>\n"
							 "</SOAP-ENV:Envelope>\n",
							 self.username,
							 self.coveredPassword  
							 ];
	
//	NSLog(@"soapMessage %@ \n",soapMessage);

	
	NSString *url = @"http://www.protocolpedia.com/protocolservice/protocolservice.php";
	NSURL *thisURL = [NSURL URLWithString:url];
	NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:thisURL  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:(double)10];
	
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	[theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue:[NSString stringWithFormat:@"http://www.protocolpedia.com/protocolservice/protocolservice:protocolpedia#Login"] forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSMutableData *tempData = (NSMutableData*)[theRequest HTTPBody];
	NSData *nullData = [@"\0" dataUsingEncoding:NSASCIIStringEncoding];
	[tempData appendData:nullData];
	char bytes [[tempData length]];
	[tempData getBytes:&bytes length:[tempData length]];
	
//		NSLog(@"soapMessage %@",soapMessage);
	
	return theRequest;
	
}







@end
