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

#import <Foundation/Foundation.h>
#import "MSOneNoteApiProtocols.h"
#import "MSOneNoteApiPatchActionType.h"
#import "MSOneNoteApiPatchInsertPosition.h"


/**
* The header for type PatchContentCommand.
*/

@interface MSOneNoteApiPatchContentCommand : NSObject

@property (retain, nonatomic, readonly) NSString *odataType;
@property  (nonatomic, getter=action, setter=setAction:) MSOneNoteApiPatchActionType action;
- (void)setactionString:(NSString *)value;
@property (retain, nonatomic, readwrite, getter=target, setter=setTarget:) NSString *target;
@property (retain, nonatomic, readwrite, getter=content, setter=setContent:) NSString *content;
@property  (nonatomic, getter=position, setter=setPosition:) MSOneNoteApiPatchInsertPosition position;
- (void)setpositionString:(NSString *)value;

@end