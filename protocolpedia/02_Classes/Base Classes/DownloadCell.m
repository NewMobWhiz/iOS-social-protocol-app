//
//  DownloadCell.m
//  ProtocolPedia
//
//   8/16/10.


#import "DownloadCell.h"
#import "PPAppDelegate.h"


@implementation DownloadCell

@synthesize mainLabel;
@synthesize subLabel;
@synthesize reloadImage;
@synthesize activityIndicator;

- (void)dealloc {
	NSNotificationCenter *allDataDownloadCompleteNotificationCenter = [NSNotificationCenter defaultCenter];
	[allDataDownloadCompleteNotificationCenter removeObserver:self name:@"downloadStatusMessage" object:nil];
	[allDataDownloadCompleteNotificationCenter removeObserver:self name:@"downloadActivityIndicator" object:nil];

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
	
		NSNotificationCenter *syncStatusMessageNotificationCenter = [NSNotificationCenter defaultCenter];
		[syncStatusMessageNotificationCenter addObserver:self selector:@selector(updateMessage:) name:@"downloadStatusMessage" object:nil];
		[syncStatusMessageNotificationCenter addObserver:self selector:@selector(updateActivityIndicator:) name:@"downloadActivityIndicator" object:nil];
		
		UILabel *tempMainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.mainLabel = tempMainLabel;
		self.mainLabel.textColor = [UIColor blackColor];
		self.mainLabel.font = [UIFont boldSystemFontOfSize:18.0];
		self.mainLabel.textAlignment = UITextAlignmentLeft;
		self.mainLabel.backgroundColor = [UIColor clearColor];
		self.mainLabel.text = @"Download Protocols";
		
		UILabel *tempSubLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.subLabel = tempSubLabel;
		self.subLabel.textColor = [UIColor grayColor];
		self.subLabel.font = [UIFont boldSystemFontOfSize:14.0];
		self.subLabel.textAlignment = UITextAlignmentLeft;
		self.subLabel.backgroundColor = [UIColor clearColor];
		
		UIImageView *tempReloadImage = [[UIImageView alloc] initWithFrame:CGRectZero];
		self.reloadImage = tempReloadImage;
		NSString *syncImagePath = [GlobalMethods dataFilePathofBundle:@"ButtonDown.png"];
		UIImage *syncImage = [[UIImage alloc] initWithContentsOfFile:syncImagePath];
		self.reloadImage.image = syncImage;
		
		UIActivityIndicatorView *tempActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		self.activityIndicator = tempActivityIndicator;
		self.activityIndicator.hidden = YES;
		self.activityIndicator.hidesWhenStopped = YES;
		[self.activityIndicator stopAnimating];					
		
		[self.contentView addSubview:self.mainLabel];
		[self.contentView addSubview:self.subLabel];       
		[self.contentView addSubview:self.reloadImage];
		[self.contentView addSubview:self.activityIndicator];
		
		
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	
	frame = CGRectMake(boundsX + 53, 2, 300, 20);
	self.mainLabel.frame = frame;
	self.mainLabel.adjustsFontSizeToFitWidth = NO;
	
	frame = CGRectMake(boundsX + 53, 2 + 20, 300, 20);
	self.subLabel.frame = frame;
	self.subLabel.adjustsFontSizeToFitWidth = NO;
	
	frame = CGRectMake(boundsX , 0, 44, 44);
	self.reloadImage.frame = frame;

	frame = CGRectMake(boundsX + 2 + 255, 4, 36, 36);
	self.activityIndicator.frame = frame;
}


-(void) lastDownload {
	PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
//	if ([[appDelegate.settings objectForKey:@"LastDownload"] isEqualToString:@"No Protocols Downloaded"]) {
//		self.subLabel.text = @"No Protocols Downloaded";
//	} else {
		self.subLabel.text = [NSString stringWithFormat:@"Downloaded: %@",[appDelegate.settings objectForKey:@"LastDownload"]];
//	}
}


-(void) updateMessage:(NSNotification *)notification {
	if ([[notification object] isEqualToString:@"complete"]) {
		[self lastDownload];
	} else {
		self.subLabel.text = [notification object];
	}
}


-(void) updateActivityIndicator:(NSNotification *)notification {
	if ([[notification object] isEqualToString:@"Yes"]) {
		self.activityIndicator.hidden = NO;
		[self.activityIndicator startAnimating];
	} else if ([[notification object] isEqualToString:@"No"]){
		self.activityIndicator.hidden = YES;
		[self.activityIndicator stopAnimating];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
