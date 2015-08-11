//
//  AddTopicViewController.m
//  ProtocolPedia
//
//   9/10/10.


#import "AddTopicViewController.h"




@implementation AddTopicViewController


@synthesize discussionTextView;
@synthesize subjectTextField;
@synthesize discussionText;
@synthesize subjectText;
@synthesize categoryId;
@synthesize selectedImage;
@synthesize selectedImageView;
@synthesize activityIndicator;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
	self.activityIndicator.hidden = YES;
	self.activityIndicator.hidesWhenStopped = YES;
	[self.activityIndicator stopAnimating];	
	self.activityIndicator.frame = CGRectMake(135, 100, 50, 50);
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelTopic:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = cancelButton;
	
	// set submit Topic button for this view	
	UIBarButtonItem *submitTopicBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(submitTopic:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationItem.leftBarButtonItem = submitTopicBarItem;
	
	self.discussionTextView.delegate = self;
	self.subjectTextField.delegate = self;
	
	
}

-(void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:NO];
	[self.activityIndicator stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(void) cancelTopic:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void) submitTopic:(id)sender {
	if ([self.subjectText length] > 0) {
		if ([self.discussionText length] > 0) {
			[self.activityIndicator startAnimating];
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
			NSString *discussionTextWithiPhone = [NSString stringWithFormat:@"Posted via ProtocolPedia iPhone App\n\n%@",self.discussionText];
			NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(self.selectedImage, 0.5)];
			[applicationDelegate addTopicTo:@"Topic" withId:self.categoryId withSubject:self.subjectText withMessageText:discussionTextWithiPhone withPhoto:imageData];
			[self.navigationController popViewControllerAnimated:YES];
		} else {
			[GlobalMethods displayMessage:@"Must have a Message"];
		}
	} else {
		[GlobalMethods displayMessage:@"Must have a subject"];
	}
}

- (void)textViewDidChange:(UITextView *)textView {
	self.discussionText = (NSMutableString*)textView.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	self.subjectText = textField.text;
	


}

-(IBAction) resignTextView {
	[self.discussionTextView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}


-(IBAction) addPhoto:(id)sender {
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		imagePicker.delegate = self;
		[self presentModalViewController:imagePicker animated:YES];
		
	} else {
		[GlobalMethods displayMessage:@"Photo library not available on this device"];
	}	
}

-(IBAction) takePhoto:(id)sender {
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		imagePicker.delegate = self;
		[self presentModalViewController:imagePicker animated:YES];
			} else {
		[GlobalMethods displayMessage:@"Camera not available on this device"];
	}	
}

-(IBAction) deletePhoto:(id)sender {
	self.selectedImageView.image = nil;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	// Set the image for the photo object.
	
	if ([info objectForKey:@"UIImagePickerControllerMediaURL"]) {
		self.selectedImage = [info objectForKey:@"UIImagePickerControllerMediaURL"];	
	} else if ([info objectForKey:@"UIImagePickerControllerCropRect"]) {
		self.selectedImage = [info objectForKey:@"UIImagePickerControllerCropRect"];	
	} else if ([info objectForKey:@"UIImagePickerControllerEditedImage"]) {
		self.selectedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];	
	} else if ([info objectForKey:@"UIImagePickerControllerOriginalImage"]) {
		self.selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];	
	}
	
//	+ (UIImage*)imageWithImage:(UIImage*)image 
//scaledToSize:(CGSize)newSize;
//	{
//		UIGraphicsBeginImageContext( newSize );
//		[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//		UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//		UIGraphicsEndImageContext();
//		
//		return newImage;
//	}

//	NSData *imageData = [[NSData alloc] initWithData:UIImagePNGRepresentation(self.selectedImage)];
//     NSData *imageData = UIImageJPEGRepresentation(image.image, 0.9); limits size of image file  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  90 Bif  0.9  small
//	NSInteger size = imageData.length;
//	[imageData release];
	//	NSLog(@"size  %i",size);
//	if (size > 1000000) {
//		NSString *messageForAlert = [NSString stringWithFormat:@"File size = %.3f MB.  Greater than 1 MB will impact performance, please select another",(float)size/1000000] ;
//		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File Size" message:messageForAlert delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alertView show];
//		[alertView release];
//    } else {
		self.selectedImageView.image = self.selectedImage;
		[self dismissModalViewControllerAnimated:YES];
//	}	
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown);
}


-(BOOL) shouldAutorotate{
    return YES;
}

-(NSUInteger) supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	BOOL shouldChangeText = YES;
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		shouldChangeText = NO;
	}
	return shouldChangeText;
} 


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end
