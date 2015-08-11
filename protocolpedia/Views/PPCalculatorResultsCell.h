//
//  PPCalculatorResultsCell.h
//  ProtocolPedia
//
//  04/03/14.


#import <UIKit/UIKit.h>

@interface PPCalculatorResultsCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *resultsName;
@property (nonatomic,strong) IBOutlet UILabel *result;
@property (nonatomic,strong) IBOutlet UILabel *resultUnits;

@end
