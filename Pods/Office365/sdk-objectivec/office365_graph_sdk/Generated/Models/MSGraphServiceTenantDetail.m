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

#import "MSGraphServiceModels.h"

/**
* The implementation file for type MSGraphServiceTenantDetail.
*/

@implementation MSGraphServiceTenantDetail	

@synthesize odataType = _odataType;
@synthesize assignedPlans = _assignedPlans;
@synthesize city = _city;
@synthesize companyLastDirSyncTime = _companyLastDirSyncTime;
@synthesize country = _country;
@synthesize countryLetterCode = _countryLetterCode;
@synthesize dirSyncEnabled = _dirSyncEnabled;
@synthesize displayName = _displayName;
@synthesize marketingNotificationEmails = _marketingNotificationEmails;
@synthesize postalCode = _postalCode;
@synthesize preferredLanguage = _preferredLanguage;
@synthesize provisionedPlans = _provisionedPlans;
@synthesize provisioningErrors = _provisioningErrors;
@synthesize securityComplianceNotificationMails = _securityComplianceNotificationMails;
@synthesize securityComplianceNotificationPhones = _securityComplianceNotificationPhones;
@synthesize state = _state;
@synthesize street = _street;
@synthesize technicalNotificationMails = _technicalNotificationMails;
@synthesize telephoneNumber = _telephoneNumber;
@synthesize verifiedDomains = _verifiedDomains;

- (instancetype)init {

	if (self = [super init]) {

		_odataType = @"#Microsoft.Graph.TenantDetail";
    }

	return self;
}

@end