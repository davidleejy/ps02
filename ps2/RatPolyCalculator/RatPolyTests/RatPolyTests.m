#import "RatPolyTests.h"

@implementation RatPolyTests


RatNum* num(int i) {
	return [[RatNum alloc] initWithInteger:i];
}

RatNum* num2(int i, int j) {
	return [[RatNum alloc] initWithNumer:i Denom:j];
}

RatTerm* term(int coeff, int expt) {
	return [[RatTerm alloc] initWithCoeff:num(coeff) Exp:expt];
}

RatTerm* term3(int numer, int denom, int expt) {
	return [[RatTerm alloc] initWithCoeff:num2(numer, denom) Exp:expt];
}

-(void)setUp{
    nanNum = [num(1) div:num(0)];
    nanTerm = [[RatTerm alloc] initWithCoeff:nanNum Exp:3];
}

-(void)tearDown{
}

RatPoly* zeroP() {
    return [[RatPoly alloc]init];
}



- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in RatPolyTests");
    
    zeroP();
    [[RatPoly alloc] initWithTerm:term3(3, 4, 997)];
    
    //[RatPoly doNotUseMe];
    
}

@end
