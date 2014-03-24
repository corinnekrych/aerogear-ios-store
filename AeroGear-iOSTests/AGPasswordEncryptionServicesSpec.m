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
#import "AGPasswordEncryptionServices.h"

static NSString *const MESSAGE = @"0123456789abcdef1234";

SPEC_BEGIN(AGPasswordEncryptionServicesSpec)

describe(@"AGPasswordEncryptionServices", ^{
    context(@"when newly created", ^{

        NSString * const MESSAGE = @"BE075FCDE048977EB48F59FFD4924CA1C60902E52F0A089BC76897040E082F937763848645E0705";

        __block AGPasswordEncryptionServices *service = nil;

        beforeAll(^{
            AGKeyStoreCryptoConfig *config = [[AGKeyStoreCryptoConfig alloc] init];
            [config setAlias:@"alias"];
            [config setPassword:@"passphrase"];

            service = [[AGPasswordEncryptionServices alloc] initWithConfig:config];
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
        
        it(@"should fail to initialize with corrupted password", ^{
            AGKeyStoreCryptoConfig *config = [[AGKeyStoreCryptoConfig alloc] init];
            [config setAlias:@"alias"];
            [config setPassword:@"failphrase"];

            service = [[AGPasswordEncryptionServices alloc] initWithConfig:config];
            [service shouldBeNil];
        });
    });
});

SPEC_END