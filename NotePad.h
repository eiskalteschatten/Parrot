//
//  NotePad.h
//  Parrot
//
//  Created by Alex Seifert on 05/11/05.
//  Copyright 2005 Alex Seifert. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NotePad : NSWindow {
	IBOutlet NSTextView *textView;
}

- (IBAction)saveNotes:(id)sender;

@end
