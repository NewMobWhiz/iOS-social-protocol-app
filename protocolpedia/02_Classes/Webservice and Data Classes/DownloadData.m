//
//  DownloadData.m
//  ProtocolPedia
//
//   7/13/10.


#import "DownloadData.h"
#import "PPAppDelegate.h"
#import "SOAPRequest.h"

@implementation DownloadData

@synthesize downloadLabel;
@synthesize lastDownload;
@synthesize startDownload;
@synthesize getProtocols;
@synthesize getFavorites;
@synthesize getCategories;
@synthesize getCategoryRelations;
@synthesize getProtocolReviews;
@synthesize getForumDiscussions;
@synthesize getVideos;
@synthesize getContributors;

@synthesize methodStartTime;
@synthesize totalTime;

@synthesize activityIndicator;
@synthesize downloadImageView;

-(void) downloadData {
    
	PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    appDelegate.currentlyDownloading = YES;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    self.methodStartTime = [NSDate date];
    self.totalTime = [NSDate date];
    
    [self getProtocolsMethod];
	//	[self getCategoriesMethod];
	//	[self getVideosMethod];
	//	[self getFavoritesMethod];
    
    
    
}

-(void) getProtocolsMethod {
	
    @autoreleasepool {
        
        NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
        [myNotificationCenter addObserver:self selector:@selector(getProtocolsComplete:) name:@"GetProtocols" object:nil];
        
        GetProtocols *tempGetProtocols = [[GetProtocols alloc] init];
        self.getProtocols = tempGetProtocols;
        [self.getProtocols getMethodNow];
	}
	
}


-(void) getProtocolsComplete:(NSNotification *)notification {
    
	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter removeObserver:self name:@"GetProtocols" object:nil];
	
	if (![[notification object] errorReceived]) {
        
		@autoreleasepool {
            
            [self getFavoritesMethod];
		}
        
	} else {
		[self dataDownloadComplete:[[notification object] errorReceived]];
	}
}

-(void) getFavoritesMethod {
	@autoreleasepool {
        
        NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
        [myNotificationCenter addObserver:self selector:@selector(getFavoritesComplete:) name:@"GetFavorites" object:nil];
        
        GetFavorites *tempGetFavorites = [[GetFavorites alloc] init];
        tempGetFavorites.postingName = @"GetFavorites";
        self.getFavorites = tempGetFavorites;
        [self.getFavorites getMethodNow];
	}
	
}


-(void) getFavoritesComplete:(NSNotification *)notification {
	
	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter removeObserver:self name:@"GetFavorites" object:nil];
	
	if (![[notification object] errorReceived]) {
		
		@autoreleasepool {
            
            self.methodStartTime = [NSDate date];
            
            [self getCategoriesMethod];
            
		}
	} else {
		[self dataDownloadComplete:[[notification object] errorReceived]];
	}
}


-(void) getCategoriesMethod {
	@autoreleasepool {
        NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
        [myNotificationCenter addObserver:self selector:@selector(getCategoriesComplete:) name:@"GetCategories" object:nil];
        
        GetCategories *tempGetCategories = [[GetCategories alloc] init];
        self.getCategories = tempGetCategories;
        [self.getCategories getMethodNow];
        
	}
	
}


-(void) getCategoriesComplete:(NSNotification *)notification {
	
	if (![[notification object] errorReceived]) {
        
		@autoreleasepool {
            NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
            [myNotificationCenter removeObserver:self name:@"GetCategories" object:nil];
            
            //		NSLog(@"Categories download time:  %@",[GlobalMethods getTimeElapsedFor:self.methodStartTime]);
            self.methodStartTime = [NSDate date];
            
            [self getCategoryRelationsMethod];
            
		}
	} else {
		[self dataDownloadComplete:[[notification object] errorReceived]];
	}
}

///  GetCategoryRelations /////////////////

-(void) getCategoryRelationsMethod {
    
	@autoreleasepool {
        NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
        [myNotificationCenter addObserver:self selector:@selector(getCategoryRelationsComplete:) name:@"GetCategoryRelations" object:nil];
        
        GetCategoryRelations *tempGetCategoryRelations = [[GetCategoryRelations alloc] init];
        self.getCategoryRelations = tempGetCategoryRelations;
        [self.getCategoryRelations getMethodNow];
        
	}
}



-(void) getCategoryRelationsComplete:(NSNotification *)notification {
    
	if (![[notification object] errorReceived]) {
		
		@autoreleasepool {
            NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
            [myNotificationCenter removeObserver:self name:@"GetCategoryRelations" object:nil];
            
            //		NSLog(@"CategoryRelations download time:  %@",[GlobalMethods getTimeElapsedFor:self.methodStartTime]);
            self.methodStartTime = [NSDate date];
            
            [self getProtocolReviewsMethod];
            
		}
	} else {
		[self dataDownloadComplete:[[notification object] errorReceived]];
	}
    
}



-(void) getProtocolReviewsMethod {
	@autoreleasepool {
        NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
        [myNotificationCenter addObserver:self selector:@selector(getProtocolReviewsComplete:) name:@"GetProtocolReviews" object:nil];
        
        GetProtocolReviews *tempGetProtocolReviews = [[GetProtocolReviews alloc] init];
        self.getProtocolReviews = tempGetProtocolReviews;
        [self.getProtocolReviews getMethodNow];
        
	}
	
}


