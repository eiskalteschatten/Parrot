//
//  CSignOn.h
//  Parrot
//
//  Created by Alex Seifert on 05/10/31.
//  Copyright 2005 Alex Seifert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CSignOn : NSObject {
	IBOutlet NSWindow *welcomeWindow;
	IBOutlet NSComboBox *uName;
	IBOutlet NSTextField *pWord;
	IBOutlet NSProgressIndicator *signOnCircle;
	IBOutlet NSButton *signOnButton;
	IBOutlet NSButton *signUpButton;
	IBOutlet NSButton *donateButton;
	IBOutlet NSButton *cancelButton;

	IBOutlet NSWindow *generalBrowWindow;
	IBOutlet WebView *generalWebView;
	
	IBOutlet NSWindow *homeWindow;
}

- (IBAction)signOn:(id)sender;
- (IBAction)cancelSignOn:(id)sender;
- (IBAction)signUp:(id)sender;
- (IBAction)donate:(id)sender;

@end
