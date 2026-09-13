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

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        if (@available(macOS 10.14, *)) {
            self.material = NSVisualEffectMaterialHUDWindow;
        } else {
            self.material = NSVisualEffectMaterialDark;
        }
        self.blendingMode = NSVisualEffectBlendingModeBehindWindow;
        self.state = NSVisualEffectStateActive;
        self.wantsLayer = YES;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Modern sleek dark acrylic tint (#0d0b0f at 82% opacity over frosted glass)
    [[NSColor colorWithCalibratedRed:13.0/255.0 green:11.0/255.0 blue:15.0/255.0 alpha:0.82] setFill];
    NSRectFillUsingOperation(dirtyRect, NSCompositingOperationSourceOver);
    
    // Top specular highlight line (subtle flame accent fading to clean Apple white hairline)
    NSGradient *topBorderGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:255.0/255.0 green:122.0/255.0 blue:61.0/255.0 alpha:0.45]
                                                                  endingColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.12]];
    NSRect topBorderRect = NSMakeRect(dirtyRect.origin.x, self.bounds.size.height - 1.0, dirtyRect.size.width, 1.0);
    [topBorderGradient drawInRect:topBorderRect angle:0];
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
