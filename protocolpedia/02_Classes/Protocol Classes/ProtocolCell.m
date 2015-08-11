//
//  ProtocolCell.m
//  bilfo
//
//   6/5/10.



#import "ProtocolCell.h"



@implementation ProtocolCell

@synthesize makeFavorite;
@synthesize protocolName;
@synthesize reviewsLabel;
@synthesize reviews;
@synthesize favoriteImageView;
@synthesize starsImageView;
@synthesize firstLine;
@synthesize secondLine;
//@synthesize starsLabel;
//@synthesize stars;
@synthesize changeFavoriteProtocol;
@synthesize activityIndicator;
@synthesize protocolId;
@synthesize favorite;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		self.makeFavorite = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.makeFavorite setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
		self.makeFavorite.titleLabel.backgroundColor = [UIColor clearColor];
		self.makeFavorite.titleLabel.font = [UIFont boldSystemFontOfSize:14];
		[self.makeFavorite addTarget:self action:@selector(startIndicator:) forControlEvents:UIControlEventTouchUpInside];
	//	self.makeFavorite.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
	
		UILabel *tempFirstLine = [[UILabel alloc] initWithFrame:CGRectZero];
		self.firstLine = tempFirstLine;
		self.firstLine.textColor = [UIColor blueColor];
		self.firstLine.font = [UIFont boldSystemFontOfSize:14.0];
		self.firstLine.backgroundColor = [UIColor clearColor];
		self.firstLine.textAlignment = UITextAlignmentRight;
		self.firstLine.text = @"Make Favorite";	

		UIActivityIndicatorView *tempActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		self.activityIndicator = tempActivityIndicator;
		self.activityIndicator.hidden = YES;
		self.activityIndicator.hidesWhenStopped = YES;
		[self.activityIndicator stopAnimating];	
		
		
//		self.firstLine = [[UILabel alloc] initWithFrame:CGRectZero];
//		self.firstLine.textColor = [UIColor blueColor];
//		self.firstLine.font = [UIFont boldSystemFontOfSize:14.0];
//		self.firstLine.backgroundColor = [UIColor clearColor];
//		self.firstLine.textAlignment = UITextAlignmentCenter;
//		self.firstLine.text = @"Make";	
//			
//		self.secondLine = [[UILabel alloc] initWithFrame:CGRectZero];		
//		self.secondLine.textColor = [UIColor blueColor];
//		self.secondLine.font = [UIFont boldSystemFontOfSize:14.0];
//		self.secondLine.backgroundColor = [UIColor clearColor];
//		self.secondLine.textAlignment = UITextAlignmentCenter;
//		self.secondLine.text = @"Favorite";	
				
		UILabel *tempProtocolName = [[UILabel alloc] initWithFrame:CGRectZero];		
		self.protocolName = tempProtocolName;
		self.protocolName.textColor = [UIColor grayColor];
		self.protocolName.font = [UIFont boldSystemFontOfSize:14.0];
		self.protocolName.backgroundColor = [UIColor clearColor];
		self.protocolName.lineBreakMode = UILineBreakModeWordWrap;
		self.protocolName.adjustsFontSizeToFitWidth = YES;
		self.protocolName.minimumFontSize = 10;
		self.protocolName.numberOfLines = 2;
		

//		self.reviewsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//		self.reviewsLabel.textColor = [UIColor blackColor];
//		self.reviewsLabel.font = [UIFont boldSystemFontOfSize:14.0];
//		self.reviewsLabel.backgroundColor = [UIColor clearColor];
//		self.reviewsLabel.text = @"Reviews:";

//		self.reviews = [[UILabel alloc] initWithFrame:CGRectZero];
//		self.reviews.textColor = [UIColor grayColor];
//		self.reviews.font = [UIFont boldSystemFontOfSize:14.0];
//		self.reviews.backgroundColor = [UIColor clearColor];

//		self.starsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//		self.starsLabel.textColor = [UIColor blackColor];
//		self.starsLabel.font = [UIFont boldSystemFontOfSize:14.0];
//		self.starsLabel.backgroundColor = [UIColor clearColor];
//		self.starsLabel.text = @"Stars:";
//		
//		self.stars = [[UILabel alloc] initWithFrame:CGRectZero];
//		self.stars.textColor = [UIColor blueColor];
//		self.stars.font = [UIFont boldSystemFontOfSize:14.0];
//		self.stars.backgroundColor = [UIColor clearColor];
//		self.stars.text = @"0";
		
