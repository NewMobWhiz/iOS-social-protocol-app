//
//  LABTIMING.h
//  ProtocolPedia
//


#import <UIKit/UIKit.h>


@interface LABTIMING : UIViewController {
	int state;
	NSDate *timeStart;
	int hour;
	int min;
	int sec;
	NSDate *timeEnd;
	NSString *timerText;
	int timerNumber;
	UIImageView *stateImageView;
	NSString *theTextAboutThisTimer;
}
-(NSString*)getTime;
-(void)initWithState:(int)number withImageView:(UIImageView*)img;
-(NSString*)getCurrentTimeRemainingString;
-(void)setPlay;
-(void)setPause;
-(void)setStop;
-(void)setReset;
-(void)setRing;
@property (nonatomic) int state;
@property (nonatomic,retain) NSDate *timeStart;
@property (nonatomic,retain) NSString *theTextAboutThisTimer;
@property (nonatomic,retain) NSDate *timeEnd;
@property (nonatomic,retain) NSString *timerText;
@end
