//
//  MyDocumentWindow.m
//  Parrot
//
//  Created by Alex Seifert on 05/11/03.
//  Copyright 2005 Alex Seifert. All rights reserved.
//

#import "MyDocument.h";
#import "MyDocumentWindow.h";

@implementation MyDocumentWindow

#pragma mark -
#pragma mark Window Functions

- (void)windowWillLoad
{	
	[self setShouldCascadeWindows: NO];
}

- (void)windowDidLoad
{	
	urlBar = [[NSTextField alloc] initWithFrame: NSMakeRect(22, 22, 22, 22)];
	[[urlBar cell] setPlaceholderString:@"Type a web address here"];
	[urlBar setAction:@selector(goToUrlBar:)];
	
	searchBar = [[NSSearchField alloc] initWithFrame: NSMakeRect(22, 22, 22, 22)];
	[[searchBar cell] setPlaceholderString:@"Google Search"];
	[searchBar setRecentsAutosaveName:@"searchBarRecent"];
	[searchBar setAction:@selector(goToSearchBar:)];
	
	items = [[NSMutableDictionary alloc] init];
	[self makeToolbarItems];
	
	toolbar = [[NSToolbar alloc] initWithIdentifier:@"browserToolbar"];
	[toolbar setDelegate:self];
	[toolbar setAllowsUserCustomization:YES];
	[toolbar setAutosavesConfiguration:YES];
	[[self window] setToolbar:toolbar];
	
	NSRect frame = [[self window] frame];
	NSRect screenRect = [[NSScreen mainScreen] frame];
	NSRect visibleRect = [[NSScreen mainScreen] visibleFrame];
	
	frame.size.width = (visibleRect.size.width - 40);
	frame.origin.x = ((visibleRect.size.width / 2) - (frame.size.width / 2));
	frame.size.height = (visibleRect.size.height - 72);
	frame.origin.y = (screenRect.size.height - visibleRect.size.height - 22);
	
	[[self window] setFrame:frame display:YES animate:NO];
	
	MyDocument *d = [self document];	
	openText = d->openURL;

	[[mainBrowser mainFrame] loadRequest:[NSURLRequest requestWithURL: openText]];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
    return (@"Internet");
}

- (NSRect)windowWillUseStandardFrame:(NSWindow *)sender defaultFrame:(NSRect)defaultFrame
{
	NSRect rect = defaultFrame;
	
	rect.size.height -= 70;
	
	return rect;
}

#pragma mark -
#pragma mark WebView Functions

- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    id myDocument = [[NSDocumentController sharedDocumentController] openUntitledDocumentOfType:@"DocumentType" display:YES];

    [[[myDocument webView] mainFrame] loadRequest:request];

    return [myDocument webView];
}

- (void)webViewShow:(WebView *)sender
{
    id myDocument = [[NSDocumentController sharedDocumentController] documentForWindow:[sender window]];
    [myDocument showWindows];
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    if (frame == [sender mainFrame]){
        [[sender window] setTitle:title];
		
		NSTabViewItem *tab = [tabs selectedTabViewItem];
		[tab setLabel:title];
    }
}

