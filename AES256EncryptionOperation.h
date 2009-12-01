//
//  AES256EncryptionOperation.h
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

@protocol AES256EncryptionOperationDelegate;

@interface AES256EncryptionOperation : NSOperation {
@private
	id<AES256EncryptionOperationDelegate> delegate;
	id target;
	NSData *inData;
	NSString *key;
	int optype;
}

- (id)initWithTarget:(id)t delegate:(id<AES256EncryptionOperationDelegate>)de inputData:(NSData *)da key:(NSString *)k operationType:(int)type;

@end

@protocol AES256EncryptionOperationDelegate<NSObject> 

@required
- (void)cryptoOperation:(AES256EncryptionOperation *)operation didFinishWithData:(NSData *)encryptedData;

@end
