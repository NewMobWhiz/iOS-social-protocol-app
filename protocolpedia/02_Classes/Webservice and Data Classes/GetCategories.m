//
//  GetCategories.m
//  ProtocolPedia
//
//   7/21/10.


#import "GetCategories.h"


@implementation GetCategories

-(void) loadProperties {
	self.numberOfFields = 9;
	self.methodName = @"GetCategories";
	self.postingName = @"GetCategories";
	self.tableName = @"Categories";
//	self.lastElement = @"TimeLastMessage";

}



-(NSString*) getSQL {

			NSString *sqlStatementTemp = [[NSString alloc] initWithFormat:@"INSERT INTO Categories (%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
										   @"CategoryType",
										   @"CategoryId",
										   @"ParentId",
										   @"Name",
										   @"Description",
										   @"LastMessageId",
										   @"NumberOfItems",
										   @"NumberOfPosts",
										   @"TimeLastMessage",
										   [self.object objectForKey:@"CategoryType"],  
										   [self.object objectForKey:@"CategoryId"],
										   [self.object objectForKey:@"ParentId"],
										   [self.object objectForKey:@"Name"],
										   [self.object objectForKey:@"Description"],
										   [self.object objectForKey:@"LastMessageId"],
										   [self.object objectForKey:@"NumberOfItems"],
										   [self.object objectForKey:@"NumberOfPosts"],
										   [self.object objectForKey:@"TimeLastMessage"]
										   ];
			return sqlStatementTemp;
}


@end
