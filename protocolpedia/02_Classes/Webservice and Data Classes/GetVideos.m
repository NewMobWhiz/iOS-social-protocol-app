//
//  GetVideos.m
//  ProtocolPedia
//
//   7/23/10.


#import "GetVideos.h"
#import "Crypto.h"


@implementation GetVideos


-(void) loadProperties {
	self.numberOfFields = 11;
	self.methodName = @"GetVideos";
	self.postingName = @"GetVideos";
	self.tableName = @"Videos";
//	self.lastElement = @"Stars";

}




-(NSString*) getSQL {
	
	NSString *sqlStatementTemp = [[NSString alloc] initWithFormat:@"INSERT INTO Videos (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\");",
								   @"VideoId",
								   @"VideoType",
								   @"Video_Id",
								   @"ImageLocation",
								   @"Title",
								   @"Description",
								   @"CategoryId",
								   @"SubmittedBy",
								   @"SubmittedDate",
								   @"NumberOfViews",
								   @"Stars",
								   [self.object objectForKey:@"VideoId"],  
								   [self.object objectForKey:@"VideoType"],
								   [self.object objectForKey:@"Video_Id"],
								   [self.object objectForKey:@"ImageLocation"],
								   [self.object objectForKey:@"Title"],
								   [self.object objectForKey:@"Description"],
								   [self.object objectForKey:@"CategoryId"],
								   [self.object objectForKey:@"SubmittedBy"],
								   [self.object objectForKey:@"SubmittedDate"],
								   [self.object objectForKey:@"NumberOfViews"],
								   [self.object objectForKey:@"Stars"]
								   ];
	
	return sqlStatementTemp;
}


@end
