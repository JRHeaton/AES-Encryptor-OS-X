//
//  AES_EncryptorAppDelegate.m
//  AES Encryptor
//
//  Created by John Heaton on 11/30/09.
//  Copyright 2009 GJB Software. All rights reserved.
//

#import "AES_EncryptorAppDelegate.h"

@implementation AES_EncryptorAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self centerWindow:self.window];
	
	[keyField setDelegate:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSControlTextDidChangeNotification object:keyField];
	
	[browseButton setAction:@selector(browseForFile:)];
	[cryptoButton setAction:@selector(attemptCryptoOperation:)];
}

- (void)centerWindow:(NSWindow *)w {
	NSRect screenRect = [[NSScreen mainScreen] visibleFrame];
	NSRect windowRect = [window frame];
	
	[window setFrame:NSMakeRect((screenRect.size.width / 2) - (windowRect.size.width / 2), (screenRect.size.height / 2) - (windowRect.size.height / 4), windowRect.size.width, windowRect.size.height) display:NO];
	
	[self.window makeKeyAndOrderFront:self];
}

- (void)filePicked:(NSString *)file withResult:(NSInteger)result {
	if(result != NSFileHandlingPanelOKButton) return;
	
	[fileField setStringValue:file];
}

- (void)browseForFile:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel beginSheetModalForWindow:self.window completionHandler:
	 ^(NSInteger result){ 
		 [self filePicked:[openPanel filename] withResult:result];
	 }
	 ];
}

- (void)askToSaveNewData:(NSData *)data toFile:(NSString *)file result:(NSInteger)result {
	if(result != NSFileHandlingPanelOKButton) return;
	
	BOOL written = [data writeToFile:file atomically:YES];
	if(!written)
		NSBeginAlertSheet(@"Error", @"OK", nil, nil, self.window, nil, nil, nil, NULL, @"There was a problem writing the new data to the selected file.");
	
	[data release];
}

- (void)cryptoOperation:(AES128EncryptionOperation *)operation didFinishWithData:(NSData *)encryptedData {
	[operation release];
	
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	[savePanel beginSheetModalForWindow:self.window completionHandler:
	 ^(NSInteger result) {
		 [self askToSaveNewData:encryptedData toFile:[savePanel filename] result:result];
	 }];
}

- (void)performCryptoOperation {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int type;
	if([cryptoOperationBox indexOfSelectedItem] == 0)
		type = kCryptoOperationTypeEncrypt;
	else
		type = kCryptoOperationTypeDecrypt;
	
	AES128EncryptionOperation *crypto = [[AES128EncryptionOperation alloc] initWithTarget:self delegate:self inputData:[NSData dataWithContentsOfFile:[fileField stringValue]] key:[keyField stringValue] operationType:type];
	
	[crypto start];
										  
	[pool release];
}

- (void)attemptCryptoOperation:(id)sender {
	if([keyField stringValue] == nil || [[keyField stringValue] length] < 1 ||
	   [fileField stringValue] == nil || [[fileField stringValue] length] < 1 ||
	   ![[NSFileManager defaultManager] fileExistsAtPath:[fileField stringValue]] ||
	   ![cryptoOperationBox objectValueOfSelectedItem]) {
		NSBeginAlertSheet(@"Error", nil, nil, nil, self.window, nil, nil, nil, NULL, @"Please make sure that:\n\n1. The file you wish to encrypt/decrypt exists.\n2. Both of the fields are completed\n3. You have chosen a crypto method");
	}
	
	[NSThread detachNewThreadSelector:@selector(performCryptoOperation) toTarget:self withObject:nil];
}

- (void)textDidChange:(NSNotification *)notification {
	if([[[notification object] stringValue] length] > 16) {
		NSMutableString *mutableString = (NSMutableString *)[[notification object] stringValue];
		[[notification object] setStringValue:[mutableString substringToIndex:[mutableString length] - 1]];
		NSBeginAlertSheet(@"Error", @"OK", nil, nil, self.window, nil, nil, nil, NULL, @"Your key can't be more than 16 characters!");
	}
}

- (void)dealloc {
	[super dealloc];
}

@end
