//
//  MyDocumentWindow.h
//  Parrot
//
//  Created by Alex Seifert on 05/11/03.
//  Copyright 2005 Alex Seifert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyDocumentWindow : NSWindowController {
	IBOutlet WebView *mainBrowser;
	IBOutlet NSTabView *tabs;
	IBOutlet NSProgressIndicator *progBar;
	IBOutlet NSTextField *statusBar;
	IBOutlet NSImageView *iconImg;
	IBOutlet NSTextField *urlBar;
	IBOutlet NSSearchField *searchBar;
	IBOutlet NSImageView *animationImg;
	
	int resourceCount;
	int resourceFailedCount;
	int resourceCompletedCount;
	
	bool popUps;
	
	NSString *currURL;
	NSToolbar *toolbar;
	NSMutableDictionary *items;
	NSURL *openText;
}

- (void)updateResourceStatus;
- (void)makeToolbarItems;
- (IBAction)customizeToolbar:(id)sender;
- (float)ToolbarHeightForWindow;
- (void)goToUrl:(NSString*)where;
- (IBAction)goToSearchBar:(id)sender;
- (IBAction)goToUrlBar:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)stopPage:(id)sender;
- (IBAction)reloadPage:(id)sender;
- (void)setAnimationImg:(NSImageView*)animation;

@end