- (void)webView:(WebView *)sender didReceiveIcon:(NSImage *)image forFrame:(WebFrame *)frame
{
	if (frame == [sender mainFrame]) {
		[iconImg setImage: image];
	}
}
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
	[statusBar setStringValue: @"Starting to load page..."];
	
	resourceCount = 0;
	resourceFailedCount = 0;
	resourceCompletedCount = 0;
	
	[progBar setIndeterminate: YES];
	[progBar startAnimation: self];
	
    if (frame == [sender mainFrame]) {
        NSString *url = [[[[frame provisionalDataSource] request] URL] absoluteString];
		
		if ([[url lastPathComponent] isEqualToString: @"parrot404.html"] == YES) {
			[urlBar setStringValue:@""];
		}
		else {		
			[urlBar setStringValue:url];
			currURL = url;
			url = [url lowercaseString];
	
			NSRange HTTP;
			HTTP.length = 5;
			HTTP.location = 0;
	
			NSString *httpResult = [url substringWithRange: HTTP];
	
			if ([httpResult isEqualToString: @"https"] == YES) {
				//[urlBar setBackgroundColor: [NSColor colorWithCalibratedRed:0.222 green:0.219 blue:0.202 alpha:1]];
				[urlBar setBackgroundColor: [NSColor yellowColor]];
			}
			else {
				[urlBar setBackgroundColor: [NSColor whiteColor]];
			}
		}
    }
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	[statusBar setStringValue: @"Done"];
	
	[progBar stopAnimation: self];
	
	MyDocument *d = [self document];	
	d->currURL = currURL;
	
    //if (frame == [sender mainFrame]){
		//[backButton setEnabled:[sender canGoBack]];
		//[forwardButton setEnabled:[sender canGoForward]];
    //}
}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	[statusBar setStringValue: @"Error on page"];
	[progBar stopAnimation: self];

	NSLog([error domain]);
	
	if ([[error domain] isEqualToString: @"NSURLErrorDomain"] == YES) {
		NSString *urlText = [[NSBundle mainBundle] pathForResource: @"parrot404" ofType: @"html"];
		NSString *urlHTML = [@"file://" stringByAppendingString: urlText];
	
		urlHTML = (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) urlHTML, (CFStringRef) @"%+#", NULL, CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));

		[self goToUrl:urlHTML];
	}
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	[statusBar setStringValue: @"Error on page"];
	[progBar stopAnimation: self];
	
	NSLog([error domain]);
}

- (void)webView:(WebView *)sender didChangeLocationWithinPageForFrame:(WebFrame *)frame
{

}

-(NSURLRequest *)webView:(WebView *)sender 
resource:(id)identifier
willSendRequest:(NSURLRequest *)request 
redirectResponse:(NSURLResponse *)redirectResponse 
fromDataSource:(WebDataSource *)dataSource
{
	[statusBar setStringValue: @"Sending page request..."];
	
    [self updateResourceStatus];
    return request;
}

-(void)webView:(WebView *)sender resource:(id)identifier didReceiveResponse:(NSURLResponse *)response fromDataSource:(WebDataSource *)dataSource
{
	[statusBar setStringValue: @"Response recieved..."];
	
	[self updateResourceStatus];
}

-(void)webView:(WebView *)sender resource:(id)identifier didReceiveContentLength:(unsigned)length fromDataSource:(WebDataSource *)dataSource
{
	[statusBar setStringValue: @"Loading page..."];
	
	[progBar setIndeterminate: NO];
	[progBar setMinValue: 0];
	[progBar setMaxValue: length];
	
	[self updateResourceStatus];
}

-(void)webView:(WebView *)sender 
resource:(id)identifier 
didFinishLoadingFromDataSource:(WebDataSource *)dataSource
{
    resourceCompletedCount = [progBar maxValue];
    // Update the status message
    [self updateResourceStatus];    
}

- (void)updateResourceStatus
{
	[progBar incrementBy: resourceCompletedCount];
}

#pragma mark -
#pragma mark Toolbar Functions

