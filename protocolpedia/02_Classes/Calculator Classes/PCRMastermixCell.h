//

//
//   6/5/10.



#import <UIKit/UIKit.h>



@interface PCRMastermixCell : UITableViewCell {

	IBOutlet UILabel *name;
	IBOutlet UILabel *stockLabel;
	IBOutlet UILabel *finalLabel;
	IBOutlet UILabel *volumeLabel;
	IBOutlet UITextField *stock;
	IBOutlet UITextField *final;
	IBOutlet UILabel *volume;

	
}


@property (nonatomic,retain) IBOutlet UILabel *name;
@property (nonatomic,retain) IBOutlet UILabel *stockLabel;
@property (nonatomic,retain) IBOutlet UILabel *finalLabel;
@property (nonatomic,retain) IBOutlet UILabel *volumeLabel;
@property (nonatomic,retain) IBOutlet UITextField *stock;
@property (nonatomic,retain) IBOutlet UITextField *final;
@property (nonatomic,retain) IBOutlet UILabel *volume;





@end
