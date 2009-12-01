//
//  AES128EncryptionOperation.h
//  AES Encryptor
//
//  Created by John Heaton on 11/30/09.
//  Copyright 2009 GJB Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum crypto_operation_type {
	kCryptoOperationTypeEncrypt = 0,
	kCryptoOperationTypeDecrypt = 1
};

@protocol AES128EncryptionOperationDelegate;

@interface AES128EncryptionOperation : NSOperation {
@private
	id<AES128EncryptionOperationDelegate> delegate;
	id target;
	NSData *inData;
	NSString *key;
	int optype;
}

- (id)initWithTarget:(id)t delegate:(id<AES128EncryptionOperationDelegate>)de inputData:(NSData *)da key:(NSString *)k operationType:(int)type;

@end

@protocol AES128EncryptionOperationDelegate<NSObject> 

@required
- (void)cryptoOperation:(AES128EncryptionOperation *)operation didFinishWithData:(NSData *)encryptedData;

@end
