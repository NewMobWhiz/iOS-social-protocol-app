//
//  GetFavorites.m
//  ProtocolPedia
//
//   8/11/10.


#import "GetFavorites.h"
#import "PPAppDelegate.h"


@implementation GetFavorites



-(void) loadProperties {
	self.numberOfFields = 1;
	self.methodName = @"GetFavorites";
	self.tableName = @"FavoriteProtocols";
//	self.lastElement = @"ProtocolId";
	PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
	self.sessionId = [NSString stringWithFormat:@"<SessionId xsi:type=\"xsd:string\">%@</SessionId>",appDelegate.sessionId];
}


-(NSString*) getSQL {
	NSString *sqlStatementTemp = [[NSString alloc] initWithFormat:@"INSERT INTO FavoriteProtocols (%@) VALUES (\"%@\")",
									@"ProtocolId",
									[self.object objectForKey:@"ProtocolId"]
									 ];
	return sqlStatementTemp;
}




@end
