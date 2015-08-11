//
//  GetForumDiscussions.m
//  ProtocolPedia
//
//   7/23/10.


#import "GetForumDiscussions.h"


@implementation GetForumDiscussions

-(void) loadProperties {
	self.numberOfFields = 10;
	self.methodName = @"GetForumDiscussions";
	self.postingName = @"GetForumDiscussions";
	self.tableName = @"Discussions";
//	self.lastElement = @"NumberOfHits";

}



-(NSString*) getSQL {
	
	NSString *sqlStatementTemp = [[NSString alloc] initWithFormat:@"INSERT INTO Discussions (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
								   @"DiscussionId",
								   @"CategoryId",
								   @"ParentId",
								   @"ThreadId",
								   @"Subject",
								   @"MessageText",
								   @"SubmittedBy",
								   @"SubmittedDate",
								   @"NumberOfReplies",
								   @"NumberOfHits",
								   [self.object objectForKey:@"DiscussionId"],  
								   [self.object objectForKey:@"CategoryId"],
								   [self.object objectForKey:@"ParentId"],
								   [self.object objectForKey:@"ThreadId"],
								   [self.object objectForKey:@"Subject"],
								   [self.object objectForKey:@"MessageText"],
								   [self.object objectForKey:@"SubmittedBy"],
								   [self.object objectForKey:@"SubmittedDate"],
								   [self.object objectForKey:@"NumberOfReplies"],
								   [self.object objectForKey:@"NumberOfHits"]
								   ];
	return sqlStatementTemp;
}

@end
