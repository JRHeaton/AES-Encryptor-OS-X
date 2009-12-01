//
//  AES_EncryptorAppDelegate.h
//  AES Encryptor
//
//  Created by John Heaton on 11/30/09.
//  Copyright 2009 GJB Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AES128EncryptionOperation.h"

@interface AES_EncryptorAppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate, AES128EncryptionOperationDelegate> {
    NSWindow *window;
	IBOutlet NSTextField *keyField, *fileField;
	IBOutlet NSButton *cryptoButton, *browseButton;
	IBOutlet NSComboBox *cryptoOperationBox;
}

- (void)centerWindow:(NSWindow *)w;
- (void)browseForFile:(id)sender;
- (void)attemptCryptoOperation:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@end
