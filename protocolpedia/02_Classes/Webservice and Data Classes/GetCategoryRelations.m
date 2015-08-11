//
//  GetCategoryRelations.m
//  ProtocolPedia
//
//   7/30/10.


#import "GetCategoryRelations.h"


@implementation GetCategoryRelations


-(void) loadProperties {
	self.numberOfFields = 3;
	self.methodName = @"GetCategoryRelations";
	self.postingName = @"GetCategoryRelations";
	self.tableName = @"CategoryRelations";
//	self.lastElement = @"CategoryOrdering";
	
}


-(NSString*) getSQL {
	
	NSString *sqlStatementTemp = [[NSString alloc] initWithFormat:@"INSERT INTO CategoryRelations (%@,%@,%@) VALUES (\"%@\",\"%@\",\"%@\");",
								   @"CategoryId",
								   @"ProtocolId",
								   @"CategoryOrdering",
								   [self.object objectForKey:@"CategoryId"],  
								   [self.object objectForKey:@"ProtocolId"],
								   [self.object objectForKey:@"CategoryOrdering"]
								   ] ;
	
	return sqlStatementTemp;
}



@end
