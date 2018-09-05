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

#import "ed25519-public.h"

FOUNDATION_EXPORT double libEd25519Blake2bVersionNumber;
FOUNDATION_EXPORT const unsigned char libEd25519Blake2bVersionString[];

