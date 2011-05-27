
@interface NotificationViewController : NSViewController {
    NSString *_titleLine;
    NSString *_subjectLine1;
    NSString *_subjectLine2;
}

@property (nonatomic, retain) IBOutlet NSString *titleLine;
@property (nonatomic, retain) IBOutlet NSString *subjectLine1;
@property (nonatomic, retain) IBOutlet NSString *subjectLine2;

@end
