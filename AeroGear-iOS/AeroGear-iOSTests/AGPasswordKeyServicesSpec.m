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
#import "AGPasswordKeyServices.h"

static NSString *const MESSAGE = @"0123456789abcdef1234";

SPEC_BEGIN(AGPasswordKeyServicesSpec)

describe(@"AGPasswordKeyServices", ^{
    context(@"when newly created", ^{
        
        __block AGPasswordKeyServices *service = nil;
        
        beforeAll(^{
            AGKeyStoreCryptoConfig *config = [[AGKeyStoreCryptoConfig alloc] init];
            [config setAlias:@"alias"];
            [config setPassword:@"passphrase"];

            service = [[AGPasswordKeyServices alloc] initWithConfig:config];
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
        
        it(@"should fail to initialize with corrupted passphrase", ^{
            AGKeyStoreCryptoConfig *config = [[AGKeyStoreCryptoConfig alloc] init];
            [config setAlias:@"alias"];
            [config setPassword:@"failphrase"];
            
            service = [[AGPasswordKeyServices alloc] initWithConfig:config];
            [service shouldBeNil];
        });
    });
});

SPEC_END