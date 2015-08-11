//
//  ProtocolCell.h
//  bilfo
//
//   6/5/10.



#import <UIKit/UIKit.h>
#import "ChangeFavoriteProtocol.h"

@interface ProtocolCell : UITableViewCell {

	IBOutlet UIButton *makeFavorite;
	IBOutlet UILabel *protocolName;
	IBOutlet UILabel *reviewsLabel;
	IBOutlet UILabel *reviews;
	IBOutlet UIImageView *favoriteImageView;
	IBOutlet UIImageView *starsImageView;
	IBOutlet UILabel *firstLine;
	IBOutlet UILabel *secondLine;
//	IBOutlet UILabel *starsLabel;
//	IBOutlet UILabel *stars;
	ChangeFavoriteProtocol *changeFavoriteProtocol;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSString *protocolId;
	BOOL favorite;
	
}

@property (nonatomic,retain) IBOutlet UIButton *makeFavorite;
@property (nonatomic,retain) IBOutlet UILabel *protocolName;
@property (nonatomic,retain) IBOutlet UILabel *reviewsLabel;
@property (nonatomic,retain) IBOutlet UILabel *reviews;
@property (nonatomic,retain) IBOutlet UIImageView *favoriteImageView;
@property (nonatomic,retain) IBOutlet UIImageView *starsImageView;
@property (nonatomic,retain) IBOutlet UILabel *firstLine;
@property (nonatomic,retain) IBOutlet UILabel *secondLine;
//@property (nonatomic,retain) IBOutlet UILabel *starsLabel;
//@property (nonatomic,retain) IBOutlet UILabel *stars;
@property (nonatomic,retain) ChangeFavoriteProtocol *changeFavoriteProtocol;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,retain) NSString *protocolId;
@property (nonatomic,assign) BOOL favorite;


//-(void) updateFavorite:(id)sender;
//-(void)changeFavoriteProtocolComplete:(NSNotification*)notification;
-(void) startIndicator:(id)sender;
-(void) stopIndicator:(NSNotification*)notification;


@end
