//
//  SOAPRequest.h
//  ProtocolPedia
//
//   7/14/10.


#import <Foundation/Foundation.h>


@interface SOAPRequest : NSObject {


}

+(NSMutableURLRequest*) getSOAPRequestForSOAPMethod:(NSString*)soapMethod withSessionId:(NSString*)thisSessionId withTimeoutInterval:(int)timeout;


@end
