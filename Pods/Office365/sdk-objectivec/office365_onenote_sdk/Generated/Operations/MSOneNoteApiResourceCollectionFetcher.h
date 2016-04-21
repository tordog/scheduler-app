/*******************************************************************************
Copyright (c) Microsoft Open Technologies, Inc. All Rights Reserved.
Licensed under the MIT or Apache License; see LICENSE in the source repository
root for authoritative license information.﻿

**NOTE** This code was generated by a tool and will occasionally be
overwritten. We welcome comments and issues regarding this code; they will be
addressed in the generation tool. If you wish to submit pull requests, please
do so for the templates in that tool.

This code was generated by Vipr (https://github.com/microsoft/vipr) using
the T4TemplateWriter (https://github.com/msopentech/vipr-t4templatewriter).
******************************************************************************/

@class MSOneNoteApiResourceFetcher;

#import <office365_odata_base/office365_odata_base.h>
#import "MSOneNoteApiModels.h"

/**
* The header for type MSOneNoteApiResourceCollectionFetcher.
*/

@protocol MSOneNoteApiResourceCollectionFetcher<MSODataCollectionFetcher>

@optional

- (NSURLSessionTask *)readWithCallback:(void (^)(NSArray<MSOneNoteApiResource> *resources, MSODataException *exception))callback;

- (id<MSOneNoteApiResourceCollectionFetcher>)select:(NSString *)params;
- (id<MSOneNoteApiResourceCollectionFetcher>)filter:(NSString *)params;
- (id<MSOneNoteApiResourceCollectionFetcher>)top:(int)value;
- (id<MSOneNoteApiResourceCollectionFetcher>)skip:(int)value;
- (id<MSOneNoteApiResourceCollectionFetcher>)expand:(NSString *)value;
- (id<MSOneNoteApiResourceCollectionFetcher>)orderBy:(NSString *)params;
- (id<MSOneNoteApiResourceCollectionFetcher>)addCustomParametersWithName:(NSString *)name value:(id)value;
- (id<MSOneNoteApiResourceCollectionFetcher>)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;

@required

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSODataExecutable>)parent;
- (MSOneNoteApiResourceFetcher *)getById:(NSString *)Id;
- (NSURLSessionTask *)addResource:(MSOneNoteApiResource *)entity callback:(void (^)(MSOneNoteApiResource *resource, MSODataException *e))callback;

@end

@interface MSOneNoteApiResourceCollectionFetcher : MSODataCollectionFetcher<MSOneNoteApiResourceCollectionFetcher>

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSODataExecutable>)parent;

@end