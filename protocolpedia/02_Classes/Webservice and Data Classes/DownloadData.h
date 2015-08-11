//
//  DownloadData.h
//  ProtocolPedia
//
//   7/13/10.


#import <Foundation/Foundation.h>
#import "GetProtocols.h"
#import "GetFavorites.h"
#import "GetCategories.h"
#import "GetProtocolReviews.h"
#import "GetForumDiscussions.h"
#import "GetVideos.h"
#import "GetContributors.h"
#import "GetCategoryRelations.h"


@interface DownloadData : NSObject {

	IBOutlet UILabel *downloadLabel;
	IBOutlet UILabel *lastDownload;
	IBOutlet UIButton *startDownload;
	UIImageView *downloadImageView;
	GetProtocols *getProtocols;
	GetFavorites *getFavorites;
	GetCategories *getCategories;
	GetCategoryRelations *getCategoryRelations;
	GetProtocolReviews *getProtocolReviews;
	GetForumDiscussions *getForumDiscussions;
	GetVideos *getVideos;
	GetContributors *getContributors;	
	UIActivityIndicatorView *activityIndicator;	

	NSDate *methodStartTime;
	NSDate *totalTime;
	
}


@property (nonatomic,retain) IBOutlet UILabel *downloadLabel;
@property (nonatomic,retain) IBOutlet UILabel *lastDownload;
@property (nonatomic, retain) IBOutlet	UIButton *startDownload;
@property(nonatomic, retain) GetProtocols *getProtocols;
@property(nonatomic, retain) GetFavorites *getFavorites;
@property(nonatomic, retain) GetCategories *getCategories;
@property(nonatomic, retain) GetCategoryRelations *getCategoryRelations;
@property(nonatomic, retain) GetProtocolReviews *getProtocolReviews;
@property(nonatomic, retain) GetForumDiscussions *getForumDiscussions;
@property(nonatomic, retain) GetVideos *getVideos;	
@property(nonatomic, retain) GetContributors *getContributors;

@property(nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property(nonatomic, retain) UIImageView *downloadImageView;

@property(nonatomic, retain) NSDate *methodStartTime;
@property(nonatomic, retain) NSDate *totalTime;



-(void) downloadData;

-(void) getProtocolsMethod;
-(void) getProtocolsComplete:(NSNotification *)notification;

-(void) getFavoritesMethod;
-(void) getFavoritesComplete:(NSNotification *)notification;

-(void) getCategoriesMethod;
-(void) getCategoriesComplete:(NSNotification *)notification;

-(void) getCategoryRelationsMethod;
-(void) getCategoryRelationsComplete:(NSNotification *)notification;

-(void) getProtocolReviewsMethod;
-(void) getProtocolReviewsComplete:(NSNotification *)notification;

-(void) getForumDiscussionsMethod;
-(void) getForumDiscussionsComplete:(NSNotification *)notification;

-(void) getVideosMethod;
-(void) getVideosComplete:(NSNotification *)notification;

-(void) getContributorsMethod;
-(void) getContributorsComplete:(NSNotification *)notification;

-(void) dataDownloadComplete:(NSString*)success;
-(void) deleteNavBarMessage;

@end