- (void)makeToolbarItems
{
	NSToolbarItem *toolbarItem;
	NSMenu *submenu;
	NSMenuItem *submenuItem;
	NSMenuItem *menuFormRep;
	
	toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Back"];

	[toolbarItem setLabel:@"Back"];
	[toolbarItem setPaletteLabel:@"Back"];
	[toolbarItem setToolTip:@"Navigate back"];
	[toolbarItem setImage:[NSImage imageNamed:@"back button"]];
	[toolbarItem setTarget:self];
	[toolbarItem setAction:@selector(goBack:)];
	
	[items setObject:toolbarItem forKey:@"Back"];
	
	[toolbarItem release];
	
	toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Forward"];

	[toolbarItem setLabel:@"Forward"];
	[toolbarItem setPaletteLabel:@"Forward"];
	[toolbarItem setToolTip:@"Navigate forward"];
	[toolbarItem setImage:[NSImage imageNamed:@"forward button"]];
	[toolbarItem setTarget:self];
	[toolbarItem setAction:@selector(goForward:)];
	
	[items setObject:toolbarItem forKey:@"Forward"];
	
	[toolbarItem release];
		
	toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Stop"];

	[toolbarItem setLabel:@"Stop"];
	[toolbarItem setPaletteLabel:@"Stop"];
	[toolbarItem setToolTip:@"Stops the current page from loading"];
	[toolbarItem setImage:[NSImage imageNamed:@"stop button"]];
	[toolbarItem setTarget:self];
	[toolbarItem setAction:@selector(stopPage:)];
	
	[items setObject:toolbarItem forKey:@"Stop"];
	
	[toolbarItem release];
		
	toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Reload"];

	[toolbarItem setLabel:@"Reload"];
	[toolbarItem setPaletteLabel:@"Reload"];
	[toolbarItem setToolTip:@"Reloads the currently open page"];
	[toolbarItem setImage:[NSImage imageNamed:@"reload button"]];
	[toolbarItem setTarget:self];
	[toolbarItem setAction:@selector(reloadPage:)];
	
	[items setObject:toolbarItem forKey:@"Reload"];
	
	[toolbarItem release];
	
	toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Go"];

	[toolbarItem setLabel:@"Go"];
	[toolbarItem setPaletteLabel:@"Go"];
	[toolbarItem setToolTip:@"Go to the address currently in the address bar"];
	[toolbarItem setImage:[NSImage imageNamed:@"go button"]];
	[toolbarItem setTarget:self];
	[toolbarItem setAction:@selector(goToUrlBar:)];
	
	[items setObject:toolbarItem forKey:@"Go"];
	
	[toolbarItem release];
	
	toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"URLBar"];
	
    [toolbarItem setLabel:@"Address"];
    [toolbarItem setPaletteLabel:@"Address bar"];
    [toolbarItem setToolTip:@"Type a web address here"];
    [toolbarItem setView:urlBar];
    [toolbarItem setMinSize:NSMakeSize(50,NSHeight([urlBar frame]))];
	[toolbarItem setMaxSize:NSMakeSize(NSWidth([[self window] frame])*2,NSHeight([urlBar frame]))];

	submenu = [[[NSMenu alloc] init] autorelease];

	submenuItem = [[[NSMenuItem alloc] initWithTitle: @"Address Bar" action:@selector(goToUrlBar:) keyEquivalent: @""] autorelease];
			
    menuFormRep = [[[NSMenuItem alloc] init] autorelease];
    [submenu addItem: submenuItem];
    [submenuItem setTarget:self];
    [menuFormRep setSubmenu:submenu];
    [menuFormRep setTitle:[toolbarItem label]];
    [toolbarItem setMenuFormRepresentation:menuFormRep];
	
	[items setObject:toolbarItem forKey:@"URLBar"];
	
	[toolbarItem release];
	
	toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"SearchBar"];
	
    [toolbarItem setLabel:@""];
    [toolbarItem setPaletteLabel:@"Search"];
    [toolbarItem setToolTip:@"Search the web"];
    [toolbarItem setView:searchBar];
    [toolbarItem setMinSize:NSMakeSize(150,NSHeight([searchBar frame]))];
	[toolbarItem setMaxSize:NSMakeSize(150,NSHeight([searchBar frame]))];

	submenu = [[[NSMenu alloc] init] autorelease];

    submenuItem = [[[NSMenuItem alloc] initWithTitle: @"Search Bar" action:@selector(goToSearchBar:) keyEquivalent: @""] autorelease];
			
    menuFormRep = [[[NSMenuItem alloc] init] autorelease];
    [submenu addItem: submenuItem];
    [submenuItem setTarget:self];
    [menuFormRep setSubmenu:submenu];
    [menuFormRep setTitle:[toolbarItem label]];
    [toolbarItem setMenuFormRepresentation:menuFormRep];
	
	[items setObject:toolbarItem forKey:@"SearchBar"];
	
	[toolbarItem release];
	
	[items setObject:NSToolbarPrintItemIdentifier forKey:NSToolbarPrintItemIdentifier];
	[items setObject:NSToolbarCustomizeToolbarItemIdentifier forKey:NSToolbarCustomizeToolbarItemIdentifier];
	[items setObject:NSToolbarFlexibleSpaceItemIdentifier forKey:NSToolbarFlexibleSpaceItemIdentifier];
	[items setObject:NSToolbarSpaceItemIdentifier forKey:NSToolbarSpaceItemIdentifier];
	[items setObject:NSToolbarSeparatorItemIdentifier forKey:NSToolbarSeparatorItemIdentifier];
}

