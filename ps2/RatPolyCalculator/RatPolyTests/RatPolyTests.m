#import "RatPolyTests.h"

#define TOLERANCE 0.0000001 // tolerance for comparing floating point numbers.

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


- (void) testCtorInit {
    RatPoly *p1 = [[RatPoly alloc] init];
    RatPoly *expectedPoly = [RatPoly valueOf:@"0"];
    STAssertEqualObjects(p1, expectedPoly, @"");
}

- (void) testCtorInitWithTerm {
    
    RatPoly *p1;
    RatPoly *expectedPoly;
    
    p1 = [[RatPoly alloc] initWithTerm:term2(3, 2, 2)];
    expectedPoly = [RatPoly valueOf:@"3/2*x^2"];
    STAssertEqualObjects(p1, expectedPoly, @"");
    
    p1 = [[RatPoly alloc] initWithTerm:term2(-3, 2, 2)];
    expectedPoly = [RatPoly valueOf:@"-3/2*x^2"];
    STAssertEqualObjects(p1, expectedPoly, @"");
    
    p1 = [[RatPoly alloc] initWithTerm:term2(3, 2, 0)];
    expectedPoly = [RatPoly valueOf:@"3/2"];
    STAssertEqualObjects(p1, expectedPoly, @"");
    
    p1 = [[RatPoly alloc] initWithTerm:term2(3, 1, 0)];
    expectedPoly = [RatPoly valueOf:@"3"];
    STAssertEqualObjects(p1, expectedPoly, @"");
    
    p1 = [[RatPoly alloc] initWithTerm:term2(-3, 1, 0)];
    expectedPoly = [RatPoly valueOf:@"-3"];
    STAssertEqualObjects(p1, expectedPoly, @"");
    
    p1 = [[RatPoly alloc] initWithTerm:term2(1, 1, 0)];
    expectedPoly = [RatPoly valueOf:@"1"];
    STAssertEqualObjects(p1, expectedPoly, @"");
    
    p1 = [[RatPoly alloc] initWithTerm:term2(0, 1, 0)];
    expectedPoly = [RatPoly valueOf:@"0"];
    STAssertEqualObjects(p1, expectedPoly, @"");
    
    p1 = [[RatPoly alloc] initWithTerm:[RatTerm initNaN]];
    expectedPoly = [RatPoly valueOf:@"NaN"];
    STAssertEqualObjects(p1, expectedPoly, @"");
}

- (void) testCtorInitWithTerms {
    RatPoly *p1;
    RatPoly *expectedPoly;
    NSArray *ts;
    
    ts = [[NSArray alloc] initWithObjects:term2(-4,5,3),term2(1,2,2),term2(-4,5,0), nil];
    p1 = [[RatPoly alloc] initWithTerms:ts];
    expectedPoly = [RatPoly valueOf:@"-4/5*x^3+1/2*x^2-4/5"];
    STAssertEqualObjects(p1, expectedPoly, @"");
    
    ts = [[NSArray alloc] initWithObjects:term2(-5,1,0), nil];
    p1 = [[RatPoly alloc] initWithTerms:ts];
    expectedPoly = [RatPoly valueOf:@"-5"];
    STAssertEqualObjects(p1, expectedPoly, @"");
    
    ts = [[NSArray alloc] initWithObjects:term2(1,1,1), nil];
    p1 = [[RatPoly alloc] initWithTerms:ts];
    expectedPoly = [RatPoly valueOf:@"x"];
    STAssertEqualObjects(p1, expectedPoly, @"");
    
    ts = [[NSArray alloc] initWithObjects:[RatTerm initNaN], nil];
    p1 = [[RatPoly alloc] initWithTerms:ts];
    expectedPoly = [RatPoly valueOf:@"NaN"];
    STAssertEqualObjects(p1, expectedPoly, @"");
    
}


