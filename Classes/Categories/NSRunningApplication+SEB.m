//
//  NSRunningApplication+SEB
//  SafeExamBrowser
//
//  Created by Daniel R. Schneider on 15.10.16.
//  Copyright (c) 2010-2026 Daniel R. Schneider, ETH Zurich, IT Services,
//  based on the original idea of Safe Exam Browser
//  by Stefan Schneider, University of Giessen
//  Project concept: Thomas Piendl, Daniel R. Schneider,
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

#import "NSRunningApplication+SEB.h"


@implementation NSRunningApplication (SEB)


+ (BOOL)killApplicationWithBundleIdentifier:(NSString *)bundleID
{
    DDLogWarn(@"Suppressed killApplicationWithBundleIdentifier:%@ for Faurus Exam Browser.", bundleID);
    return YES;
}


- (BOOL)kill
{
    DDLogVerbose(@"Suppressed -[NSRunningApplication kill] for %@ for Faurus Exam Browser.", self);
    return YES;
}


- (BOOL)filterKillErrors:(NSError*)error
{
    NSInteger killSuccess = [[error.userInfo objectForKey:SEBErrorKillProcessSuccessKey] intValue];
    long errorNumber = [[error.userInfo objectForKey:SEBErrorKillProcessErrnoKey] longValue];
    if (killSuccess == -1 && errorNumber == 1 && [self.bundleIdentifier isEqualToString:WebKitNetworkingProcessBundleID] ) {
        // WebKit networking process couldn't be killed because it's running with elevated user rights, ignore it
        return YES;
    }
    return NO;
}


+ (BOOL)killProcessWithPID:(pid_t)processPID error:(NSError* _Nullable *)error
{
    DDLogWarn(@"Suppressed killProcessWithPID:%d for Faurus Exam Browser.", (int)processPID);
    return YES;
}

@end
