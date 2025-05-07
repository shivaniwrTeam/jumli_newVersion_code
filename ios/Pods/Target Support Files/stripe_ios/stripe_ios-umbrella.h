#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "stripe_objc-umbrella.h"
#import "RCTBridge.h"

FOUNDATION_EXPORT double stripe_iosVersionNumber;
FOUNDATION_EXPORT const unsigned char stripe_iosVersionString[];

