//
//  PPCalculatorVolumeCell.h
//  ProtocolPedia
//
//  05/03/14.


#import <UIKit/UIKit.h>

@interface PPCalculatorVolumeCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *name;
@property (nonatomic,strong) IBOutlet UITextField *value;
@property (nonatomic,strong) NSMutableArray *values;

@end
