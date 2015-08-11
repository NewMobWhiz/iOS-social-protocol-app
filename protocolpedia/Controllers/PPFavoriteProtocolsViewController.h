//
//  PPFavoriteProtocolsViewController.h
//  ProtocolPedia
//
//  26/02/14.


#import <UIKit/UIKit.h>
#import "PPProtocolsListViewController.h"

@interface PPFavoriteProtocolsViewController : PPProtocolsListViewController

@property(nonatomic, retain) NSString  *thisFavorite;
@property(nonatomic, assign) int currentTag;


@end
