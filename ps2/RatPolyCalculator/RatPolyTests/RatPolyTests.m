#import "RatPolyTests.h"

@implementation RatPolyTests

// *** Helper Functions *** 

RatNum* num1(int i)
{
	return [[RatNum alloc] initWithInteger:i];
}

RatNum* num2(int i, int j)
{
	return [[RatNum alloc] initWithNumer:i Denom:j];
}

RatTerm* term1(int coeff, int expt)
{
	return [[RatTerm alloc] initWithCoeff:num1(coeff) Exp:expt];
}

RatTerm* term2(int numer, int denom, int expt)
{
	return [[RatTerm alloc] initWithCoeff:num2(numer, denom) Exp:expt];
}

RatPoly* poly1(RatTerm *term)
{
	return [[RatPoly alloc] initWithTerm:term];
}

RatPoly* poly2(RatTerm* term1, RatTerm* term2) {
    NSArray * rTarr = [[NSArray alloc] initWithObjects:term1,term2, nil];
    return [[RatPoly alloc] initWithTerms:rTarr];
}

RatPoly* poly3(RatTerm* term1, RatTerm* term2, RatTerm* term3) {
    NSArray * rTarr = [[NSArray alloc] initWithObjects:term1,term2,term3, nil];
    return [[RatPoly alloc] initWithTerms:rTarr];
}

RatPoly* poly4(RatTerm* term1, RatTerm* term2, RatTerm* term3, RatTerm* term4) {
    NSArray * rTarr = [[NSArray alloc] initWithObjects:term1,term2,term3,term4, nil];
    return [[RatPoly alloc] initWithTerms:rTarr];
}

RatPoly* polyS(NSString* str) {
    return [RatPoly valueOf:str];
}

bool isTwoPolyEqual(RatPoly* a,RatPoly* b)
{
    if([a terms].count != [b terms].count)
    {
        return NO;
    }
    
    for(int i=0; i<[a terms].count; i++)
    {
        if(![(RatTerm*)[[a terms]objectAtIndex:i] isEqual:(RatTerm*)[[b terms]objectAtIndex:i]])
        {
            return NO;
        }
    }
    if(a.degree == b.degree)
    {
        return YES;
    }
    
    return NO;
}

// *** Set up and Tear Down *** 

-(void)setUp{
    nanNum = [RatNum initNaN];
    nanTerm = [[RatTerm alloc] initWithCoeff:nanNum Exp:3];
    nanPoly = [[RatPoly alloc] initWithTerm:nanTerm];
    
    zeroNum = [RatNum initZERO];
    zeroTerm = [[RatTerm alloc] initWithCoeff:zeroNum Exp:0];
    zeroPoly = [[RatPoly alloc] init];
}

-(void)tearDown{}

// *** Tests ***

- (void) testValueOf{
    
    RatPoly* p1 = [RatPoly valueOf:@"x^3+2*x^2+5"];
    RatPoly* p2 = poly3(term1(1, 3),term1(2, 2),term1(5, 0));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"-x^3+2*x^2+5"];
    p2 = poly3(term1(-1, 3),term1(2, 2),term1(5, 0));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = polyS(@"-x^3+2*x^2+5");
    p2 = poly3(term1(-1, 3),term1(2, 2),term1(5, 0));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"x^3-2*x^2+5"];
    p2 = poly3(term1(1, 3),term1(-2, 2),term1(5, 0));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"-x^3-2*x^2-5"];
    p2 = poly3(term1(-1, 3),term1(-2, 2),term1(-5, 0));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"-3/4*x^3-2*x^2-5/3*x"];
    p2 = poly3(term2(-3,4,3),term2(-2,1,2),term2(-5,3,1));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^3-2*x^2-5/3*x"];
    p2 = poly3(term2(3,4,3),term2(-2,1,2),term2(-5,3,1));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^3+7/8*x^2+5/3*x"];
    p2 = poly3(term2(3,4,3),term2(7,8,2),term2(5,3,1));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^31+7/8*x^19+5/3*x"];
    p2 = poly3(term2(3,4,31),term2(7,8,19),term2(5,3,1));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"NaN"];
    STAssertTrue(isTwoPolyEqual(p1, nanPoly), @"", @"");
    
    p1 = [RatPoly valueOf:@"0"];
    STAssertTrue(isTwoPolyEqual(p1, zeroPoly), @"", @"");
    
    p1 = [RatPoly valueOf:@"5/6"];
    p2 = poly1(term2(5,6,0));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"-5/6"];
    p2 = poly1(term2(-5,6,0));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"6"];
    p2 = poly1(term2(6,1,0));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"-6"];
    p2 = poly1(term2(-6,1,0));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"x"];
    p2 = poly1(term2(1,1,1));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"-x"];
    p2 = poly1(term2(-1,1,1));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");

    p1 = [RatPoly valueOf:@"x^7"];
    p2 = poly1(term2(1,1,7));
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");

    
}

