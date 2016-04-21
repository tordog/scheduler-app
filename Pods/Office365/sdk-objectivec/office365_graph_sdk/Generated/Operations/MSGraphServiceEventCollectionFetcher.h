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

@class MSGraphServiceEventFetcher;

#import <office365_odata_base/office365_odata_base.h>
#import "MSGraphServiceModels.h"

/**
* The header for type MSGraphServiceEventCollectionFetcher.
*/

@protocol MSGraphServiceEventCollectionFetcher<MSODataCollectionFetcher>

@optional

- (NSURLSessionTask *)readWithCallback:(void (^)(NSArray<MSGraphServiceEvent> *events, MSODataException *exception))callback;

- (id<MSGraphServiceEventCollectionFetcher>)select:(NSString *)params;
- (id<MSGraphServiceEventCollectionFetcher>)filter:(NSString *)params;
- (id<MSGraphServiceEventCollectionFetcher>)top:(int)value;
- (id<MSGraphServiceEventCollectionFetcher>)skip:(int)value;
- (id<MSGraphServiceEventCollectionFetcher>)expand:(NSString *)value;
- (id<MSGraphServiceEventCollectionFetcher>)orderBy:(NSString *)params;
- (id<MSGraphServiceEventCollectionFetcher>)addCustomParametersWithName:(NSString *)name value:(id)value;
- (id<MSGraphServiceEventCollectionFetcher>)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;

@required

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSODataExecutable>)parent;
- (MSGraphServiceEventFetcher *)getById:(NSString *)Id;
- (NSURLSessionTask *)addEvent:(MSGraphServiceEvent *)entity callback:(void (^)(MSGraphServiceEvent *event, MSODataException *e))callback;

@end

@interface MSGraphServiceEventCollectionFetcher : MSODataCollectionFetcher<MSGraphServiceEventCollectionFetcher>

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSODataExecutable>)parent;

@end