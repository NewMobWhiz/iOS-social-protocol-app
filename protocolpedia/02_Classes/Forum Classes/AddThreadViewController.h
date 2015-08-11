//
//  AddThreadViewController.h
//  ProtocolPedia
//
//   9/14/10.


#import <UIKit/UIKit.h>
#import "PPAbstractViewController.h"
#import "AddThread.h"

@interface AddThreadViewController : PPAbstractViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

	IBOutlet UITextView *discussionTextView;
	IBOutlet UITextField *subjectTextField;
	NSMutableString *discussionText;
	NSString *subjectText;
	NSString *threadId;
	UIImage *selectedImage;
	IBOutlet UIImageView *selectedImageView;
	IBOutlet UIActivityIndicatorView *activityIndicator;

	
}

@property(nonatomic,retain) IBOutlet UITextView *discussionTextView;
@property(nonatomic,retain) IBOutlet UITextField *subjectTextField;
@property(nonatomic,retain) NSMutableString *discussionText;
@property(nonatomic,retain) NSString *subjectText;
@property(nonatomic,retain) NSString *threadId;
@property(nonatomic,retain) UIImage *selectedImage;
@property(nonatomic,retain) IBOutlet UIImageView *selectedImageView;;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) NSString *threadTitle;


-(IBAction) resignTextView;
-(IBAction) addPhoto:(id)sender;
-(IBAction) takePhoto:(id)sender;
-(IBAction) deletePhoto:(id)sender;
-(void) cancelTopic:(id)sender;
-(void) submitTopic:(id)sender;

@end