-(void) getProtocolReviewsComplete:(NSNotification *)notification {
    
	if (![[notification object] errorReceived]) {
        
		@autoreleasepool {
            NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
            [myNotificationCenter removeObserver:self name:@"GetProtocolReviews" object:nil];
            
            //  check for errors first
            
            //		NSLog(@"ProtocolReviews download time:  %@",[GlobalMethods getTimeElapsedFor:self.methodStartTime]);
            self.methodStartTime = [NSDate date];
            
            [self getForumDiscussionsMethod];
            
		}
	} else {
		[self dataDownloadComplete:[[notification object] errorReceived]];
	}
}



-(void) getForumDiscussionsMethod {
	@autoreleasepool {
        NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
        [myNotificationCenter addObserver:self selector:@selector(getForumDiscussionsComplete:) name:@"GetForumDiscussions" object:nil];
        
        GetForumDiscussions *tempGetForumDiscussions = [[GetForumDiscussions alloc] init];
        self.getForumDiscussions = tempGetForumDiscussions;
        [self.getForumDiscussions getMethodNow];
        
	}
	
}


-(void) getForumDiscussionsComplete:(NSNotification *)notification {
    
	if (![[notification object] errorReceived]) {
		@autoreleasepool {
            NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
            [myNotificationCenter removeObserver:self name:@"GetForumDiscussions" object:nil];
            
            //  check for errors first
            
            //		NSLog(@"GetForumDiscussions download time:  %@",[GlobalMethods getTimeElapsedFor:self.methodStartTime]);
            self.methodStartTime = [NSDate date];
            
            [self getVideosMethod];
            
		}
	} else {
		[self dataDownloadComplete:[[notification object] errorReceived]];
	}
}




-(void) getVideosMethod {
	@autoreleasepool {
        NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
        [myNotificationCenter addObserver:self selector:@selector(getVideosComplete:) name:@"GetVideos" object:nil];
        
        GetVideos *tempGetVideos = [[GetVideos alloc] init];
        self.getVideos = tempGetVideos;
        [self.getVideos getMethodNow];
        
	}
	
}


-(void) getVideosComplete:(NSNotification *)notification {
    
	if (![[notification object] errorReceived]) {
		@autoreleasepool {
            NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
            [myNotificationCenter removeObserver:self name:@"GetVideos" object:nil];
            
            //  check for errors first
            
            //		NSLog(@"GetVideos download time:  %@",[GlobalMethods getTimeElapsedFor:self.methodStartTime]);
            self.methodStartTime = [NSDate date];
            
            [self dataDownloadComplete:@"Yes"];
            //[self getContributorsMethod];
            
		}
	} else {
		[self dataDownloadComplete:[[notification object] errorReceived]];
	}
}


-(void) getContributorsMethod {
    //	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //
    //	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
    //	[myNotificationCenter addObserver:self selector:@selector(getContributorsComplete:) name:@"GetContributors" object:nil];
    //
    //	self.getContributors = [[GetContributors alloc] init];
    //	[self.getContributors getMethodNow];
    //
    //	[pool release];
	
}


-(void) getContributorsComplete:(NSNotification *)notification {
    //	if (![[notification object] errorReceived]) {
    //		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //
    //		NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
    //		[myNotificationCenter removeObserver:self name:@"GetContributors" object:nil];
    //
    //		// check for errors
    //
    ////		NSLog(@"GetContributors download time:  %@",[GlobalMethods getTimeElapsedFor:self.methodStartTime]);
    //		self.methodStartTime = [NSDate date];
    //
    //		[self.getContributors release];
    //		[self dataDownloadComplete:@"Yes"];
    //
    //		[pool release];
    //	} else {
    //		[self dataDownloadComplete:[[notification object] errorReceived]];
    //	}
}


-(void) dataDownloadComplete:(NSString*)success {
	
    //	NSLog(@"Total download time:  %@",[GlobalMethods getTimeElapsedFor:self.totalTime]);
	PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
	
	if ([success isEqualToString:@"Yes"]) {
		//[GlobalMethods postNotification:@"downloadStatusMessage" withObject:[NSString stringWithFormat:@"Download Complete - %@ mins",[GlobalMethods getTimeElapsedFor:self.totalTime]]];
		[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(deleteNavBarMessage) userInfo:nil repeats:NO];
		[appDelegate.settings setObject:[GlobalMethods zstringFromDate:[NSDate date]] forKey:@"LastDownload"];
        //		NSLog(@"[appDelegate.settings objectForKey@\"LastDownload\"] %@",[appDelegate.settings objectForKey:@"LastDownload"]);
	} else {
		[GlobalMethods postNotification:@"downloadStatusMessage" withObject:@"complete"];
	}
	appDelegate.currentlyDownloading = NO;
	[GlobalMethods postNotification:@"dataDownloadComplete" withObject:success];
	[UIApplication sharedApplication].idleTimerDisabled = NO;
    
}


-(void) deleteNavBarMessage {
	[GlobalMethods postNotification:@"downloadStatusMessage" withObject:@"complete"];;
}





@end
