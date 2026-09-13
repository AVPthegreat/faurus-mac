//
//  SEBDockItemBattery.m
//  Safe Exam Browser
//
//  Created by Daniel R. Schneider on 14.12.20.
//

#import "SEBDockItemBattery.h"

@import Foundation;
@import IOKit.ps;

@implementation SEBDockItemBattery

- (void) startDisplayingBattery
{
    CGFloat dockHeight = [[NSUserDefaults standardUserDefaults] secureDoubleForKey:@"org_safeexambrowser_SEB_taskBarHeight"];
    dockScale = dockHeight / SEBDefaultDockHeight;
    
    if (@available(macOS 10.14.0, *)) {
    } else {
        backgroundView.alphaValue = 0.5;
    }
    if (itemSize == 0) {
        itemSize = self.view.frame.size.width;
    }
    batteryIconWidthConstraint.constant = itemSize * dockScale;
    batteryIconHeightConstraint.constant = itemSize * dockScale;

    if (batteryLevelConstant == 0) {
        batteryLevelConstant = batteryLevelConstraint.constant;
    }
    batteryLevelTrailingConstant = batteryLevelConstant * dockScale;
    batteryLevelConstraint.constant = batteryLevelTrailingConstant;
    
    if (batteryLevelLeadingConstant == 0) {
        batteryLevelLeadingConstant = batteryLevelLeading.constant;
    }
    batteryLevelLeading.constant = batteryLevelLeadingConstant * dockScale;
    
    if (batteryLevelTopConstant == 0) {
        batteryLevelTopConstant = batteryLevelTop.constant;
    }
    batteryLevelTop.constant = batteryLevelTopConstant * dockScale;
    
    if (batteryLevelBottomConstant == 0) {
        batteryLevelBottomConstant = batteryLevelBottom.constant;
    }
    batteryLevelBottom.constant = batteryLevelBottomConstant * dockScale;
    
    batteryLevelWidth = batteryIconWidthConstraint.constant - batteryLevelLeading.constant - batteryLevelConstraint.constant;
    
    systemGreenCGColor = [[NSColor colorWithCalibratedRed:52.0/255.0 green:199.0/255.0 blue:89.0/255.0 alpha:1.0] CGColor];
    systemOrangeCGColor = [[NSColor colorWithCalibratedRed:255.0/255.0 green:149.0/255.0 blue:0.0/255.0 alpha:1.0] CGColor];
    systemRedCGColor = [[NSColor colorWithCalibratedRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1.0] CGColor];

    [backgroundView setWantsLayer:YES];
    backgroundView.layer.cornerRadius = 2.0;
    
    // Modern status capsule styling
    if (self.view) {
        [self.view setWantsLayer:YES];
        self.view.layer.cornerRadius = 6.0;
        self.view.layer.backgroundColor = [NSColor colorWithCalibratedWhite:1.0 alpha:0.07].CGColor;
        self.view.layer.borderColor = [NSColor colorWithCalibratedWhite:1.0 alpha:0.14].CGColor;
        self.view.layer.borderWidth = 1.0;
    }
    
    _batteryLevel = 100;
    [backgroundView.layer setBackgroundColor:systemGreenCGColor];
}


- (void) updateBatteryLevel:(double)batteryLevel infoString:(nonnull NSString *)infoString
{
    _batteryLevel = batteryLevel;
    CGFloat currentLevelConstraint = batteryLevelWidth - (batteryLevelWidth / 110 * (batteryLevel+10)) + batteryLevelTrailingConstant;
    batteryLevelConstraint.constant = currentLevelConstraint;
    [self setToolTip:infoString];
}


- (void) setPowerConnected:(BOOL)powerConnected warningLevel:(SEBLowBatteryWarningLevel)batteryWarningLevel
{
    if (powerConnected) {
        batteryIconButton.image = [NSImage imageNamed:@"SEBBatteryIcon_charging"];
    } else {
        batteryIconButton.image = [NSImage imageNamed:@"SEBBatteryIcon"];
    }
    [self setBatteryColorWarningLevel:batteryWarningLevel];
}


- (void) setBatteryColorWarningLevel:(SEBLowBatteryWarningLevel) batteryWarningLevel
{
    CGColorRef warningLevelColor;
    
    switch (batteryWarningLevel) {
        case kIOPSLowBatteryWarningEarly:
            warningLevelColor = systemOrangeCGColor;
            break;
            
        case kIOPSLowBatteryWarningFinal:
            warningLevelColor = systemRedCGColor;
            break;
            
        default:
            if (self.batteryLevel < 10.0) {
                warningLevelColor = systemOrangeCGColor;
            } else {
                warningLevelColor = systemGreenCGColor;
            }
            break;
    }
    [backgroundView.layer setBackgroundColor:warningLevelColor];
}


- (void) setToolTip:(NSString *)toolTip
{
    batteryIconButton.toolTip = toolTip;
}


@end