- (NSToolbarItem *) toolbar:(NSToolbar *)toolbar
itemForItemIdentifier:(NSString *)itemIdentifier
willBeInsertedIntoToolbar:(BOOL)flag
{
	return [items objectForKey:itemIdentifier];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
	return [items allKeys];
}


- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *) toolbar
{
	return [[items allKeys] subarrayWithRange:NSMakeRange(0,2)];
}

- (void) toolbarWillAddItem: (NSNotification *) notification
{
    NSToolbarItem *addedItem = [[notification userInfo] objectForKey:@"item"];

    // set up the item here
}

- (IBAction)customizeToolbar:(id)sender
{
	 [toolbar runCustomizationPalette:sender]; 
}

- (float)ToolbarHeightForWindow
{
	float toolbarHeight = 0.0;

    NSRect windowFrame;

	if(toolbar && [toolbar isVisible]) {
		windowFrame = [NSWindow contentRectForFrameRect:[[self window] frame] styleMask:[[self window] styleMask]];
		toolbarHeight = NSHeight(windowFrame) - NSHeight([[[self window] contentView] frame]);
    }
    return toolbarHeight;
}

#pragma mark -
#pragma mark Navigation Functions

- (IBAction)goToUrlBar:(id)sender
{
	[self goToUrl: [urlBar stringValue]];
}

- (IBAction)goToSearchBar:(id)sender
{
	//[self goToUrl: [@"http://www.google.com/search?q=" stringByAppendingString: [searchBar stringValue]]];
	[self goToUrl: [@"http://www.google.com/search?sa=Search&client=pub-4009118454504378&forid=1&ie=ISO-8859-1&oe=ISO-8859-1&hl=en&q=" stringByAppendingString: [searchBar stringValue]]];
}

- (void)goToUrl:(NSString*)where
{
	if ([where isEqualToString: @""] == NO) {
		where = [where lowercaseString];
	
		NSRange HTTP;
		HTTP.length = 4;
		HTTP.location = 0;
	
		NSString *httpResult = [where substringWithRange: HTTP];
	
		if ([httpResult isEqualToString: @"http"] == NO && [httpResult isEqualToString: @"file"] == NO) {
			where = [@"http://" stringByAppendingString: where];
		}
	
		[[mainBrowser mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: where]]];
		
		[[mainBrowser window] makeKeyAndOrderFront: self];
	}
}

- (IBAction)goBack:(id)sender
{
	[mainBrowser goBack];
}

- (IBAction)goForward:(id)sender
{
	[mainBrowser goForward];
}

- (IBAction)stopPage:(id)sender
{
	[[mainBrowser mainFrame] stopLoading];
}

- (IBAction)reloadPage:(id)sender
{
	[[mainBrowser mainFrame] reload];
}

#pragma mark -
#pragma mark Misc Functions

- (void)setAnimationImg:(NSImageView*)animation
{
	animationImg = animation;
}

@end