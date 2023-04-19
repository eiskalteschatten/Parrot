//
//  SignOn.m
//  Parrot
//
//  Created by Alex Seifert on 05/10/31.
//  Copyright Alex Seifert 2005 . All rights reserved.
//

#import "SignOn.h"
#import <AppKit/AppKit.h>

@implementation SignOn

- (void)awakeFromNib
{
	NSRect frame = [self frame];
	NSRect screenRect = [[NSScreen mainScreen] frame];
	
	frame.origin.x = ((screenRect.size.width / 2) - (frame.size.width / 2));
	frame.origin.y = ((screenRect.size.height / 2) - (frame.size.height / 2));
	
	[self setFrame:frame display:YES animate:NO];
}

@end
