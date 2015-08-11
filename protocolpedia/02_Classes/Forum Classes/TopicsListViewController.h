//
//  TopicsListViewController.h
//  ProtocolPedia
//
//   8/14/10.


#import <UIKit/UIKit.h>
#import "BaseViewController.h"



@interface TopicsListViewController : BaseViewController  {


	NSString *categoryId;
    UIView *viewHeader;


}


@property(nonatomic,retain) NSString *categoryId;


-(void) addTopic:(id)sender;
-(void) reloadTable:(NSNotification*)notification;

@end