-(void)testisNaN{
    STAssertTrue([nanPoly isNaN], @"", @"");
    STAssertTrue([poly1(term2(-5, 0, 4)) isNaN], @"", @"");
    STAssertTrue([poly2(term2(4,1,4), term2(-5,0,3)) isNaN], @"", @"");
    STAssertTrue([poly3(term2(4,1,4), term2(6,1,1), term2(0,0,0)) isNaN], @"", @"");
    
    STAssertFalse([poly2(term2(4,1,4), term2(-5,2,1)) isNaN], @"", @"");
    STAssertFalse([poly2(term2(4,1,2), term2(-5,2,0)) isNaN], @"", @"");
    
}

-(void)testGetTerm{
    
    RatPoly *rp = poly2(term1(4, 3), term1(5, 2));
    STAssertEqualObjects([rp getTerm:3], term1(4,3), @"", @"");
    STAssertEqualObjects([rp getTerm:2], term1(5,2), @"", @"");
    STAssertEqualObjects([rp getTerm:4], zeroTerm, @"", @"");
    STAssertEqualObjects([rp getTerm:0], zeroTerm, @"", @"");
    
    RatPoly *NaNPoly = poly2(term2(4,1,4), term2(-5,0,3));
    STAssertEqualObjects([NaNPoly getTerm:4], term2(4,1,4), @"", @"");
}

-(void)testNegate{
    
    RatPoly *p1;
    RatPoly *p2;
    
    p1 = [RatPoly valueOf:@"3/4*x^3-2*x^2-5/3*x"];
    p1 = [p1 negate];
    p2 = [RatPoly valueOf:@"-3/4*x^3+2*x^2+5/3*x"];
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"-3/4*x^3-2*x^2-5/3*x"];
    p1 = [p1 negate];
    p2 = [RatPoly valueOf:@"3/4*x^3+2*x^2+5/3*x"];
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"5/3"];
    p1 = [p1 negate];
    p2 = [RatPoly valueOf:@"-5/3"];
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"x"];
    p1 = [p1 negate];
    p2 = [RatPoly valueOf:@"-x"];
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"0"];
    p1 = [p1 negate];
    p2 = [RatPoly valueOf:@"0"];
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
    
    p1 = [RatPoly valueOf:@"NaN"];
    p1 = [p1 negate];
    p2 = [RatPoly valueOf:@"NaN"];
    STAssertTrue(isTwoPolyEqual(p1, p2), @"", @"");
}