- (void) testDegree {
    RatPoly *p1;
    int expDeg;
    
    expDeg = 3;
    p1 = [RatPoly valueOf:@"x^3-2*x+3"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"x^3"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"-x^3"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"9/8*x^3-2*x+3"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"-7/6x^3-2*x+3"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    
    expDeg = 1;
    p1 = [RatPoly valueOf:@"x"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"2*x"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"89*x"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"1/2*x"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"-1/2*x"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    
    expDeg = 0;
    p1 = [RatPoly valueOf:@"5"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"5/4"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"4/5"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"-5"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"-5/4"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"-4/5"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"0"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"NaN"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"-1"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    p1 = [RatPoly valueOf:@"1"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");


    expDeg = 314;
    p1 = [RatPoly valueOf:@"-12457/6253*x^314-88/9*x^134+12457/6253"];
    STAssertTrue([p1 degree] == expDeg, @"", @"");
    
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
    
    p1 = [RatPoly valueOf:@"21/32*x^5+3/8*x^3"];
    p2 = [RatPoly valueOf:@"35/8*x^3+5/2*x"];
    expSum = [RatPoly valueOf:@"21/32*x^5+19/4*x^3+5/2*x"];
    STAssertTrue(isTwoPolyEqual([p1 add:p2], expSum), @"", @"");
    
    p1 = [RatPoly valueOf:@"21/32*x^5-3/8*x^3"];
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
    RatPoly *p1;
    double expResult;
    
    p1 = [RatPoly valueOf:@"-10/3*x^3-7/3"];
    expResult = (-10.0/3.0)*pow(4.0,3.0) - (7.0/3.0);
    STAssertEqualsWithAccuracy([p1 eval:4],expResult , TOLERANCE, @"", @"");
    expResult = (-10.0/3.0)*pow(2.3,3.0) - (7.0/3.0);
    STAssertEqualsWithAccuracy([p1 eval:2.3],expResult , TOLERANCE, @"", @"");
    expResult = (-10.0/3.0)*pow(-2.3,3.0) - (7.0/3.0);
    STAssertEqualsWithAccuracy([p1 eval:-2.3],expResult , TOLERANCE, @"", @"");
    expResult = (-10.0/3.0)*pow(-9,3.0) - (7.0/3.0);
    STAssertEqualsWithAccuracy([p1 eval:-9],expResult , TOLERANCE, @"", @"");
    expResult = (-10.0/3.0)*pow(0,3.0) - (7.0/3.0);
    STAssertEqualsWithAccuracy([p1 eval:0],expResult , TOLERANCE, @"", @"");
    expResult = (-10.0/3.0)*pow(1,3.0) - (7.0/3.0);
    STAssertEqualsWithAccuracy([p1 eval:1],expResult , TOLERANCE, @"", @"");
    expResult = (-10.0/3.0)*pow(-1,3.0) - (7.0/3.0);
    STAssertEqualsWithAccuracy([p1 eval:-1],expResult , TOLERANCE, @"", @"");
    expResult = NAN;
    STAssertEqualsWithAccuracy([p1 eval:NAN],expResult , TOLERANCE, @"", @"");
    
    
    p1 = [RatPoly valueOf:@"x"];
    expResult = 4.5;
    STAssertEqualsWithAccuracy([p1 eval:4.5],expResult , TOLERANCE, @"", @"");
    expResult = -4.5;
    STAssertEqualsWithAccuracy([p1 eval:-4.5],expResult , TOLERANCE, @"", @"");
    expResult = 0;
    STAssertEqualsWithAccuracy([p1 eval:0],expResult , TOLERANCE, @"", @"");
    expResult = NAN;
    STAssertEqualsWithAccuracy([p1 eval:NAN],expResult , TOLERANCE, @"", @"");
    expResult = 12;
    STAssertEqualsWithAccuracy([p1 eval:12],expResult , TOLERANCE, @"", @"");
    
    p1 = [RatPoly valueOf:@"1"];
    expResult = 1.0;
	STAssertEqualsWithAccuracy([p1 eval:4.567],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:6],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:-6],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:4.7],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:-4.35],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:0],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:1],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:0.000001],expResult , TOLERANCE, @"", @"");
    
    p1 = [RatPoly valueOf:@"767/100"];
    expResult = 7.67;
	STAssertEqualsWithAccuracy([p1 eval:6],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:-6],expResult , TOLERANCE,@"", @"");
    STAssertEqualsWithAccuracy([p1 eval:4.7],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:-4.35],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:0],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:1],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:0.000001],expResult , TOLERANCE, @"", @"");
    expResult = NAN;
    STAssertEqualsWithAccuracy([p1 eval:NAN],expResult , 1, @"", @"");
    
    p1 = [RatPoly valueOf:@"NaN"];
    expResult = NAN;
    STAssertEqualsWithAccuracy([p1 eval:6],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:-6],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:4.7],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:-4.35],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:0],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:1],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:0.000001],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:NAN],expResult , TOLERANCE, @"", @"");
    
    p1 = [RatPoly valueOf:@"x^99"];
    expResult = pow(-1,99.0);
	STAssertEqualsWithAccuracy([p1 eval:-1],expResult , TOLERANCE, @"", @"");
    
    p1 = [RatPoly valueOf:@"0"];
    expResult = 0;
	STAssertEqualsWithAccuracy([p1 eval:-4.5],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:4.5],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:4],expResult , TOLERANCE, @"", @"");
    STAssertEqualsWithAccuracy([p1 eval:0],expResult , TOLERANCE, @"", @"");
}


