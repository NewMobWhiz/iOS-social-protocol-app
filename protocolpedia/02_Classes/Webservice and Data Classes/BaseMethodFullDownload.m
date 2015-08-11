//
//  BaseMethodFullDownload.m
//  ProtocolPedia
//
//   8/18/10.


#import "BaseMethodFullDownload.h"
#import "SQLiteAccess.h"
#import "Crypto.h"
#import "SOAPRequest.h"

@implementation BaseMethodFullDownload

@synthesize xmlParser;
@synthesize contentOfCurrentProperty;
@synthesize object;
@synthesize faultCode;
@synthesize faultString;
@synthesize key;
@synthesize value;
@synthesize sqlStatement;
@synthesize methodName;
@synthesize tableName;
@synthesize sessionId;
@synthesize receivedRawData;
@synthesize errorReceived;
@synthesize thisRequest;
@synthesize postingName;

@synthesize numberOfFields;
@synthesize counter;
@synthesize firstCheck;
@synthesize retries;

#pragma mark  lifecycle methods

-(void) loadProperties {
	
}

-(void) getMethodNow {
	self.sessionId = @"";
	self.retries = 0;
	self.object = (NSMutableDictionary*)[NSMutableDictionary dictionary];
	self.counter = 0;
	self.firstCheck = 1;
	self.errorReceived = nil;
	[self loadProperties];
	self.thisRequest = [SOAPRequest getSOAPRequestForSOAPMethod:self.methodName withSessionId:self.sessionId withTimeoutInterval:10];

	[self createConnection];
	
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
	[self.receivedRawData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.receivedRawData setLength:0];
	self.receivedRawData = [NSMutableData data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	if (self.retries > 3) {
		self.errorReceived = [NSString stringWithFormat:@"error received %@",error];
		[self methodComplete];
	} else {
		self.retries++;
		[GlobalMethods postNotification:@"downloadStatusMessage" withObject:[NSString stringWithFormat:@"Retry %i to login",self.retries]];
		[self createConnection];
	}
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection  {  

//	NSLog(@"receivedRawData %i Bytes",[self.receivedRawData length]);
	
	NSString *receivedStringTemp = [[NSString alloc] initWithData:self.receivedRawData encoding:NSASCIIStringEncoding];
	//NSLog(@"receivedStringTemp %@",receivedStringTemp);
	
	NSXMLParser *tempXmlParser = [[NSXMLParser alloc] initWithData:self.receivedRawData];
	self.xmlParser = tempXmlParser;
	[self.xmlParser setDelegate:self];
	[self.xmlParser setShouldResolveExternalEntities: NO];
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
	
	if ([elementName isEqualToString:@"key"] ||
		[elementName isEqualToString:@"value"] ||
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
	}else if ([elementName isEqualToString:@"key"]) {
        self.key = self.contentOfCurrentProperty;
    } else if ([elementName isEqualToString:@"value"]) {
		// take the null out of self.contentOfCurrentProperty
		if (!self.contentOfCurrentProperty) { 
			self.contentOfCurrentProperty = (NSMutableString*)@"";
		}
		
		
//		NSString* sI = (NSString*)CFXMLCreateStringByUnescapingEntities(NULL, self.contentOfCurrentProperty, NULL);
		
		
		
//		NSLog(@"self.contentOfCurrentProperty %@",self.contentOfCurrentProperty);
//		NSLog(@"beforeReplace %@\n",self.contentOfCurrentProperty);
		NSMutableString * temp = self.contentOfCurrentProperty;
//		NSLog(@"beforeAmp %@\n",temp);


		[temp replaceOccurrencesOfString:@"&amp;" withString:@"&"options:0 range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@"&amp;" withString:@"&"options:0 range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@"&amp;" withString:@"&"options:0 range:NSMakeRange(0, [temp length])];
//		NSLog(@"afterAmp %@\n",temp);
		[temp replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@"&quot;" withString:@"'" options:0 range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@"&apos;" withString:@"'" options:0 range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@"&#039;" withString:@"'" options:0 range:NSMakeRange(0, [temp length])];
		[temp replaceOccurrencesOfString:@"\"" withString:@"'" options:0 range:NSMakeRange(0,[temp length])];
		[temp replaceOccurrencesOfString:@"&nbsp;" withString:@" " options:0 range:NSMakeRange(0,[temp length])];
		[temp replaceOccurrencesOfString:@"nbsp;" withString:@" " options:0 range:NSMakeRange(0,[temp length])];
//		[temp replaceOccurrencesOfString:@"&deg;" withString:@" " options:0 range:NSMakeRange(0,[temp length])];
		[temp replaceOccurrencesOfString:@"&#13;" withString:@"<br />" options:0 range:NSMakeRange(0,[temp length])];
		
		
		if ([self.postingName isEqualToString:@"GetForumDiscussions"]) {
			[temp replaceOccurrencesOfString:@"[" withString:@"<" options:0 range:NSMakeRange(0,[temp length])];
			[temp replaceOccurrencesOfString:@"]" withString:@">" options:0 range:NSMakeRange(0,[temp length])];
			[temp replaceOccurrencesOfString:@"\n" withString:@"<br />" options:0 range:NSMakeRange(0,[temp length])];
			[temp replaceOccurrencesOfString:@"\\'" withString:@"'" options:0 range:NSMakeRange(0,[temp length])];
		}
		
		self.value = temp;
//		NSLog(@"afterReplace %@\n",temp);
//		NSLog(@"self.value %@",self.value);

		[self.object setObject:self.value forKey:self.key];
		
		//increment field counter
		self.counter++;
		
	}
	
	if(!self.faultCode && !self.faultString) {
		if (self.counter == self.numberOfFields) {
			
			// check to see that download is working, if so, delete current table
			if (firstCheck == 1) {
				[self deleteCurrentDatabase];
				self.firstCheck = 0;
			}
			if ([self.methodName isEqualToString:@"GetProtocols"]) {
					[GlobalMethods postNotification:@"downloadStatusMessage" withObject:@"Downloading Protocols"];
					
			} else if ([self.methodName isEqualToString:@"GetFavorites"]){
					[GlobalMethods postNotification:@"downloadStatusMessage" withObject:@"Downloading Favorites"];
					
			} else if ([self.methodName isEqualToString:@"GetCategories"]){
				[GlobalMethods postNotification:@"downloadStatusMessage" withObject:@"Downloading Categories"];
				
			} else if ([self.methodName isEqualToString:@"GetCategoryRelations"]){
				[GlobalMethods postNotification:@"downloadStatusMessage" withObject:@"Downloading Categories"];;
				
			} else if ([self.methodName isEqualToString:@"GetProtocolReviews"]){
				[GlobalMethods postNotification:@"downloadStatusMessage" withObject:@"Downloading Reviews"];
				
			} else if ([self.methodName isEqualToString:@"GetForumDiscussions"]){
				[GlobalMethods postNotification:@"downloadStatusMessage" withObject:@"Downloading Forums "];
				
			} else if ([self.methodName isEqualToString:@"GetVideos"]) {
					[GlobalMethods postNotification:@"downloadStatusMessage" withObject:@"Downloading Video Links"];
					
			} else if ([self.methodName isEqualToString:@"GetContributors"]) {
				[GlobalMethods postNotification:@"downloadStatusMessage" withObject:@"Downloading Contributors"];
			}

			self.sqlStatement = [self getSQL];
			[self enterIntoDatabase];
			self.object = (NSMutableDictionary*)[NSMutableDictionary dictionary];
			self.counter = 0;
		}
	} 
	
}


-(NSString*) getSQL {
	return nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser  {
	if(self.faultCode || self.faultString) {
		self.errorReceived = [NSString stringWithFormat:@"Received error from server. Unable to download data. faultcode = %@",self.faultCode];
	}
	[self methodComplete];
}


-(void) deleteCurrentDatabase {
	[SQLiteAccess deleteWithSQL:[NSString stringWithFormat:@"DELETE FROM %@",self.tableName]];
}


-(void) enterIntoDatabase {
	
	int returnValue = [[SQLiteAccess insertWithSQL:self.sqlStatement] intValue];
	if (returnValue == 0) {
		NSLog(@"%@ Return Value was %i",self.methodName,returnValue);
	}
}


-(void) methodComplete {
	[GlobalMethods postNotification:self.postingName withObject:self];
	//NSLog(@"%@ posted in BaseMethod",self.postingName);

}



@end
