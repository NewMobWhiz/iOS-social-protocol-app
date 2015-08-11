//
//  PPFavoriteProtocolsViewController.m
//  ProtocolPedia
//
//  26/02/14.


#import "PPFavoriteProtocolsViewController.h"

@interface PPFavoriteProtocolsViewController ()

@end

@implementation PPFavoriteProtocolsViewController

@synthesize thisFavorite, currentTag;

- (NSString *)sqlRequestString{
    return @"SELECT ProtocolId, Title, NumberOfReviews, Stars FROM Protocols WHERE ProtocolId IN (SELECT ProtocolId FROM FavoriteProtocols)";
}

-(void) changeFavorite:(UIButton*)sender {
	if (applicationDelegate.loggedIn == YES) {
		NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
		[myNotificationCenter addObserver:self selector:@selector(confirmChange:) name:@"FavoriteListView" object:nil];
		self.currentTag = sender.tag;
		self.thisFavorite = [[self.dataSource objectAtIndex:sender.tag] objectForKey:@"ProtocolId"];
		[applicationDelegate changeFavoriteProtocolId:self.thisFavorite withChange:@"Remove" forRequestingObject:@"FavoriteListView"];
	} else {
		[GlobalMethods displayMessage:@"You must be logged in to change favorites"];
	}
}


-(void)confirmChange:(NSNotification*)notification {
	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter removeObserver:self name:@"FavoriteListView" object:nil];
    //NSLog(@"[notification object]%@",[notification object]);
	//NSLog(@"self.menuItems before  %@",self.menuItems );
	if (![notification object]) {
		[self.dataSource removeObjectAtIndex:self.currentTag];
        //	NSLog(@"removeObject");
        
        
	}
	//NSLog(@"self.menuItems after %@",self.menuItems );
	[GlobalMethods postNotification:@"StopFavoriteIndicator" withObject:nil];
	[self.tableView reloadData];
}
//
//- (void)onLeftBarButton:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