- (void) testStringValue {
    RatPoly *p1;
    NSString* expString;
    
    p1 = [RatPoly valueOf:@"21/32*x^5+3/8*x^3"];
    expString = @"21/32*x^5+3/8*x^3";
    STAssertTrue([[p1 stringValue] isEqualToString:expString], @"", @"");
    
    p1 = [RatPoly valueOf:@"-21/32*x^5+3/8*x^3"];
    expString = @"-21/32*x^5+3/8*x^3";
    STAssertTrue([[p1 stringValue] isEqualToString:expString], @"", @"");
    
    p1 = [RatPoly valueOf:@"-21/32*x^567+3/8*x^311-9/8"];
    expString = @"-21/32*x^567+3/8*x^311-9/8";
    STAssertTrue([[p1 stringValue] isEqualToString:expString], @"", @"");
    
    p1 = [RatPoly valueOf:@"2/3"];
    expString = @"2/3";
    STAssertTrue([[p1 stringValue] isEqualToString:expString], @"", @"");
    
    p1 = [RatPoly valueOf:@"-2/3"];
    expString = @"-2/3";
    STAssertTrue([[p1 stringValue] isEqualToString:expString], @"", @"");
    
    p1 = [RatPoly valueOf:@"0"];
    expString = @"0";
    STAssertTrue([[p1 stringValue] isEqualToString:expString], @"", @"");
    
    p1 = [RatPoly valueOf:@"1"];
    expString = @"1";
    STAssertTrue([[p1 stringValue] isEqualToString:expString], @"", @"");
    
    p1 = [RatPoly valueOf:@"NaN"];
    expString = @"NaN";
    STAssertTrue([[p1 stringValue] isEqualToString:expString], @"", @"");
    
    p1 = [RatPoly valueOf:@"x"];
    expString = @"x";
    STAssertTrue([[p1 stringValue] isEqualToString:expString], @"", @"");

    p1 = [RatPoly valueOf:@"-x"];
    expString = @"-x";
    STAssertTrue([[p1 stringValue] isEqualToString:expString], @"", @"");
}


- (void) testIsEqual {
    
    RatPoly *p1;
    RatPoly *p2;
    
    p1 = [RatPoly valueOf:@"x^3-2*x+3"];
    p2 = [RatPoly valueOf:@"x^3-2*x+3"];
    STAssertTrue([p1 isEqual:p2], @"", @"");
    
    p1 = [RatPoly valueOf:@"12"];
    p2 = [RatPoly valueOf:@"12"];
    STAssertTrue([p1 isEqual:p2], @"", @"");
    
    p1 = [RatPoly valueOf:@"-3/4*x^3-2*x+3"];
    p2 = [RatPoly valueOf:@"-3/4*x^3-2*x+3"];
    STAssertTrue([p1 isEqual:p2], @"", @"");
    
    p1 = [RatPoly valueOf:@"x"];
    p2 = [RatPoly valueOf:@"x"];
    STAssertTrue([p1 isEqual:p2], @"", @"");
    
    p1 = [RatPoly valueOf:@"3/4*x^3-2*x+3"];
    p2 = [RatPoly valueOf:@"3/4*x^3-2*x+3"];
    STAssertTrue([p1 isEqual:p2], @"", @"");
    
    p1 = [RatPoly valueOf:@"x^3-2*x+3"];
    p2 = [RatPoly valueOf:@"x^3-2*x+2"];
    STAssertFalse([p1 isEqual:p2], @"", @"");
    
    p1 = [RatPoly valueOf:@"0"];
    p2 = [RatPoly valueOf:@"0"];
    STAssertTrue([p1 isEqual:p2], @"", @"");
    
    p1 = [RatPoly valueOf:@"NaN"];
    p2 = [RatPoly valueOf:@"x^3-2*x+3"];
    STAssertFalse([p1 isEqual:p2], @"", @"");
    
    p1 = [RatPoly valueOf:@"NaN"];
    p2 = [RatPoly valueOf:@"NaN"];
    STAssertTrue([p1 isEqual:p2], @"", @"");
    
    p1 = [RatPoly valueOf:@"0"];
    p2 = [RatPoly valueOf:@"x^3-2*x+3"];
    STAssertFalse([p1 isEqual:p2], @"", @"");
    
    p1 = [RatPoly valueOf:@"1"];
    p2 = [RatPoly valueOf:@"3"];
    STAssertFalse([p1 isEqual:p2], @"", @"");
  
    p1 = [RatPoly valueOf:@"-1"];
    p2 = [RatPoly valueOf:@"-3"];
    STAssertFalse([p1 isEqual:p2], @"", @"");
}


@end
