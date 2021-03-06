#import "RatTerm.h"


@implementation RatTerm

@synthesize coeff;
@synthesize expt;

// Checks that the representation invariant holds.
-(void) checkRep{ // 5 points
    
    // Check  coeff == 0 implies expt == 0
    if ([coeff isEqual: [RatNum initZERO]] && expt != 0) {
        [NSException raise:@"RatTerm rep error" format:
         @"When coeff is zero, exponent must be zero also."];
    }
    
    // Check that coeff != null
    if (coeff == nil) {
        [NSException raise:@"RatTerm rep error" format:
         @"Coeff cannot be nil."];
    }

}

-(id)initWithCoeff:(RatNum*)c Exp:(int)e{
    // REQUIRES: (c, e) is a valid RatTerm
    // EFFECTS: returns a RatTerm with coefficient c and exponent e
    
    RatNum *ZERO = [RatNum initZERO];
    // if coefficient is 0, exponent must also be 0
    // we'd like to keep the coefficient, so we must retain it
    if ([c isNaN]) {
        coeff = [RatNum initNaN];
    }
    else if ([c isEqual:ZERO]) {
        coeff = ZERO;
        expt = 0;
    }
    else {
        coeff = c;
        expt = e;
    }
    [self checkRep];
    return self;
}

+(id)initZERO { // 5 points
    // EFFECTS: returns a zero ratterm
    
    RatNum *ZERO = [RatNum initZERO];
    RatTerm *result = [[RatTerm alloc] initWithCoeff:ZERO Exp:0];
    // note: checkRep is called in initWithCoeff:Exp: constructor.
    return result;
}

+(id)initNaN { // 5 points
    // EFFECTS: returns a nan ratterm
    
    RatNum *NaNRatNum = [RatNum initNaN];
    RatTerm *result = [[RatTerm alloc] initWithCoeff:NaNRatNum Exp:0];
    // note: checkRep is called in initWithCoeff:Exp: constructor.
    return result;
    
}

-(BOOL)isNaN { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: return YES if and only if coeff is NaN
    
    if ([coeff isEqual:[RatNum initNaN]])
        return YES;
    else
        return NO;
    
}

-(BOOL)isZero { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: return YES if and only if coeff is zero
    
    RatNum *ZERO = [RatNum initZERO];
    
    if ([coeff isEqual:ZERO])
        return YES;
    else
        return NO;
    
}


// Returns the value of this RatTerm, evaluated at d.
-(double)eval:(double)d { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: return the value of this polynomial when evaluated at
    //            'd'. For example, "3*x^2" evaluated at 2 is 12. if 
    //            [self isNaN] returns YES, return NaN
    
    if ([self isNaN])
        return NAN;
    
    double numer = coeff.numer;
    double denom = coeff.denom;
    
    return (numer/denom*pow(d,expt));
    
}

-(RatTerm*)negate{ // 5 points
    // REQUIRES: self != nil 
    // EFFECTS: return the negated term, return NaN if the term is NaN
    
    if ([self isNaN])
        return [RatTerm initNaN];
    
    RatNum *new_coeff = [coeff negate];
    // note: no change to expt.
    return [[RatTerm alloc] initWithCoeff:new_coeff Exp:expt];
    
}



// Addition operation.
-(RatTerm*)add:(RatTerm*)arg { // 5 points
    // REQUIRES: (arg != null) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
    //            arg.isZero() || self.isNaN() || arg.isNaN())).
    // EFFECTS: returns a RatTerm equals to (self + arg). If either argument is NaN, then returns NaN.
    //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.
    
    if ([self isNaN] || [arg isNaN])
        return [RatTerm initNaN];
    
    if ( (self.expt != arg.expt) &&
        !([self isZero])         &&
        !([self isNaN])          &&
        !([arg isZero])          &&
        !([arg isNaN])              )
    {
        [NSException raise:@"RatTerm add error" format:
         @"Exponent mismatch on non-zero, non-NaN arguments."];
    }
    
    RatNum *new_coeff = [self.coeff add:(arg.coeff)];
    
    int new_expt;
    
    if (expt > arg.expt) {
        new_expt = expt;
    }
    else
        new_expt = arg.expt;
    
    return [[RatTerm alloc] initWithCoeff:new_coeff Exp:new_expt];
}


// Subtraction operation.
-(RatTerm*)sub:(RatTerm*)arg { // 5 points
    // REQUIRES: (arg != nil) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
    //             arg.isZero() || self.isNaN() || arg.isNaN())).
    // EFFECTS: returns a RatTerm equals to (self - arg). If either argument is NaN, then returns NaN.
    //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.
    
    return [self add:[arg negate]];
}


// Multiplication operation
-(RatTerm*)mul:(RatTerm*)arg { // 5 points
    // REQUIRES: arg != null, self != nil
    // EFFECTS: return a RatTerm equals to (self*arg). If either argument is NaN, then return NaN
    
    if ([self isNaN] || [arg isNaN])
        return [RatTerm initNaN];
    
    RatNum *new_coeff = [self.coeff mul:(arg.coeff)];
    int new_expt = self.expt + arg.expt;
    return [[RatTerm alloc] initWithCoeff:new_coeff Exp:new_expt];
}


// Division operation
-(RatTerm*)div:(RatTerm*)arg { // 5 points
    // REQUIRES: arg != null, self != nil
    // EFFECTS: return a RatTerm equals to (self/arg). If either argument is NaN, then return NaN
    
    if ([self isNaN] || [arg isNaN])
        return [RatTerm initNaN];
    
    RatNum *new_coeff = [self.coeff div:(arg.coeff)];
    int new_expt = self.expt - arg.expt;
    return [[RatTerm alloc] initWithCoeff:new_coeff Exp:new_expt];
}


