//
//  Toolbar.m
//  Parrot
//
//  Created by Alex Seifert on 05/10/31.
//  Copyright Alex Seifert 2005 . All rights reserved.
//

#import "Toolbar.h"
#import <AppKit/AppKit.h>
#import "MyDocument.h"
#import "MyDocumentWindow.h"

@implementation Toolbar

- (id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    NSWindow* result = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	NSRect frame = [result frame];
	NSRect screenRect = [[NSScreen mainScreen] frame];

	frame.size.width = screenRect.size.width;
	frame.size.height = 70;
	frame.origin.x = 0;
	frame.origin.y = (screenRect.size.height - (frame.size.height + 22));

	[result setFrame:frame display:YES animate:NO];
    [result setLevel: NSFloatingWindowLevel];
	
	[result orderBack: result];
	
    return result;
}

- (void)awakeFromNib
{
	NSRect frame = [self frame];
	
	NSImage *bgImg = [NSImage imageNamed:@"Toolbar BG"];
	NSImageView *bgImage = [[NSImageView alloc] initWithFrame: NSMakeRect(0, 0, frame.size.width, frame.size.height)];
	[[self contentView] addSubview: bgImage];
	[bgImage setImage: bgImg];
	[bgImage setImageScaling: NSScaleToFit];
	[bgImage setImageFrameStyle: NSImageFrameNone];
	[bgImage setNeedsDisplay: YES];
	
	NSButton *internetButton = [[NSButton alloc] initWithFrame: NSMakeRect(20, 10, 60, 50)];
	[[self contentView] addSubview: internetButton];
	[internetButton setTitle: @"Internet"];
	[internetButton setButtonType: NSMomentaryPushButton];
	[internetButton setBordered: NO];
	[internetButton setAction:@selector(newDocument:)];
	
	NSButton *emailButton = [[NSButton alloc] initWithFrame: NSMakeRect(100, 10, 60, 50)];
	[[self contentView] addSubview: emailButton];
	[emailButton setTitle: @"Read"];
	[emailButton setButtonType: NSMomentaryPushButton];
	[emailButton setBordered: NO];
	[emailButton setAction:@selector(newDocument:)];
		
	NSButton *writeEmailButton = [[NSButton alloc] initWithFrame: NSMakeRect(180, 10, 60, 50)];
	[[self contentView] addSubview: writeEmailButton];
	[writeEmailButton setTitle: @"Write"];
	[writeEmailButton setButtonType: NSMomentaryPushButton];
	[writeEmailButton setBordered: NO];
	[writeEmailButton setAction:@selector(newDocument:)];
			
	NSButton *imButton = [[NSButton alloc] initWithFrame: NSMakeRect(260, 10, 60, 50)];
	[[self contentView] addSubview: imButton];
	[imButton setTitle: @"IM"];
	[imButton setButtonType: NSMomentaryPushButton];
	[imButton setBordered: NO];
	[imButton setAction:@selector(newDocument:)];
			
	NSButton *favButton = [[NSButton alloc] initWithFrame: NSMakeRect(340, 10, 60, 50)];
	[[self contentView] addSubview: favButton];
	[favButton setTitle: @"Bookmarks"];
	[favButton setButtonType: NSMomentaryPushButton];
	[favButton setBordered: NO];
	[favButton setAction:@selector(newDocument:)];
	
	[self orderBack: self];
}

- (BOOL) canBecomeKeyWindow {
    return NO;
}

@end