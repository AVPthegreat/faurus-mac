//
//  SEBConstants.h
//  SafeExamBrowser
//
//  Created by Daniel Schneider on 29.12.11.
//  Copyright (c) 2010-2026 Daniel R. Schneider, ETH Zurich, IT Services,
//  based on the original idea of Safe Exam Browser 
//  by Stefan Schneider, University of Giessen
//  Project concept: Thomas Piendl, Daniel R. Schneider, Damian Buechel, 
//  Dirk Bauer, Kai Reuter, Tobias Halbherr, Karsten Burger, Marco Lehre, 
//  Brigitte Schmucki, Oliver Rahs. French localization: Nicolas Dunand
//
//  ``The contents of this file are subject to the Mozilla Public License
//  Version 2.0 (the "License"); you may not use this file except in
//  compliance with the License. You may obtain a copy of the License at
//  http://www.mozilla.org/MPL/
//  
//  Software distributed under the License is distributed on an "AS IS"
//  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
//  License for the specific language governing rights and limitations
//  under the License.
//  
//  The Original Code is Safe Exam Browser for Mac OS X.
//  
//  The Initial Developer of the Original Code is Daniel R. Schneider.
//  Portions created by Daniel R. Schneider are Copyright 
//  (c) 2010-2026 Daniel R. Schneider, ETH Zurich, IT Services,
//  based on the original idea of Safe Exam Browser
//  by Stefan Schneider, University of Giessen. All Rights Reserved.
//  
//  Contributor(s): ______________________________________.
//

#import <Foundation/Foundation.h>

// RGB values in the Display P3 color space (Faurus Flame: #ff7a3d)
#define SEBTintColorRedValue 1.000
#define SEBTintColorGreenValue 0.478
#define SEBTintColorBlueValue 0.239

static NSString __unused *sebUserDefaultsPrefix = @"org_safeexambrowser_SEB_";
#define SEBUserDefaultsPrefixLength 24
static NSString __unused *sebPrivateUserDefaultsPrefix = @"org_safeexambrowser_";

static NSString __unused *sebErrorDomain = @"app.faurus.browser";

static NSString __unused *SEBStartPage = @"https://faurus.app/";
static NSString __unused *SEBHelpPage = @"https://faurus.app/";
// Localized download page:
static NSString __unused *SEBDownloadPageFormat = @"https://faurus.app/";
// App Store page
static NSString __unused *SEBiOSAppStorePage = @"https://faurus.app/";
static NSString __unused *SEBSupportEmail = @"ceo@faurus.app";
static NSString __unused *SEBWebsiteShort = @"faurus.app";

static NSString __unused *SEBOrganization = @"Faurus";
static NSString __unused *SEBCountry = @"US";

static NSString __unused *SEBFullAppNameClassic = @"Faurus Exam Browser";
static NSString __unused *SEBFullAppName = @"Faurus";
static NSString __unused *SEBShortAppName = @"Faurus";
static NSString __unused *SEBExtraShortAppName = @"Faurus";
static NSString __unused *SEBFileExtension = @"faurus";
static NSString __unused *SEBConfigMIMEType = @"application/x-faurus";
static NSString __unused *SEBUnencryptedConfigMIMEType = @"application/xml";
static NSString __unused *SEBProtocolScheme = @"faurus";
static NSString __unused *SEBSSecureProtocolScheme = @"fauruss";
static NSString __unused *SEBClientSettingsACCSubdomainShort = @"faurus";
static NSString __unused *SEBClientSettingsACCSubdomainLong = @"faurus";
static NSString __unused *SEBClientSettingsACCPath = @"faurus";
static NSString __unused *SEBClientSettingsFilename = @"FaurusClientSettings.faurus";
static NSString __unused *SEBClientSettingsDirectory = @"Preferences";
static NSString __unused *SEBSettingsFilename = @"FaurusSettings.faurus";
static NSString __unused *SEBExamSettingsFilename = @"FaurusExamSettings.faurus";
static NSString __unused *SEBUserAgentDefaultSuffix = @"Faurus";
