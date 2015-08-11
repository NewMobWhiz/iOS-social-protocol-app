//
//  SOAPRequest.m
//  ProtocolPedia
//
//   7/14/10.


#import "SOAPRequest.h"


@implementation SOAPRequest



+(NSMutableURLRequest*) getSOAPRequestForSOAPMethod:(NSString*)soapMethod withSessionId:(NSString*)thisSessionId withTimeoutInterval:(int)timeout {

	NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'>\n"
								"<SOAP-ENV:Body>\n"
									"<SOAP-ENV:%@>\n"
									"%@"
									"</SOAP-ENV:%@>\n"
								"</SOAP-ENV:Body>\n"
							 "</SOAP-ENV:Envelope>\n",
							 soapMethod,
							 thisSessionId,
							 soapMethod  
							 ];
    
    NSLog(@"soapMessage = %@", soapMessage);


	NSString *url = @"http://www.protocolpedia.com/protocolservice/protocolservice.php";
	NSURL *thisURL = [NSURL URLWithString:url];
	NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:thisURL  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:(double)timeout];
	
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	[theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue:[NSString stringWithFormat:@"http://www.protocolpedia.com/protocolservice/protocolservice:protocolpedia#%@",soapMethod] forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
//	NSMutableData *tempData = (NSMutableData*)[theRequest HTTPBody];
//	NSData *nullData = [@"\0" dataUsingEncoding:NSASCIIStringEncoding];
//	[tempData appendData:nullData];
//	char bytes [[tempData length]];
//	[tempData getBytes:&bytes length:[tempData length]];

	return theRequest;
	


	
}



@end



