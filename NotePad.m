//
//  NotePad.m
//  Parrot
//
//  Created by Alex Seifert on 05/11/05.
//  Copyright 2005 Alex Seifert. All rights reserved.
//

#import "NotePad.h"


@implementation NotePad

- (IBAction)saveNotes:(id)sender
{

}

- (NSRect)windowWillUseStandardFrame:(NSWindow *)sender defaultFrame:(NSRect)defaultFrame
{
	NSRect rect = defaultFrame;
	
	rect.size.height -= 90;
	
	return rect;
}

@end
