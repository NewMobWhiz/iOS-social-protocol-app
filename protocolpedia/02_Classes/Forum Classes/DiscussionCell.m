//
//  DiscussionCell.m
//  ProtocolPedia
//
//   8/14/10.


#import "DiscussionCell.h"


@implementation DiscussionCell

@synthesize subject;
@synthesize submittedBy;
@synthesize submittedDate;
@synthesize hits;
@synthesize message;
@synthesize imageURLString;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {

		UILabel *tempSubject = [[UILabel alloc] initWithFrame:CGRectZero];
		self.subject = tempSubject;
		self.subject.textColor = [UIColor blackColor];
		self.subject.font = [UIFont boldSystemFontOfSize:16.0];
		self.subject.textAlignment = UITextAlignmentLeft;
		self.subject.backgroundColor = [UIColor clearColor];

		UILabel *tempSubmittedBy = [[UILabel alloc] initWithFrame:CGRectZero];
		self.submittedBy = tempSubmittedBy;
		self.submittedBy.textColor = [UIColor grayColor];
		self.submittedBy.font = [UIFont boldSystemFontOfSize:14.0];
		self.submittedBy.textAlignment = UITextAlignmentLeft;
		self.submittedBy.backgroundColor = [UIColor clearColor];

		UILabel *tempDate = [[UILabel alloc] initWithFrame:CGRectZero];
		self.submittedDate = tempDate;
		self.submittedDate.textColor = [UIColor grayColor];
		self.submittedDate.font = [UIFont boldSystemFontOfSize:12.0];
		self.submittedDate.textAlignment = UITextAlignmentLeft;
		self.submittedDate.backgroundColor = [UIColor clearColor];
		
		UILabel *tempHits = [[UILabel alloc] initWithFrame:CGRectZero];
		self.hits = tempHits;
		self.hits.textColor = [UIColor grayColor];
		self.hits.font = [UIFont boldSystemFontOfSize:12.0];
		self.hits.textAlignment = UITextAlignmentLeft;
		self.hits.backgroundColor = [UIColor clearColor];
				
		UITextView *tempMessage = [[UITextView alloc] initWithFrame:CGRectZero];
		self.message = tempMessage;
		self.message.textColor = [UIColor blackColor];
		self.message.font = [UIFont systemFontOfSize:14.0];
		self.message.textAlignment = UITextAlignmentLeft;
		self.message.userInteractionEnabled = NO;
		self.message.backgroundColor = [UIColor clearColor];
		self.message.dataDetectorTypes = UIDataDetectorTypeLink;
		
		self.accessoryType = UITableViewCellAccessoryNone;
		
		[self.contentView addSubview:self.subject];
		[self.contentView addSubview:self.submittedBy];       
		[self.contentView addSubview:self.submittedDate];
		[self.contentView addSubview:self.hits];
		[self.contentView addSubview:self.message];
	
		
    }
    return self;
}

- (void)layoutSubviews {
	
	
#define LEFT_INDENT 8
#define UPPER_INDENT 2
	
	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	
	frame = CGRectMake(boundsX + LEFT_INDENT, UPPER_INDENT, 300, 40);
	self.subject.frame = frame;
	self.subject.adjustsFontSizeToFitWidth = YES;
	self.subject.minimumFontSize = 10;
	
	frame = CGRectMake(boundsX + LEFT_INDENT, UPPER_INDENT + 30, 300, 20);
	self.submittedBy.frame = frame;
	self.submittedBy.adjustsFontSizeToFitWidth = NO;

	frame = CGRectMake(boundsX + LEFT_INDENT, UPPER_INDENT + 50, 200, 20);
	self.submittedDate.frame = frame;
	self.submittedDate.adjustsFontSizeToFitWidth = NO;
		
	frame = CGRectMake(boundsX + LEFT_INDENT + 220, UPPER_INDENT + 50, 60, 20);
	self.hits.frame = frame;
	self.hits.adjustsFontSizeToFitWidth = NO;
	
	frame = CGRectMake(boundsX + LEFT_INDENT, UPPER_INDENT + 70, 300, 400);
	self.message.frame = frame;
	
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
