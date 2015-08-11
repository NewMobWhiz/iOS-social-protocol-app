//
//  DownloadCell.h
//  ProtocolPedia
//
//   8/16/10.


#import <UIKit/UIKit.h>


@interface DownloadCell : UITableViewCell {

	IBOutlet UILabel *mainLabel;
	IBOutlet UILabel *subLabel;
	IBOutlet UIImageView *reloadImage;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	
	
	
}

@property (nonatomic,retain) IBOutlet UILabel *mainLabel;
@property (nonatomic,retain) IBOutlet UILabel *subLabel;
@property (nonatomic,retain) IBOutlet UIImageView *reloadImage;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void) updateMessage:(NSNotification *)notification;
-(void) updateActivityIndicator:(NSNotification *)notification;
-(void) lastDownload;

@end
