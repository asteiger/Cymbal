#import "ApplicationHelper.h"


@implementation ApplicationHelper

+ (BOOL)applicationIsRunning:(NSString*)bundleIdentifer {
    NSArray *apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:bundleIdentifer];
    return [apps count] > 0;
}

@end
