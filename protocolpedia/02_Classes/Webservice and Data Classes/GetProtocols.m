//
//  GetProtocols.m
//  ProtocolPedia
//
//   7/14/10.


#import "GetProtocols.h"
#import "Crypto.h"

@implementation GetProtocols

-(void) loadProperties {
	self.numberOfFields = 6;
	self.methodName = @"GetProtocols";
	self.postingName = @"GetProtocols";
	self.tableName = @"Protocols";
//	self.lastElement = @"Stars";
}




-(NSString*) getSQL {
		NSString *sqlStatementTemp = [[NSString alloc] initWithFormat:@"INSERT INTO Protocols (%@,%@,%@,%@,%@,%@) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",
								@"ProtocolId",
								@"Title",
								@"Text",
								@"Credit",
								@"Stars",
								@"NumberOfReviews",
								[self.object objectForKey:@"ProtocolId"],  
								[self.object objectForKey:@"Title"],
								[self.object objectForKey:@"Text"],
								[self.object objectForKey:@"Credit"],
								[self.object objectForKey:@"Stars"],
								[self.object objectForKey:@"NumberOfReviews"]
								];
	//NSLog(@"sql %@",sqlStatementTemp);

		return sqlStatementTemp;
}



@end