//		self.favoriteImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//		NSString *syncImagePath = [GlobalMethods dataFilePathofBundle:@"heartmysite.png"];
//		UIImage *syncImage = [[UIImage alloc] initWithContentsOfFile:syncImagePath];
//		self.favoriteImageView.image = syncImage;
//		[syncImage release];
		
		UIImageView *tempStarsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		self.starsImageView = tempStarsImageView;
		self.starsImageView.image = [UIImage imageNamed:@"0Stars"];
		//NSString *syncImagePath = [GlobalMethods dataFilePathofBundle:@"5stars.png"];
		//UIImage *syncImage = [[UIImage alloc] initWithContentsOfFile:syncImagePath];
		//self.starsImageView.image = syncImage;
		//[syncImage release];
		
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
//		[self.contentView addSubview:self.firstLine];
//		[self.contentView addSubview:self.secondLine];				
		[self.contentView addSubview:self.protocolName];
//		[self.contentView addSubview:self.reviewsLabel];
//		[self.contentView addSubview:self.reviews];
		[self.contentView addSubview:self.starsImageView];
		[self.contentView addSubview:self.makeFavorite];
		[self.contentView addSubview:self.activityIndicator];
//		[self.contentView addSubview:self.starsLabel];
//		[self.contentView addSubview:self.stars];
//		[self.contentView addSubview:self.favoriteImageView];
		
		
		
    }
    return self;
}


- (void)layoutSubviews {
	
	// total row height is 65,
	
// #define LEFT_INDENT 8
// #define UPPER_INDENT 2
	
	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;

	frame = CGRectMake(boundsX + 8, 2, 265, 40);
	self.protocolName.frame = frame;

	frame = CGRectMake(boundsX + 8, 43, 74, 20);
	self.starsImageView.frame = frame;
	
//	frame = CGRectMake(boundsX + 95, 50, 61, 21);
//	self.reviewsLabel.frame = frame;
//	
//	frame = CGRectMake(boundsX + 160, 50, 24, 22);
//	self.reviews.frame = frame;		
				
//	frame = CGRectMake(boundsX + 190, 40, 70, 40);
//	self.makeFavorite.frame = frame;

	frame = CGRectMake(boundsX + 130, 43, 120, 20);
	self.makeFavorite.frame = frame;
	
//	frame = CGRectMake(boundsX + 130, 43, 120, 20);
//	self.firstLine.frame = frame;
	
	frame = CGRectMake(boundsX + 175, 25, 36, 36);
	self.activityIndicator.frame = frame;
	
	
//	frame = CGRectMake(boundsX + 190, 43, 69, 18);
//	self.firstLine.frame = frame;
	
//	frame = CGRectMake(boundsX + 190, 58, 69, 18);
//	self.secondLine.frame = frame;

//	frame = CGRectMake(boundsX + 8, 50, 61, 21);
//	self.starsLabel.frame = frame;
//	
//	frame = CGRectMake(boundsX + 52, 50, 24, 22);
//	self.stars.frame = frame;	

//	frame = CGRectMake(boundsX + 8, 50, 74, 24);
//	self.starsImageView.frame = frame;	
	
					
//	frame = CGRectMake(boundsX 255, 50, 30, 30);
//	self.favoriteImage.frame = frame;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


//-(void) updateFavorite:(id)sender {
//	
////	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
////	[myNotificationCenter addObserver:self selector:@selector(changeFavoriteProtocolComplete:) name:@"ChangeFavoriteProtocol" object:nil];
////	
//
//	if(self.favorite == YES) {
//		[self.superview.superview.superview.superview.superview.superview.superview removeFavorite:[sender tag]];
//		self.favorite = NO;	
//	} else if (self.favorite == NO) {
//		[self.superview addFavorite:[sender tag]];
//		self.favorite = YES;
//	}
//}


//-(void)changeFavoriteProtocolComplete:(NSNotification*)notification {
////	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
////	[myNotificationCenter removeObserver:self name:@"GetProtocols" object:nil];
////	
////	if (![[notification object] errorReceived]) {  
////		
////		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
////		
////		//	NSLog(@"Protocols download time:  %@",[GlobalMethods getTimeElapsedFor:self.methodStartTime]);
////		//	self.methodStartTime = [NSDate date];
////		
////		[self.getProtocols release];
////		[self getFavoritesMethod];
////		
////		[pool release];
////	} else {
////		[self dataDownloadComplete:[[notification object] errorReceived]];
////	}
//
//}




-(void) startIndicator:(id)sender {
	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter addObserver:self selector:@selector(stopIndicator:) name:@"StopFavoriteIndicator" object:nil];
	self.activityIndicator.hidden = NO;
	[self.activityIndicator startAnimating];	
}

-(void) stopIndicator:(NSNotification*)notification {
	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter removeObserver:self name:@"StopFavoriteIndicator" object:nil];
	self.activityIndicator.hidden = YES;
	[self.activityIndicator stopAnimating];

}



@end
