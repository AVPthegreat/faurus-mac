//
//  SEBDockView.m
//  SafeExamBrowser
//
//  Created by Daniel R. Schneider on 24/09/14.
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

#import "SEBDockView.h"

@implementation SEBDockView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Faurus dark flame dock styling (#0a0705 with subtle flame top accent)
    [[NSColor colorWithCalibratedRed:10.0/255.0 green:7.0/255.0 blue:5.0/255.0 alpha:0.96] setFill];
    NSRectFill(dirtyRect);
    
    [[NSColor colorWithCalibratedRed:255.0/255.0 green:122.0/255.0 blue:61.0/255.0 alpha:0.35] setStroke];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(dirtyRect.origin.x, dirtyRect.size.height - 1) toPoint:NSMakePoint(dirtyRect.origin.x + dirtyRect.size.width, dirtyRect.size.height - 1)];
}


- (BOOL)shouldDelayWindowOrderingForEvent:(NSEvent *)theEvent {
    return YES;
}


- (void)mouseDown:(NSEvent *)theEvent
{
    [NSApp preventWindowOrdering];  //prevent that the cap window is ordered front when clicked in
    return;
}

@end
