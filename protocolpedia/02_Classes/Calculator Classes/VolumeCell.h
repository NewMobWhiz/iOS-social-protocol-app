//

//
//   6/5/10.



#import <UIKit/UIKit.h>



@interface VolumeCell : UITableViewCell {

	IBOutlet UILabel *name;
	IBOutlet UITextField *value;
	NSMutableArray *values;


	
}


@property (nonatomic,retain) IBOutlet UILabel *name;
@property (nonatomic,retain) IBOutlet UITextField *value;
@property (nonatomic,retain) NSMutableArray *values;





@end
