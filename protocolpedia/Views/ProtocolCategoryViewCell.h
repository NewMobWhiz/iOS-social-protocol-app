//
//  ProtocolCategoryViewCell.h
//  ProtocolPedia
//
//  20/02/14.
//

#import <UIKit/UIKit.h>

@interface ProtocolCategoryViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *protocolCategoryImageView;
@property (nonatomic, strong) IBOutlet UILabel *protocolCategoryTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *protocolCategoryDescriptionLabel;

@end
