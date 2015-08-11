//
//  GetContributors.m
//  ProtocolPedia
//
//   7/23/10.


#import "GetContributors.h"


@implementation GetContributors

-(void) loadProperties {
	self.numberOfFields = 2;
	self.methodName = @"GetContributors";
	self.postingName = @"GetContributors";
	self.tableName = @"Contributors";
//	self.lastElement = @"Link";

}

	

-(NSString*) getSQL {
	
	NSString *sqlStatementTemp = [[NSString alloc] initWithFormat:@"INSERT INTO Contributors (%@,%@) VALUES (\"%@\",\"%@\")",
								   @"Title",
								   @"Link",
								   [self.object objectForKey:@"Title"],
								   [self.object objectForKey:@"Link"]
								   ];
	return sqlStatementTemp;
}

@end
