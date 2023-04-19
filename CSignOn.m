//
//  CSignOn.m
//  Parrot
//
//  Created by Alex Seifert on 05/10/31.
//  Copyright 2005 Alex Seifert. All rights reserved.
//

#import "CSignOn.h"
#import "HomeWindow.h"

@implementation CSignOn

- (IBAction)signOn:(id)sender {
	[signOnCircle startAnimation: self];
	[uName setEditable: NO];
	[pWord setEditable: NO];
	[sender setEnabled: NO];
	[signUpButton setEnabled: NO];
	[donateButton setEnabled: NO];
	[cancelButton setEnabled: YES];

	//insert sign on code here

	[signOnCircle stopAnimation: self];
	[uName setEditable: YES];
	[pWord setEditable: YES];
	[sender setEnabled: YES];
	[signUpButton setEnabled: YES];
	[donateButton setEnabled: YES];	
	[cancelButton setEnabled: NO];	
	
	[welcomeWindow orderOut: self];
	[homeWindow makeKeyAndOrderFront: self];
}

- (IBAction)cancelSignOn:(id)sender {
	[signOnCircle stopAnimation: self];
	[uName setEditable: YES];
	[pWord setEditable: YES];
	[signOnButton setEnabled: YES];
	[signUpButton setEnabled: YES];
	[donateButton setEnabled: YES];
	[sender setEnabled: NO];
}

- (IBAction)signUp:(id)sender
{
	[generalBrowWindow makeKeyAndOrderFront: self];
	[generalBrowWindow setTitle: @"Sign up for Parrot"];
	
	[[generalWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: @"http://www.alexseifert.com"]]];
}

- (IBAction)donate:(id)sender
{
	[generalBrowWindow makeKeyAndOrderFront: self];
	[generalBrowWindow setTitle: @"Donate to Parrot"];
	
	[[generalWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: @"http://www.yahoo.de"]]];
}

@end
