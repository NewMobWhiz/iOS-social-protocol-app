//
//  DiscussionCell.h
//  ProtocolPedia
//
//   8/14/10.


#import <UIKit/UIKit.h>


@interface DiscussionCell : UITableViewCell {

	IBOutlet UILabel *subject;
	IBOutlet UILabel *submittedBy;
	IBOutlet UILabel *submittedDate;
	IBOutlet UILabel *hits;
	IBOutlet UITextView *message;
	NSString *imageURLString;
	
	
	
}


@property (nonatomic,retain) IBOutlet UILabel *subject;
@property (nonatomic,retain) IBOutlet UILabel *submittedBy;
@property (nonatomic,retain) IBOutlet UILabel *submittedDate;
@property (nonatomic,retain) IBOutlet UILabel *hits;
@property (nonatomic,retain) IBOutlet UITextView *message;
@property (nonatomic,retain) NSString *imageURLString;

@end
