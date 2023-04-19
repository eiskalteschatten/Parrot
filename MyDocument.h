//
//  MyDocument.h
//  Parrot
//
//  Created by Alex Seifert on 05/10/31.
//  Copyright 2005 Alex Seifert. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface MyDocument : NSDocument
{
	IBOutlet WebView *mainBrowser;
	IBOutlet NSTabView *tabs;
	IBOutlet NSProgressIndicator *progBar;
	IBOutlet NSTextField *statusBar;
	IBOutlet NSImageView *iconImg;
	IBOutlet NSTextField *urlBar;
	IBOutlet NSImageView *animationImg;
	
	int resourceCount;
	int resourceFailedCount;
	int resourceCompletedCount;
	
	bool popUps;
	
@public
	NSURL *openURL;
	
	NSString *currURL;
}

//- (IBAction)saveDocumentAs:(id)sender;
- (void)makeWindows;

@end
