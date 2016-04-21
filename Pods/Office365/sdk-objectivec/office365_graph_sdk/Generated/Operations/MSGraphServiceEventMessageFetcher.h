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
@class MSGraphServiceEventMessageOperations;

#import <office365_odata_base/office365_odata_base.h>
#import "MSGraphServiceModels.h"

/**
* The header for type MSGraphServiceEventMessageFetcher.
*/

@protocol MSGraphServiceEventMessageFetcher<MSODataEntityFetcher>

@optional

- (NSURLSessionTask *) readWithCallback:(void (^)(MSGraphServiceEventMessage *eventMessage, MSODataException *exception))callback;
- (id<MSGraphServiceEventMessageFetcher>)addCustomParametersWithName:(NSString *)name value:(id)value;
- (id<MSGraphServiceEventMessageFetcher>)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;
- (id<MSGraphServiceEventMessageFetcher>)select:(NSString *)params;
- (id<MSGraphServiceEventMessageFetcher>)expand:(NSString *)value;

@required

@property (copy, nonatomic, readonly) MSGraphServiceEventMessageOperations *operations;

- (MSGraphServiceEventFetcher *)getEvent;

@end

@interface MSGraphServiceEventMessageFetcher : MSODataEntityFetcher<MSGraphServiceEventMessageFetcher>

- (instancetype)initWithUrl:(NSString*)urlComponent parent:(id<MSODataExecutable>)parent;
- (NSURLSessionTask *) updateEventMessage:(MSGraphServiceEventMessage *)eventMessage callback:(void (^)(MSGraphServiceEventMessage *eventMessage, MSODataException *error))callback;
- (NSURLSessionTask *) deleteEventMessage:(void (^)(int status, MSODataException *exception))callback;

@end