// Returns a string representation of this RatTerm.
-(NSString*)stringValue { // 5 points
    //  REQUIRES: self != nil
    // EFFECTS: return A String representation of the expression represented by this.
    //           There is no whitespace in the returned string.
    //           If the term is itself zero, the returned string will just be "0".
    //           If this.isNaN(), then the returned string will be just "NaN"
    //		    
    //          The string for a non-zero, non-NaN RatTerm is in the form "C*x^E" where C
    //          is a valid string representation of a RatNum (see {@link ps1.RatNum}'s
    //          toString method) and E is an integer. UNLESS: (1) the exponent E is zero,
    //          in which case T takes the form "C" (2) the exponent E is one, in which
    //          case T takes the form "C*x" (3) the coefficient C is one, in which case T
    //          takes the form "x^E" or "x" (if E is one) or "1" (if E is zero).
    // 
    //          Valid example outputs include "3/2*x^2", "-1/2", "0", and "NaN".
    
    if ([self isZero]) return @"0";
    
    if ([self isNaN]) return @"NaN";
    
    NSString *coeffStr;
    NSString *exptStr;
    NSString *astericksSign;
    
    // Fill up exponent part of the string to be returned.
    if (self.expt == 1) {
        exptStr = @"x";
    }
    else if (self.expt == 0) {
        exptStr = @"";
    }
    else if (self.expt > 1) {
        exptStr = [NSString stringWithFormat:@"x^%d", self.expt];
    }
    
    // Fill up coefficient part of the string to be returned.
    RatNum *one = [[RatNum alloc] initWithInteger:1];
    RatNum *negOne = [[RatNum alloc] initWithInteger:-1];
    
    if ([self.coeff isEqual:negOne] && self.expt == 0) {
        coeffStr = @"1";
    }
    else if ([self.coeff isEqual:one] && self.expt > 0) {
        coeffStr = @"";
    }
    else if ([self.coeff isEqual:negOne] && self.expt == 0) {
        coeffStr = @"-1";
    }
    else if ([self.coeff isEqual:negOne] && self.expt > 0) {
        coeffStr = @"-";
    }
    else {
        // coeff is not 1
        coeffStr = [self.coeff stringValue];
    }
    
    // Decide whether astericks sign is needed.
    if ( [coeffStr isEqualToString:@""] || [coeffStr isEqualToString:@"-"] || [exptStr isEqualToString:@""])
        astericksSign = @"";
    else
        astericksSign = @"*";
    
    // return coeffStr + astericksSign+ exptStr
    NSString *combinedStr;
    combinedStr = [[coeffStr stringByAppendingString:astericksSign] stringByAppendingString:exptStr];
    
    return combinedStr;
    
}

// Build a new RatTerm, given a descriptive string.
+(RatTerm*)valueOf:(NSString*)str { // 5 points
    // REQUIRES: that self != nil and "str" is an instance of
    //             NSString with no spaces that expresses
    //             RatTerm in the form defined in the stringValue method.
    //             Valid inputs include "0", "x", "-5/3*x^3", and "NaN"
    // EFFECTS: returns a RatTerm t such that [t stringValue] = str
    
    /* Strategy
        
        1) Deduce Exponent
            1a) If ^ present, then expt > 1
            1b) If ^ absent and x present, then expt == 1.
            1c) If ^ absent and x absent, then expt == 0.
        2) Deduce Coefficient
            2a) If * present, then substring that precedes * is the coefficient.
            2b) If * absent and x present, then coeff == 1.
            2c) If * absent and x absent, then the entire string is the coefficient.
        3) Construct new RatTerm object with exponent and coefficient. Return.
    */
    
    // Check for NaN
    if ([str isEqualToString:@"NaN"]) {
        RatTerm *result = [RatTerm initNaN];
        return result;
    }
    
    // Extract expt.
    
    int expt;
    NSRange range = [str rangeOfString: @"x"];
    
    if (range.location == NSNotFound) {
        // x absent
        expt = 0;
    }
    else { // x present
        if( [str rangeOfString: @"^"].location != NSNotFound) {
            // ^ present
            NSString *temp = [str substringFromIndex:((range.location)+2) ];
            expt = [temp intValue];
        }
        else { // ^ absent
            expt = 1;
        }
    }
    
    
    // Extract coefficient.
    
    NSMutableString *coeffStr = [[NSMutableString alloc] initWithString:@""];
    NSString *temp = @"";
    
    const char *c_style_str = [str cStringUsingEncoding:NSUTF8StringEncoding]; // convert NSString string to C-Style string.
    
    for(int i=0;
        c_style_str[i]!='*' && c_style_str[i]!='x' && i<str.length;
        i++) {
        temp = [str substringWithRange:NSMakeRange(i, 1)];
        [coeffStr appendString: temp];
    }
    
    // Build coeff from the string representation extracted.
    
    // Check for "special cases"
    if ([coeffStr isEqualToString:@"-"]) {
        coeffStr = (NSMutableString*)@"-1";
    }
    if ([coeffStr length] == 0) {
        coeffStr = (NSMutableString*)@"1";
    }
    
    RatNum *coeff = [RatNum valueOf:coeffStr];
    
    // Combine coeff and expt to build RatTerm object to be returned.
    RatTerm *result = [[RatTerm alloc] initWithCoeff:coeff Exp:expt];
    return result;
}

//  Equality test,
-(BOOL)isEqual:(id)obj { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: returns YES if "obj" is an instance of RatTerm, which represents
    //            the same RatTerm as self.
    
    if (![obj isMemberOfClass:[RatTerm class]]) {
        return NO;
    }

    BOOL coeffEqual = [self.coeff isEqual:[obj coeff]];
    BOOL exptEqual = (self.expt == [obj expt]);

    return coeffEqual && exptEqual;

}

@end
