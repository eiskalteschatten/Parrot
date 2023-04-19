//
//  HomeWindow.h
//  Parrot
//
//  Created by Alex Seifert on 05/10/31.
//  Copyright Alex Seifert 2005 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HomeWindow : NSWindow {
	IBOutlet WebView *homeWeb;
}

- (void)awakeFromNib;
- (IBAction)newDocument:(id)sender;

@end
