//
//  PPCalculatorDataEntryCell.h
//  ProtocolPedia
//
//  04/03/14.


#import <UIKit/UIKit.h>

@interface PPCalculatorDataEntryCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *dataName;
@property (nonatomic,strong) IBOutlet UILabel *dataUnits;
@property (nonatomic,strong) IBOutlet UITextField *dataValue;

@end
