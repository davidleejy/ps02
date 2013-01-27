
#import <SenTestingKit/SenTestingKit.h>

#import "RatPoly.h"


@interface RatPolyTests : SenTestCase {
    RatNum *nanNum;
    RatNum *zeroNum;
    
    RatTerm *nanTerm;
    RatTerm *zeroTerm;
    
    RatPoly *nanPoly;
    RatPoly *zeroPoly;
}

@end