-(void)testAdd
{
    
    RatPoly *p1;
    RatPoly *p2;
    RatPoly *expSum;
    
    p1 = [RatPoly valueOf:@"21/32*x^5+3/8x^3"];
    p2 = [RatPoly valueOf:@"35/8*x^3+5/2*x"];
    expSum = [RatPoly valueOf:@"21/32*x^5+19/4*x^3+5/2*x"];
    STAssertTrue(isTwoPolyEqual([p1 add:p2], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"21/32*x^5-3/8x^3"];
    p2 = [RatPoly valueOf:@"35/8*x^3+5/2*x"];
    expSum = [RatPoly valueOf:@"21/32*x^5+4*x^3+5/2*x"];
    STAssertTrue(isTwoPolyEqual([p1 add:p2], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^3-2*x^2-5/3*x"];
    p2 = [RatPoly valueOf:@"-3/4*x^3+2*x^2+5/3*x"];
    expSum = [RatPoly valueOf:@"0"];
    STAssertTrue(isTwoPolyEqual([p1 add:p2], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^3-x^2-3*x+9"];
    p2 = [RatPoly valueOf:@"4*x^3+2*x^2+5/3*x-8"];
    expSum = [RatPoly valueOf:@"19/4*x^3+x^2-4/3*x+1"];
    STAssertTrue(isTwoPolyEqual([p1 add:p2], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^4-x^2"];
    p2 = [RatPoly valueOf:@"-4*x^6+2*x^3"];
    expSum = [RatPoly valueOf:@"-4*x^6+3/4*x^4+2*x^3-x^2"];
    STAssertTrue(isTwoPolyEqual([p1 add:p2], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^4-x^2"];
    p2 = [RatPoly valueOf:@"0"];
    expSum = [RatPoly valueOf:@"3/4*x^4-x^2"];
    STAssertTrue(isTwoPolyEqual([p1 add:p2], expSum), @"", @"");
    STAssertTrue(isTwoPolyEqual([p2 add:p1], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"0"];
    p2 = [RatPoly valueOf:@"0"];
    expSum = [RatPoly valueOf:@"0"];
    STAssertTrue(isTwoPolyEqual([p1 add:p2], expSum), @"", @"");
    STAssertTrue(isTwoPolyEqual([p2 add:p1], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^4-x^2"];
    p2 = [RatPoly valueOf:@"NaN"];
    expSum = [RatPoly valueOf:@"NaN"];
    STAssertTrue(isTwoPolyEqual([p1 add:p2], expSum), @"", @"");
    STAssertTrue(isTwoPolyEqual([p2 add:p1], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"NaN"];
    p2 = [RatPoly valueOf:@"NaN"];
    expSum = [RatPoly valueOf:@"NaN"];
    STAssertTrue(isTwoPolyEqual([p1 add:p2], expSum), @"", @"");
    STAssertTrue(isTwoPolyEqual([p2 add:p1], expSum), @"", @"");
    
}


-(void)testSub
{
    
    RatPoly *p1;
    RatPoly *p2;
    RatPoly* expSum;
    
    p1 = [RatPoly valueOf:@"-3/4*x^3-2*x^2-5/3*x"];
    p2 = [RatPoly valueOf:@"-2*x^3"];
    expSum = [RatPoly valueOf:@"5/4*x^3-2*x^2-5/3*x"];
    STAssertTrue(isTwoPolyEqual([p1 sub:p2], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^3-2*x^2-5/3*x"];
    p2 = [RatPoly valueOf:@"3/4*x^3-2*x^2-5/3*x"];
    expSum = [RatPoly valueOf:@"0"];
    STAssertTrue(isTwoPolyEqual([p1 sub:p2], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^3-2*x^2-5/3*x+3"];
    p2 = [RatPoly valueOf:@"1"];
    expSum = [RatPoly valueOf:@"3/4*x^3-2*x^2-5/3*x+2"];
    STAssertTrue(isTwoPolyEqual([p1 sub:p2], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"2"];
    p2 = [RatPoly valueOf:@"1"];
    expSum = [RatPoly valueOf:@"1"];
    STAssertTrue(isTwoPolyEqual([p1 sub:p2], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"NaN"];
    p2 = [RatPoly valueOf:@"3/4*x^3-2*x^2-5/3*x"];
    expSum = [RatPoly valueOf:@"NaN"];
    STAssertTrue(isTwoPolyEqual([p1 sub:p2], expSum), @"", @"");
    STAssertTrue(isTwoPolyEqual([p2 sub:p1], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"0"];
    p2 = [RatPoly valueOf:@"3/4*x^3-2*x^2-5/3*x"];
    expSum = [RatPoly valueOf:@"-3/4*x^3+2*x^2+5/3*x"];
    STAssertTrue(isTwoPolyEqual([p1 sub:p2], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^3-2*x^2-5/3*x"];
    p2 = [RatPoly valueOf:@"0"];
    expSum = [RatPoly valueOf:@"3/4*x^3-2*x^2-5/3*x"];
    STAssertTrue(isTwoPolyEqual([p1 sub:p2], expSum), @"", @"");
    
    
    
}


-(void)testMul
{
    
    RatPoly *p1;
    RatPoly *p2;
    RatPoly* expResult;
    
    p1 = [RatPoly valueOf:@"3/4*x^96+5*x^23"];
    p2 = [RatPoly valueOf:@"7/8*x^50+1/2*x"];
    expResult = [RatPoly valueOf:@"21/32*x^146+3/8*x^97+35/8*x^73+5/2*x^24"];
    STAssertTrue(isTwoPolyEqual([p1 mul:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"1"];
    p2 = [RatPoly valueOf:@"x"];
    expResult = [RatPoly valueOf:@"x"];
    STAssertTrue(isTwoPolyEqual([p1 mul:p2], expResult), @"", @"");
    STAssertTrue(isTwoPolyEqual([p2 mul:p1], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"NaN"];
    p2 = [RatPoly valueOf:@"7/8*x^3+1/2*x+9"];
    expResult = [RatPoly valueOf:@"NaN"];
    STAssertTrue(isTwoPolyEqual([p1 mul:p2], expResult), @"", @"");
    STAssertTrue(isTwoPolyEqual([p2 mul:p1], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"0"];
    p2 = [RatPoly valueOf:@"7/8*x^3+1/2*x+9"];
    expResult = [RatPoly valueOf:@"0"];
    STAssertTrue(isTwoPolyEqual([p1 mul:p2], expResult), @"", @"");
    STAssertTrue(isTwoPolyEqual([p2 mul:p1], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^2+5"];
    p2 = [RatPoly valueOf:@"7/8*x^3+1/2*x"];
    expResult = [RatPoly valueOf:@"21/32*x^5+19/4*x^3+5/2*x"];
    STAssertTrue(isTwoPolyEqual([p1 mul:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"2"];
    p2 = [RatPoly valueOf:@"7/8*x^3+1/2*x"];
    expResult = [RatPoly valueOf:@"7/4*x^3+x"];
    STAssertTrue(isTwoPolyEqual([p1 mul:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"1"];
    p2 = [RatPoly valueOf:@"7/8*x^3+1/2*x+9"];
    expResult = [RatPoly valueOf:@"7/8*x^3+1/2*x+9"];
    STAssertTrue(isTwoPolyEqual([p1 mul:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"2*x"];
    p2 = [RatPoly valueOf:@"2"];
    expResult = [RatPoly valueOf:@"4*x"];
    STAssertTrue(isTwoPolyEqual([p1 mul:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"x"];
    p2 = [RatPoly valueOf:@"x"];
    expResult = [RatPoly valueOf:@"x^2"];
    STAssertTrue(isTwoPolyEqual([p1 mul:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"x^3"];
    p2 = [RatPoly valueOf:@"x^4"];
    expResult = [RatPoly valueOf:@"x^7"];
    STAssertTrue(isTwoPolyEqual([p1 mul:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^3"];
    p2 = [RatPoly valueOf:@"1/2*x^4"];
    expResult = [RatPoly valueOf:@"3/8*x^7"];
    STAssertTrue(isTwoPolyEqual([p1 mul:p2], expResult), @"", @"");
    
}


-(void)testDiv {
    
    RatPoly *p1;
    RatPoly *p2;
    RatPoly* expResult;
    
    p1 = [RatPoly valueOf:@"x^3-2*x+3"];
    p2 = [RatPoly valueOf:@"3*x^2"];
    expResult = [RatPoly valueOf:@"1/3*x"];
    STAssertTrue(isTwoPolyEqual([p1 div:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"x^2+2*x+15"];
    p2 = [RatPoly valueOf:@"2*x^3"];
    expResult = [RatPoly valueOf:@"0"];
    STAssertTrue(isTwoPolyEqual([p1 div:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"15"];
    p2 = [RatPoly valueOf:@"2*x^3"];
    expResult = [RatPoly valueOf:@"0"];
    STAssertTrue(isTwoPolyEqual([p1 div:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"x^3+x-1"];
    p2 = [RatPoly valueOf:@"x+1"];
    expResult = [RatPoly valueOf:@"x^2-x+2"];
    STAssertTrue(isTwoPolyEqual([p1 div:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"10*x^3"];
    p2 = [RatPoly valueOf:@"5*x^2"];
    expResult = [RatPoly valueOf:@"2*x"];
    STAssertTrue(isTwoPolyEqual([p1 div:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"x^2+x"];
    p2 = [RatPoly valueOf:@"5*x^2+6*x"];
    expResult = [RatPoly valueOf:@"1/5"];
    STAssertTrue(isTwoPolyEqual([p1 div:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"10*x^3+7"];
    p2 = [RatPoly valueOf:@"3"];
    expResult = [RatPoly valueOf:@"10/3*x^3+7/3"];
    STAssertTrue(isTwoPolyEqual([p1 div:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"10*x^3+7"];
    p2 = [RatPoly valueOf:@"-3"];
    expResult = [RatPoly valueOf:@"-10/3*x^3-7/3"];
    STAssertTrue(isTwoPolyEqual([p1 div:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"0"];
    p2 = [RatPoly valueOf:@"10*x^3+7"];
    expResult = [RatPoly valueOf:@"0"];
    STAssertTrue(isTwoPolyEqual([p1 div:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"10*x^3+7"];
    p2 = [RatPoly valueOf:@"0"];
    expResult = [RatPoly valueOf:@"NaN"];
    STAssertTrue(isTwoPolyEqual([p1 div:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"NaN"];
    p2 = [RatPoly valueOf:@"-10/3*x^3-7/3"];
    expResult = [RatPoly valueOf:@"NaN"];
    STAssertTrue(isTwoPolyEqual([p1 div:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"-10/3*x^3-7/3"];
    p2 = [RatPoly valueOf:@"NaN"];
    expResult = [RatPoly valueOf:@"NaN"];
    STAssertTrue(isTwoPolyEqual([p1 div:p2], expResult), @"", @"");
    
    p1 = [RatPoly valueOf:@"-10*x^3+7"];
    p2 = [RatPoly valueOf:@"1"];
    expResult = [RatPoly valueOf:@"-10*x^3+7"];
    STAssertTrue(isTwoPolyEqual([p1 div:p2], expResult), @"", @"");
   
}



-(void)testEval
{
	RatPoly *p = [[RatPoly alloc] initWithTerms:[NSArray arrayWithObjects:term1(20,3), term1(10,2), nil]];
	STAssertEqualsWithAccuracy([p eval:10], 21000.0, 0.000001, @"", @"");
}

@end
