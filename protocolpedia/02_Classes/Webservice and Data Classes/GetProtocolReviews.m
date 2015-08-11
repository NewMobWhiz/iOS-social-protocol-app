//
//  GetProtocolReviews.m
//  ProtocolPedia
//
//   7/22/10.


#import "GetProtocolReviews.h"

@implementation GetProtocolReviews

-(void) loadProperties {
	self.numberOfFields = 7;
	self.methodName = @"GetProtocolReviews";
	self.postingName = @"GetProtocolReviews";
	self.tableName = @"ProtocolReviews";
//	self.lastElement = @"SubmittedDate";

}

	
-(NSString*) getSQL {

		NSString *sqlStatementTemp = [[NSString alloc] initWithFormat:@"INSERT INTO ProtocolReviews (%@,%@,%@,%@,%@,%@,%@) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
										   @"ReviewId",
										   @"ProtocolId",
										   @"Title",
										   @"Review",
										   @"Stars",
										   @"SubmittedBy",
										   @"SubmittedDate",
										   [self.object objectForKey:@"ReviewId"],  
										   [self.object objectForKey:@"ProtocolId"],
										   [self.object objectForKey:@"Title"],
										   [self.object objectForKey:@"Review"],
										   [self.object objectForKey:@"Stars"],
										   [self.object objectForKey:@"SubmittedBy"],
										   [self.object objectForKey:@"SubmittedDate"]
										   ] ;
			return sqlStatementTemp;
}


@end
