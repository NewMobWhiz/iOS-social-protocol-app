//

//
//   6/5/10.


#import <UIKit/UIKit.h>



@interface DataEntryCell : UITableViewCell {

	IBOutlet UILabel *dataName;
	IBOutlet UILabel *dataUnits;
	IBOutlet UITextField *dataValue;

	
}


@property (nonatomic,retain) IBOutlet UILabel *dataName;
@property (nonatomic,retain) IBOutlet UILabel *dataUnits;
@property (nonatomic,retain) IBOutlet UITextField *dataValue;






@end
