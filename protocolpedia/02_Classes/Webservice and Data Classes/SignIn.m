//
//  SignIn.m
//  ProtocolPedia
//
//  Created by bk_sport on 11/13/13.
//  Copyright (c) 2013 chinhlt. All rights reserved.
//

#import "SignIn.h"
#define webservice_url      @"http://protocolpedia.com/protocolservice/SignUp_Login/index.php"

@implementation SignIn
{
    BOOL isID;
    BOOL isError;
    int userID;
    NSString *errorMsg;
}

@synthesize delegate;

- (void) startThreadLogin:(NSString *)strUser :(NSString *)strPass
{
    self.username = strUser;
    self.password = strPass;
    
    [NSThread detachNewThreadSelector:@selector(startLoadLogin) toTarget:self withObject:nil];
}
- (void)startLoadLogin{
    @autoreleasepool {
        [self performSelectorOnMainThread:@selector(goLogin) withObject:nil waitUntilDone:NO];
    }
}
- (void)goLogin{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n"
                            "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://localhost/leo/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"
                            "<SOAP-ENV:Body>\n"
                            "<mns:LoginUser xmlns:mns=\"\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"
                            "<LogInRequest xsi:type=\"tns:LogInRequest\">\n"
                            "<username xsi:type=\"xsd:string\">%@</username>\n"
                            "<password xsi:type=\"xsd:string\">%@</password>\n"
                            "</LogInRequest>\n"
                            "</mns:LoginUser>\n"
                            "</SOAP-ENV:Body>\n"
                            "</SOAP-ENV:Envelope>\n",self.username,self.password];
    
    NSURL *url = [NSURL URLWithString:webservice_url];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: [NSString stringWithFormat:@"%@//LoginUser",webservice_url] forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( theConnection )
    {
        self.webData = [NSMutableData data] ;
    }
    
}

#pragma mark - Web service Handler

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.webData setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.webData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SignInFailed)])
    {
        [self.delegate SignInFailed];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response = [[NSString alloc] initWithData:self.webData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", response);
    
    self.xmlParser =[[NSXMLParser alloc] initWithData:self.webData];
    
    [self.xmlParser setDelegate: self];
    [self.xmlParser setShouldResolveExternalEntities: YES];
    [self.xmlParser parse];  
}



#pragma mark - XML Parser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
    attributes: (NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"errorID"])
    {
        isError = YES;
        [self failedLoadingWS];
    }
    if ([elementName isEqualToString:@"id"]) {
        isID = YES;
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isID) {
        userID = [string integerValue];
        isID = NO;
        [self finishloadingWS];
    }
    if (isError) {
        errorMsg = string;
        isError = NO;
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}


- (void)finishloadingWS
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(SignInSuccess:)])
    {
        [self.delegate  SignInSuccess:userID];
    }
}

- (void)failedLoadingWS
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(SignInFailed)])
    {
        [self.delegate SignInFailed];
    }
}

@end
