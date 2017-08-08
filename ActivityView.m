#import "ActivityView.h"
#import <React/RCTLog.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/RCTImageLoader.h>

@implementation ActivityView

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(showWithOptions:(NSDictionary *)args)
{
    NSMutableArray *shareObject = [NSMutableArray array];
    NSString *text = args[@"text"];
    NSURL *url = args[@"url"];

    // Return if no args were passed
    if (!text && !url) {
        RCTLogError(@"[ActivityView] You must specify a text, url.");
        return;
    }

    if (text) {
        [shareObject addObject:text];
    }

    if (url) {
        [shareObject addObject:url];
    }

    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:shareObject applicationActivities:nil];

    activityView.excludedActivityTypes = nil;

    // Display the Activity View
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];

    /*
     * The `anchor` option takes a view to set as the anchor for the share
     * popup to point to, on iPads running iOS 8. If it is not passed, it
     * defaults to centering the share popup on screen without any arrows.
     * refer: (https://github.com/facebook/react-native/commit/f35fbc2a145f0097142d08920e141ea0cce2c31c)
     */
    // if ([activityView respondsToSelector:@selector(popoverPresentationController)]) {
        activityView.popoverPresentationController.sourceView = ctrl.view;
        NSNumber *anchorViewTag = [RCTConvert NSNumber:args[@"anchor"]];
        if (anchorViewTag) {
            UIView *anchorView = [self.bridge.uiManager viewForReactTag:anchorViewTag];
            activityView.popoverPresentationController.sourceRect = [anchorView convertRect:anchorView.bounds toView:ctrl.view];
        } else {
            CGRect sourceRect = CGRectMake(ctrl.view.center.x, ctrl.view.center.y, 1, 1);
            activityView.popoverPresentationController.sourceRect = sourceRect;
            activityView.popoverPresentationController.permittedArrowDirections = 0;
        }
    // }
    [ctrl presentViewController:activityView animated:YES completion:nil];
}

@end
