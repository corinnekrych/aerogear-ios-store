/*
 * JBoss, Home of Professional Open Source.
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Kiwi/Kiwi.h>
#import "AGPassphraseEncryptionServices.h"

SPEC_BEGIN(AGPassphraseEncryptionServicesSpec)

describe(@"AGPassphraseEncryptionServices", ^{
    context(@"when newly created", ^{

        NSData * const kSalt = [@"e5ecbaaf33bd751a1ac728d45e6" dataUsingEncoding:NSUTF8StringEncoding];
        NSData * const kSaltFail = [@"bweywsaf3bbdf5121nc72he412ex" dataUsingEncoding:NSUTF8StringEncoding];
        NSString * const kPassphrase = @"PASSPHRASE";
        NSString * const kPassphraseFail = @"FAIL_PASSPHRASE";

        NSString * const MESSAGE = @"BE075FCDE048977EB48F59FFD4924CA1C60902E52F0A089BC76897040E082F937763848645E0705";

        __block AGPassphraseEncryptionServices *service = nil;
        
        beforeAll(^{
            AGPassphraseCryptoConfig *config = [[AGPassphraseCryptoConfig alloc] init];
            [config setSalt:kSalt];
            [config setPassphrase:kPassphrase];

            service = [[AGPassphraseEncryptionServices alloc] initWithConfig:config];
        });
        
        it(@"should not be nil", ^{
            [service shouldNotBeNil];
        });
        
        it(@"should correctly encrypt/decrypt block of data", ^{
            NSData *dataToEncrypt = [MESSAGE dataUsingEncoding:NSUTF8StringEncoding];
            
            NSData *encryptedData = [service encrypt:dataToEncrypt];
            [encryptedData shouldNotBeNil];
            
            NSData* decryptedData = [service decrypt:encryptedData];
            [decryptedData shouldNotBeNil];
            
            // should match
            [[dataToEncrypt should] equal:decryptedData];
        });
        
        it(@"should fail to decrypt with corrupted salt", ^{
            NSData *dataToEncrypt = [MESSAGE dataUsingEncoding:NSUTF8StringEncoding];
            
            NSData *encryptedData = [service encrypt:dataToEncrypt];
            [encryptedData shouldNotBeNil];
            
            AGPassphraseCryptoConfig *config = [[AGPassphraseCryptoConfig alloc] init];
            [config setSalt:kSaltFail];
            [config setPassphrase:kPassphrase];

            service = [[AGPassphraseEncryptionServices alloc] initWithConfig:config];
            
            NSData* decryptedData = [service decrypt:encryptedData];
            [decryptedData shouldBeNil];
        });

        it(@"should fail to decrypt with corrupted passphrase", ^{
            NSData *dataToEncrypt = [MESSAGE dataUsingEncoding:NSUTF8StringEncoding];
            
            NSData *encryptedData = [service encrypt:dataToEncrypt];
            [encryptedData shouldNotBeNil];
            
            AGPassphraseCryptoConfig *config = [[AGPassphraseCryptoConfig alloc] init];
            [config setSalt:kSalt];
            [config setPassphrase:kPassphraseFail];
            
            service = [[AGPassphraseEncryptionServices alloc] initWithConfig:config];
            
            NSData* decryptedData = [service decrypt:encryptedData];
            [decryptedData shouldBeNil];
        });
        it(@"should fail to decrypt with corrupted salt and passphrase", ^{
            NSData *dataToEncrypt = [MESSAGE dataUsingEncoding:NSUTF8StringEncoding];
            
            NSData *encryptedData = [service encrypt:dataToEncrypt];
            [encryptedData shouldNotBeNil];
            
            AGPassphraseCryptoConfig *config = [[AGPassphraseCryptoConfig alloc] init];
            [config setSalt:kSaltFail];
            [config setPassphrase:kPassphraseFail];
            
            service = [[AGPassphraseEncryptionServices alloc] initWithConfig:config];
            
            NSData* decryptedData = [service decrypt:encryptedData];
            [decryptedData shouldBeNil];
        });
    });
});

SPEC_END