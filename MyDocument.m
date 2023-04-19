//
//  MyDocument.m
//  Parrot
//
//  Created by Alex Seifert on 05/10/31.
//  Copyright 2005 Alex Seifert. All rights reserved.
//

#import "MyDocument.h"
#import "MyDocumentWindow.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
	//NSLog(@"it worked!");
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

/*- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}*/

-(void) makeWindowControllers
{
	MyDocumentWindow *bW = [[MyDocumentWindow alloc]initWithWindowNibName: @"MyDocument"];
	[self addWindowController: bW];
}

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
    // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    return nil;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
    // Insert code here to read your document from the given data.  You can also choose to override -loadFileWrapperRepresentation:ofType: or -readFromFile:ofType: instead.
    return YES;
}

- (BOOL)readFromURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName error:(NSError **)outError {
    BOOL readSuccess = NO;

    NSAttributedString *fileContents = [[NSAttributedString alloc] initWithURL:inAbsoluteURL options:nil documentAttributes:NULL error:outError];
    if (fileContents) {
        readSuccess = YES;
       	
		openURL = inAbsoluteURL;
		
        [fileContents release];
    }
    return readSuccess;
}

/*- (IBAction)saveDocumentAs:(id)sender
{
	NSArray *fileTypes = [NSArray arrayWithObjects: @"html", @"htm"];
	NSSavePanel *savePanel;
	
	[savePanel setCanSelectHiddenExtension: true];
	[savePanel setExtensionHidden: false];
	[savePanel setAllowedFileTypes: fileTypes];
	[savePanel setCanCreateDirectories: true];
	[savePanel beginSheetForDirectory];
	[savePanel runModal];
}*/

- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)outError
{
	//NSFileManager *ns;
	//sNSURL *nurl = [nurl initFileURLWithPath: currURL];
	NSData *data = [data initWithContentsOfURL:absoluteOriginalContentsURL options:NSUncachedRead error:(NSError **)outError];// = [ns contentsAtPath: currURL];

	BOOL writeSuccess = [data writeToURL:absoluteURL options:NSUncachedRead error:outError];//NSAtomicWrite
   
	return writeSuccess;
}

-(void)makeWindows
{
	[self makeWindowControllers];
	[self showWindows];
}

@end
