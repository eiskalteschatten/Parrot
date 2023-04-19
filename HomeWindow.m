//
//  HomeWindow.m
//  Parrot
//
//  Created by Alex Seifert on 05/10/31.
//  Copyright Alex Seifert 2005 . All rights reserved.
//

#import "HomeWindow.h"
#import <AppKit/AppKit.h>
#import "MyDocument.h"

@implementation HomeWindow

- (void)awakeFromNib
{
	NSRect frame = [self frame];
	NSRect screenRect = [[NSScreen mainScreen] frame];
	NSString *title = [@"Welcome to Parrot, " stringByAppendingString: NSFullUserName()];
	title = [title stringByAppendingString: @"!"];
	
	[self setTitle: title];
	
	frame.origin.x = ((screenRect.size.width / 2) - (frame.size.width / 2));
	frame.origin.y = (((screenRect.size.height / 2) - (frame.size.height / 2)) + 65);
	
	[self setFrame:frame display:YES animate:NO];
	
	[[homeWeb mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: @"http://www.google.de"]]];
	
	[self makeKeyAndOrderFront: self];
}

- (IBAction)newDocument:(id)sender
{
	//NSLog(@"testing");
	MyDocument *d = [[MyDocument alloc] init];
	if (![NSBundle loadNibNamed:@"MyDocument" owner:d]) {
		NSLog(@"Error loading Nib for document!");
	}
	else {
		[d makeWindows];
	}
}

@end
