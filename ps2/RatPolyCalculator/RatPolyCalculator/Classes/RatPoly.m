#import "RatPoly.h"


/* private */
@interface RatPoly ()

@property (readwrite) NSArray* terms;
@property (readwrite) int degree;

@end

@interface RatPoly(private)

+ (unsigned int) indexOf1stRatTermIn:(NSArray*)arr WithExpt:(int)yourExp;
// REQUIRES: arr must be an array of RatTerm objects.
// EFFECTS: returns index of 1st RatTerm that has expoenent equal to yourExp.
//          returns -1 otherwise.


RatNum* ratNum2(int i, int j);
// EFFECTS: Constructs and returns a new rational number i/j

RatTerm* ratTerm3(int numer, int denom, int expt);
// EFFECTS: Constructs and returns a new rational term (numer/denom)*x^expt

- (BOOL) isZeroPoly;
// EFFECTS: returns YES if self is zero polynomial. Returns NO otherwise.

+ (RatPoly*) initWithRatPoly:(RatPoly*)myPoly;
// EFFECTS: Constructs a new RatPoly object by deep copying myPoly. Returns pointer to this new object.

- (RatTerm*) highestDegreeRatTerm;
// EFFECTS: Returns the highest degree rational term in a polynomial.

@end

/* end of private */




@implementation RatPoly

@synthesize terms = _terms;




//TODO
+(void)doNotUseMe {
    
//    NSMutableArray* rTArr = [[NSMutableArray alloc] init];
//    [rTArr addObject:term3(3,4,2)];
//    [rTArr addObject:term3(3,4,4)];
//    [rTArr addObject:term3(3,4,7)];
//    [rTArr addObject:term3(3,4,9)];
//    
//    NSLog(@"size is %ld",[rTArr count]);
//    
//    for(int i= 0;i<10;i++){
//        NSLog(@"expt %d is at index %d\n", i, [RatPoly indexOf1stRatTermIn:rTArr WithExpt:i]);
//    }
    
    
    
    
    
}


// Note that since there is no variable called "degree" in our class,the compiler won't synthesize 
// the "getter" for "degree". and we have to write our own getter
-(int)degree{ // 5 points
    // EFFECTS: returns the degree of this RatPoly object. 
    
    if ([_terms count] == 0)
        return 0;
    
    return [[_terms objectAtIndex:0] expt];
}


// Check that the representation invariant is satisfied
-(void)checkRep{ // 5 points
	
    // Check that terms != null
    if (self.terms == nil) {
        [NSException raise:@"RatPoly rep error" format:@"terms cannot be nil."];
    }
    
    
    /* Check for:
        forall i such that (0 <= i < length(p)), C(p,i) != 0 &&
        forall i such that (0 <= i < length(p)), E(p,i) >= 0 &&
        forall i such that (0 <= i < length(p) - 1), E(p,i) > E(p, i+1)
    */
    
    RatNum *zeroRatNum = [[RatNum alloc] initWithInteger:0];
    
    for (int i=0; i<[_terms count]; i++) {
        
        if ([[[_terms objectAtIndex:i] coeff] isEqual:zeroRatNum])
            [NSException raise:@"RatPoly rep error" format: @"Coefficients cannot be 0"];
        
        if ([[_terms objectAtIndex:i] expt] < 0)
            [NSException raise:@"RatPoly rep error" format: @"Exponent cannot less 0"];
        
        if (i == [_terms count]-1) {
            continue;
        }
        else {
            int thisExpt = [[_terms objectAtIndex:i] expt];
            int nextExpt = [[_terms objectAtIndex:i+1] expt];
            
            if (thisExpt <= nextExpt)
                [NSException raise:@"RatPoly rep error" format: @"Terms are NOT arranged in non-ascending order."];
        }
    }
    
}


-(id)init { // 5 points
    //EFFECTS: constructs a polynomial with zero terms, which is effectively the zero polynomial
    //           remember to call checkRep to check for representation invariant
    
    _terms = [[NSArray alloc]init];
    _degree = 0;
    [self checkRep];
    return self;
}


-(id)initWithTerm:(RatTerm*)rt{ // 5 points
    //  REQUIRES: [rt expt] >= 0
    //  EFFECTS: constructs a new polynomial equal to rt. if rt's coefficient is zero, constructs
    //             a zero polynomial remember to call checkRep to check for representation invariant
    
    if ([rt isZero]) {
        self = [self init];
    }
    else {
        _terms = [[NSArray alloc] initWithObjects:rt,nil];
        _degree = [self degree];
        NSLog(@"degree is %d",_degree);
        
    }
    [self checkRep];
    return self;
}


-(id)initWithTerms:(NSArray*)ts{ // 5 points
    // REQUIRES: "ts" satisfies clauses given in the representation invariant
    // EFFECTS: constructs a new polynomial using "ts" as part of the representation.
    //            the method does not make a copy of "ts". remember to call checkRep to check for representation invariant

    if ([ts count] == 0) {
        self = [self init];
    }
    
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [ts count]; i++) {
        [temp addObject:[ts objectAtIndex:i]];
    }
    
    _terms = [[NSArray alloc] initWithArray:temp];
    _degree = [self degree];
    
    [self checkRep];
    return self;
    
}

-(RatTerm*)getTerm:(int)deg { // 5 points
    // REQUIRES: self != nil && ![self isNaN]
    // EFFECTS: returns the term associated with degree "deg". If no such term exists, return
    //            the zero RatTerm
    
    int index = [RatPoly indexOf1stRatTermIn:_terms WithExpt:deg];
    
    if (index == -1)
        return ratTerm3(0, 1, 0);
    else {
        int numer = [[[_terms objectAtIndex:index] coeff] numer];
        int denom = [[[_terms objectAtIndex:index] coeff] denom];
        int exp = [[_terms objectAtIndex:index] expt];
        return ratTerm3(numer, denom, exp);
    }
}

-(BOOL)isNaN { // 5 points
    // REQUIRES: self != nil
    //  EFFECTS: returns YES if this RatPoly is NaN
    //             i.e. returns YES if and only if some coefficient = "NaN".
    
    for (int i=0; i<[_terms count]; i++) {
        if ([[_terms objectAtIndex:i] isNaN])
            return YES;
    }
    
    return NO;
}


-(RatPoly*)negate { // 5 points
    // REQUIRES: self != nil 
    // EFFECTS: returns the additive inverse of this RatPoly.
    //            returns a RatPoly equal to "0 - self"; if [self isNaN], returns
    //            some r such that [r isNaN]
    
    if ([self isNaN])
        return [[RatPoly alloc] initWithTerm:[RatTerm initNaN]];
    
    
    // Dealing with a non-NaN polynomial below.
    
    NSMutableArray* temp = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[_terms count]; i++) {
        [temp addObject:[[_terms objectAtIndex:i] negate]];
    }
    
    return [[RatPoly alloc] initWithTerms:temp];
    
}


// Addition operation
-(RatPoly*)add:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self+p; if [self isNaN] or [p isNaN], returns
    //            some r such that [r isNaN]
    
    // Strategy:
    //  Traverse both self and p, starting from the first rational term.
    //  Traverse both self and p using indices i and j respectively.
    //  During the traversal, compare terms.
    //  If the compared terms have equal degree, sum the terms and increment both i and j.
    //      Insert the sum into a NSMUtableArray.
    //  If the compared terms don't have equal degree, insert the term with the larger degree
    //      into a NSMutableArray. Increment the index of the term with the larger degree.
    //  After the traversal ends, check whether both polynomials have been traversed to the
    //  last terms. Insert the untraversed terms of the polynomial into NSMUtableArray.
    //  Create a new RatPoly object with NSMUtableArray.
    //  Check for NaN.
    
    // init indices
    int i = 0;
    int j = 0;
    
    // Traverse both polynomials.
    int selfTermsSize = [_terms count];
    int pTermsSize = [[p terms] count];
    int selfRatTermExpt;
    int pRatTermExpt;
    RatTerm* selfRatTerm;
    RatTerm* pRatTerm;
    NSMutableArray *newPolySum = [[NSMutableArray alloc] init];
    
    while (i < selfTermsSize && j < pTermsSize) {
        
        // Grab the terms that i and j refer to.
        selfRatTerm = [_terms objectAtIndex:i];
        selfRatTermExpt = [selfRatTerm expt];
        pRatTerm = [[p terms] objectAtIndex:j];
        pRatTermExpt = [pRatTerm expt];
        
        if (selfRatTermExpt == pRatTermExpt) {
            RatTerm* summedTerm = [selfRatTerm add:pRatTerm];
            [newPolySum addObject:summedTerm];
            
            i++;
            j++;
        }
        else if (selfRatTermExpt > pRatTermExpt) {
            [newPolySum addObject:selfRatTerm];
            
            i++;
        }
        else if (selfRatTermExpt < pRatTermExpt) {
            [newPolySum addObject:pRatTerm];
            
            j++;
        }
    }
    
    
    //  After the traversal ends, check whether both polynomials have been traversed to the
    //  last terms. Insert the untraversed terms of the polynomial into NSMUtableArray.
    
    RatPoly *result;
    
    if (i == selfTermsSize-1 && j == pTermsSize-1) {
        // Both polynomials have been fully traversed.
        result = [[RatPoly alloc] initWithTerms:newPolySum];
    }
    else if ( i < selfTermsSize-1 && j == pTermsSize-1) {
        // self polynomial still has remaining terms.
        for (int x = i; x < selfTermsSize; x++) {
            selfRatTerm = [_terms objectAtIndex:x];
            [newPolySum addObject:selfRatTerm];
        }
        // Both polynomials have been fully traversed now.
        result = [[RatPoly alloc] initWithTerms:newPolySum];
    }
    else if (i == selfTermsSize-1 && j < pTermsSize-1) {
        // p polynomial still has remaining terms.
        for (int x = j; x < selfTermsSize; x++) {
            pRatTerm = [_terms objectAtIndex:x];
            [newPolySum addObject:pRatTerm];
        }
        // Both polynomials have been fully traversed now.
        result = [[RatPoly alloc] initWithTerms:newPolySum];
    }
    
    // Check whether result polynomial is NaN.
    if ([result isNaN]) {
        result = [[RatPoly alloc] initWithTerm:[RatTerm initNaN]];
    }
    
    return result;
    
}

// Subtraction operation
-(RatPoly*)sub:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self-p; if [self isNaN] or [p isNaN], returns
    //            some r such that [r isNaN]
    
    RatPoly *negatedP;
    RatPoly *result;
    
    negatedP = [p negate];
    result = [self add: negatedP];
    return result;
}


// Multiplication operation
-(RatPoly*)mul:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self*p; if [self isNaN] or [p isNaN], returns
    // some r such that [r isNaN]
    
    // Check whether self or p polynomial is NaN.
    if ([self isNaN] || [p isNaN]) {
        return [[RatPoly alloc] initWithTerm:[RatTerm initNaN]];
    }
    
    // Multiplication of these two polynomials will form a axb matrix of RatTerms.
    // Where a is no. of terms in self, and b is the no. of terms in p.
    
    NSMutableArray *arrayOfRatTermArrays = [NSMutableArray array];
    NSMutableArray *singleRatTermArray = [[NSMutableArray alloc]init];
    int selfTermsSize = [_terms count];
    int pTermsSize = [[p terms] count];
    RatTerm* selfRatTerm;
    RatTerm* pRatTerm;
    
    for(int i=0; i<selfTermsSize; i++) {
        selfRatTerm = [_terms objectAtIndex:i];
        singleRatTermArray = [[NSMutableArray alloc]init];
        
        for (int j=0; j<pTermsSize; j++) {
            pRatTerm = [[p terms] objectAtIndex:j];
            RatTerm* muledRatTerm = [selfRatTerm mul:pRatTerm];
            [singleRatTermArray addObject:muledRatTerm];
        }
        
        [arrayOfRatTermArrays addObject:singleRatTermArray];
    } // end of outer for loop
    
    
    // Add all the RatTerm objects in arrayOfRatTermArrays.
    singleRatTermArray = [[NSMutableArray alloc]init];
    RatPoly* result = [[RatPoly alloc] init];
    RatPoly* temp;
    
    for (int x=0; x<[arrayOfRatTermArrays count]; x++) {
        temp = [[RatPoly alloc] initWithTerms:[arrayOfRatTermArrays objectAtIndex:x]];
        result = [result add:temp];
    }
    
    return result;
}


// Division operation (truncating).
-(RatPoly*)div:(RatPoly*)p{ // 5 points
    // REQUIRES: p != null, self != nil
    // EFFECTS: return a RatPoly, q, such that q = "this / p"; if p = 0 or [self isNaN]
    //           or [p isNaN], returns some q such that [q isNaN]
    //
    // Division of polynomials is defined as follows: Given two polynomials u
    // and v, with v != "0", we can divide u by v to obtain a quotient
    // polynomial q and a remainder polynomial r satisfying the condition u = "q *
    // v + r", where the degree of r is strictly less than the degree of v, the
    // degree of q is no greater than the degree of u, and r and q have no
    // negative exponents.
    // 
    // For the purposes of this class, the operation "u / v" returns q as
    // defined above.
    //
    // The following are examples of div's behavior: "x^3-2*x+3" / "3*x^2" =
    // "1/3*x" (with r = "-2*x+3"). "x^2+2*x+15 / 2*x^3" = "0" (with r =
    // "x^2+2*x+15"). "x^3+x-1 / x+1 = x^2-x+2 (with r = "-3").
    //
    // Note that this truncating behavior is similar to the behavior of integer
    // division on computers.
    
    // Special cases:
    if ([p isZeroPoly] ||
        [self isNaN] ||
        [p isNaN] ){
        
        return [[RatPoly alloc] initWithTerm:[RatTerm initNaN]];
    }
    
    // "Normal case"
    /*
     
     Create a mutable array that can hold elements of type "term". Name this array quotientArr.
     Don't create a remainderArr. No need to compute remainder.
     Create a polynomial pointers f, g, and temp.
     Set f = n by making a term-by-term copy of all terms in n to f.
     Set g = d by making a term-by-term copy of all terms in d to g.
     
     while ( degree(f) >= degree(g) ):
     Compute highestDegreeTerm(f) / highestDegreeTerm(g). This division is done like so:
     Divide the coeff. of highestDegreeTerm(f) by the coeff. highestDegreeTerm(g).
     Subtract the degree(g) from degree(f).
     Call the result x.
     Add x to quotientArr.
     Init temp with x. temp is a one-term polynomial now.
     temp = [temp multiply:g];
     f = [f sub:temp];
     [temp release];
     endwhile
     
     Create a new polynomial object, r, with the terms in quotientArr.
     
     return r.
     
     */
    
    RatPoly* nPoly = [RatPoly initWithRatPoly:self];
    RatPoly* dPoly = [RatPoly initWithRatPoly:p];
    NSMutableArray* quotientRatTerms = [[NSMutableArray alloc]init];
    
    while ([nPoly degree] >= [dPoly degree]) {
        RatTerm* nHighestDegRatTerm = [nPoly highestDegreeRatTerm];
        RatTerm* dHighestDegRatTerm = [dPoly highestDegreeRatTerm];
        RatTerm* dividedRatTerm = [nHighestDegRatTerm div:dHighestDegRatTerm];
        [quotientRatTerms addObject:dividedRatTerm];
        RatPoly* temp = [[RatPoly alloc] initWithTerm:dividedRatTerm];
        temp = [temp mul:dPoly];
        nPoly = [nPoly sub: temp];
    }
    
    return [[RatPoly alloc] initWithTerms:quotientRatTerms];
}


-(double)eval:(double)d { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: returns the value of this RatPoly, evaluated at d
    //            for example, "x+2" evaluated at 3 is 5, and "x^2-x" evaluated at 3 is 6.
    //            if [self isNaN], return NaN
    
    if ([self isNaN]) return NAN;
    
    NSUInteger selfTermsSize = [_terms count];
    double sumOfEvaluatedRatTerms = 0;
    
    for (int i=0; i<selfTermsSize; i++) {
        sumOfEvaluatedRatTerms += [[_terms objectAtIndex:i] eval:d];
    }
    
    return sumOfEvaluatedRatTerms;
    
}


// Returns a string representation of this RatPoly.
-(NSString*)stringValue { // 5 points
    // REQUIRES: self != nil
    // EFFECTS:
    // return A String representation of the expression represented by this,
    // with the terms sorted in order of degree from highest to lowest.
    //
    // There is no whitespace in the returned string.
    //        
    // If the polynomial is itself zero, the returned string will just
    // be "0".
    //         
    // If this.isNaN(), then the returned string will be just "NaN"
    //         
    // The string for a non-zero, non-NaN poly is in the form
    // "(-)T(+|-)T(+|-)...", where "(-)" refers to a possible minus
    // sign, if needed, and "(+|-)" refer to either a plus or minus
    // sign, as needed. For each term, T takes the form "C*x^E" or "C*x"
    // where C > 0, UNLESS: (1) the exponent E is zero, in which case T
    // takes the form "C", or (2) the coefficient C is one, in which
    // case T takes the form "x^E" or "x". In cases were both (1) and
    // (2) apply, (1) is used.
    //        
    // Valid example outputs include "x^17-3/2*x^2+1", "-x+1", "-1/2",
    // and "0".
    
    
    // Zero polynomial case:
    if ([self isZeroPoly])  return @"0";
    
    // NaN polynomial case:
    if ([self isNaN]) return @"NaN";
    
    
    NSMutableString* result = [[NSMutableString alloc] initWithString:@""];
    
    for (int i=0; i<[_terms count]; i++) {
        RatTerm* currRatTerm = [_terms objectAtIndex:i];
        NSString* currRatTermStr = [currRatTerm stringValue];
        [result appendString:currRatTermStr];
    }
    
    return [NSString stringWithString:result];
}


// Builds a new RatPoly, given a descriptive String.
+(RatPoly*)valueOf:(NSString*)str { // 5 points
    // REQUIRES : 'str' is an instance of a string with no spaces that
    //              expresses a poly in the form defined in the stringValue method.
    //              Valid inputs include "0", "x-10", and "x^3-2*x^2+5/3*x+3", and "NaN".
    // EFFECTS : return a RatPoly p such that [p stringValue] = str
    
    // Zero polynomial case:
    if ([str isEqualToString:@"0"])
        return [[RatPoly alloc]init];
    
    // NaN polynomial case:
    if ([str isEqualToString:@"NaN"])
        return [[RatPoly alloc] initWithTerm:[RatTerm initNaN]];
    
    // Strategy:
    //  Traverse str, splitting the rational terms by '+'/'-'.
    //  Remove rational terms one by one, starting from the highest degree rational term.
    //  Removed rational terms are inserted into RatTermArr.
    //  After str is empty, use RatTermArr in constructing a new RatPoly object.
    
    
    NSMutableString *inputStr = [[NSMutableString alloc] initWithString:str]; // convert str into mutable string.
    NSMutableArray *RatTermArr = [[NSMutableArray alloc]init]; // will store array of rat terms corresponding to str.
    NSMutableString *singleRatTermStr = [[NSMutableString alloc] initWithString:@""]; // container that will be used later when parsing str.

    
    // Append '+' sign to first term (if first term is positive) to facilitate extraction of terms later.
    if ([[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"]) {
        //do nothing.
    }
    else {
        NSMutableString* temp = [[NSMutableString alloc] initWithString:inputStr];
        inputStr = [[NSMutableString alloc] initWithString:@"-"];
        [inputStr appendString:temp];
    }
    
    
    // Extract RatTerms and insert into RatTerms array.
    while ([inputStr length] != 0) {
        BOOL firstCharIsMinusSymbol = [[inputStr substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"];
        BOOL firstCharIsPlusSymbol = [[inputStr substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"+"];
        BOOL tacklingFirstRatTerm = [inputStr length] == [str length];
        NSString *firstChar = [inputStr substringWithRange:NSMakeRange(0, 1)];
        
        if (firstCharIsPlusSymbol) {
            
            if (!tacklingFirstRatTerm) {
                // Convert singleRatTermStr into RatTerm obj.
                RatTerm* temp = [RatTerm valueOf:singleRatTermStr];
                
                // Insert RatTerm obj into RatTermArr.
                [RatTermArr addObject:temp];
                
                //reset singleRatTermStr
                [singleRatTermStr setString:@""];
            }
            
        }
        else if (firstCharIsMinusSymbol) {
            
            if (!tacklingFirstRatTerm) {
                // Convert singleRatTermStr into RatTerm obj.
                RatTerm* temp = [RatTerm valueOf:singleRatTermStr];
                
                // Insert RatTerm obj into RatTermArr.
                [RatTermArr addObject:temp];
                
                //reset singleRatTermStr
                [singleRatTermStr setString:@""];
            }
            
            [singleRatTermStr appendString:firstChar];
        }
        else if (!firstCharIsMinusSymbol && !firstCharIsPlusSymbol) {
            [singleRatTermStr appendString:firstChar];
        }
        
        //NSString *result = [baseString stringByReplacingCharactersInRange:range withString:@""];
        NSString *immutableInputStr;
        immutableInputStr = [inputStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        inputStr = [[NSMutableString alloc] initWithString:immutableInputStr];
        
    } //end while()
    
    return [[RatPoly alloc] initWithTerms:RatTermArr];
}

// Equality test
-(BOOL)isEqual:(id)obj { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: returns YES if and only if "obj" is an instance of a RatPoly, which represents
    //            the same rational polynomial as self. All NaN polynomials are considered equal
    
    // Check object type
    if (![obj isMemberOfClass:[RatPoly class]]) {
        return NO;
    }
    
    // Check for NaN objects
    if ([obj isNaN] && [self isNaN]) return YES;
    
    // Check whether the two non-NaN polys are equal
    NSUInteger selfTermsSize = [_terms count];
    NSUInteger objTermsSize = [[obj terms] count];
    
    if (selfTermsSize != objTermsSize) return NO;
    
    for (int i=0; i<selfTermsSize; i++) {
        if ([[_terms objectAtIndex:i] isEqual:[[obj terms] objectAtIndex:i]])
            continue;
        else
            return NO;
    }
    
    return YES;
    
}


// *** Private Methods ***

+(unsigned int) indexOf1stRatTermIn:(NSArray*)arr WithExpt:(int)yourExp {
    
    if (arr == nil) {
        [NSException raise:@"RatPoly's indexOf1stRatTermIn error" format:@"arr cannot be nil."];
        return -1;
    }
    
    for(int i=0;i<[arr count];i++)
    {
        if (![[arr objectAtIndex:i] isMemberOfClass:[RatTerm class]])
            [NSException raise:@"RatPoly's indexOf1stRatTermIn error" format:@"arr element is not RatTerm obj."];
        
        int currExp = [[arr objectAtIndex:i] expt];
        
        if (currExp == yourExp)
            return i;
    }
    
    return -1;
    
}


RatTerm* ratTerm3(int numer, int denom, int expt) {
	return [[RatTerm alloc] initWithCoeff:ratNum2(numer, denom) Exp:expt];
}


RatNum* ratNum2(int i, int j) {
	return [[RatNum alloc] initWithNumer:i Denom:j];
}


- (BOOL) isZeroPoly {
    if ([_terms count] == 0) {
        return YES;
    }
    return NO;
}


+ (RatPoly*) initWithRatPoly:(RatPoly*)myPoly {
    RatPoly* newRatPoly;
    newRatPoly = [[RatPoly alloc] initWithTerms:[myPoly terms]];
    return newRatPoly;
}


- (RatTerm*) highestDegreeRatTerm {
    if ([_terms count] == 0) {
        return [RatTerm initZERO];
    }
    else {
        int highestDegree = [self degree];
        return [self getTerm:highestDegree];
    }
}

@end

/* 
 
 Question 1(a)
 ========

 Method 1: Rewrite the whole subtraction function.
    r = p - q:
        Set r = p by making a term-by-term copy of all terms in p to r.
        Foreach term in r:
            if any term, r.term, in r has the same degree as a term, q.term, in q,
                then replace that term in r with (r.term - q.term).
            else
                insert q.term into r as a new term.
        Return r.
 
 Method 2: Make use of the addition function.
    r = p - q:
        Set r = p by making a term-by-term copy of all terms in p to r.
        Set m = -q by negating q with (RatPoly*)negate method and assigning the returning object to m.
        Call r = [p add:m];
        Return r.

 
 Question 1(b)
 ========
 
 r = f * g:
    
    Create a mutable array that can hold elements of type "term".  Name this array partOneArray.
    Create a mutable array that can hold elements of type "term".  Name this array partTwoArray.
    
    foreach term in f:
        foreach term in g:
            Compute (f.term*g.term).  Insert result partOneArray. This multiplication is done like so:
            Multiply the coefficients of f.term and g.term.
            Add the degrees of f.term and g.term.
    
    partOneArray is now filled with all the terms of the result. partOneArray is not necessarily simplified.
    There could be three x^2 terms in partOneArray. Next step, simplify partOneArray.

    Create a new zero polynomial object, r.
    Create a polynomial pointer, h.
 
    foreach term in partOneArray:
        Allocate and initiate h with the term. h only has ONE term.
        Execute r = [r add:h];
        Release object that h is pointing to.
 
    Return r.
 
 

 Question 1(c)
 ========
 
 r = n / d:
    
    Create a mutable array that can hold elements of type "term". Name this array quotientArr.
    Don't create a remainderArr. No need to compute remainder.
    Create polynomial pointers f, g, and temp.
    Set f = n by making a term-by-term copy of all terms in n to f.
    Set g = d by making a term-by-term copy of all terms in d to g.
 
    while ( degree(f) >= degree(g) ):
        Compute highestDegreeTerm(f) / highestDegreeTerm(g). This division is done like so:
        Divide the coeff. of highestDegreeTerm(f) by the coeff. highestDegreeTerm(g).
        Subtract the degree(g) from degree(f).
        Call the result x.
        Add x to quotientArr.
        Init temp with x. temp is a one-term polynomial now.
        temp = [temp multiply:g];
        f = [f sub:temp];
        [temp release];
    endwhile
    
    Create a new polynomial object, r, with the terms in quotientArr.
 
    return r.
 
 
 Question 2(a)
 ========
 
 If self is nil, then a message passed to it returns nil. There is no run-time error. The error handling is graceful.
 
 
 
 Question 2(b)
 ========
 
 valueOf is made a class method so that calling it doesn't require a RatNum object. It is like a constructor - constructors
 should not require an object instance to be fed to it before it does its job.
 
 An alternative is an init instance method: -(id)initWithString:(NSString*)str
 
 Question 2(c)
 ========
 
 Methods that need to be changed:
 
 1. checkRep
 Becomes less complex code-wise. Becomes more efficient execution-wise.
 checkRep no longer has to check that the RatNum instance is stored in the lowest form.
 
 2. initWithNumber
 Becomes less complex code-wise. Becomes more efficient execution-wise.
 initWithNumber no longer has to compute the lowest form of the rational number used in the argument before storing.
 
 3. stringValue
 Becomes more complex code-wise. Becomes less efficient execution-wise.
 stringValue may need to compute the lowest form of the rational number before it can construct the string to be returned.
 BUT...
 Even though stringValue is now slower, the RatNum class can become more efficient:
 - If stringValue is rarely used because RatNum class is being used at very low-level and does not show itself at the UI level.
 - If stringValue is called on fewer RatNum objects than there are RatNum objects created with initWithNumber. Previously,
    initWithNumber forces every RatNum object to have their numerator and denominator stored in lowest form regardless of whether the object will be converted to a string in the future.
    For e.g. if 200 RatNum objects are instantiated, the original representation invariant could execute 200 lowest form computations. In the
    weakened representation invariant, reducing self to lowest form is done in stringValue method. This reduction can then be
    permanently effected in the calling RatNum object.
 
 4. add,sub,mul,div
 Becomes less complex code-wise. Becomes more efficient execution-wise.
 In the weakened representation invariant case, these methods don't need to init the return RatNum object with lowest form.
 Note that code for reducing a RatNum to lowest form would be in the initWithNumber constructor in the strong rep invariant case.
 
 5. isEqual
 Becomes more complex code-wise. Becomes less efficient execution-wise. 
 isEqual must now reduce both self and argument before comparing self and argument.
 BUT...
 Even though isEqual is now slower, the RatNum class can become more efficient:
 - If isEqual is rarely used.
 - If isEqual is called on fewer RatNum objects than there are RatNum objects created with initWithNumber. See "3. stringValue" above.
 
 6. valueOf
 Becomes less complex code-wise. Becomes more efficient execution-wise.
 In the weakened representation invariant case, valueOf doesn't need to init the return RatNum object with lowest form.
 Note that code for reducing a RatNum to lowest form would be in the initWithNumber constructor in the strong rep invariant case.
 
 
 Question 2(d)
 ========
 
 No methods (provided in te skeleton) change numer and denom such that the end result is not in lowest form.
 
 A method can change a RatNum object. For e.g.:
 
 - (void) myfun{
    numer = 99;
 }
 
 Instances of RatNum have readonly numer and readonly denom. Numer and Denom can only be changed by methods defined
 inside the implementation file, not by external functions. For e.g. numer and denom cannot be altered in main.m .
 
 Question 2(e)
 ========
 
 <Your answer here> Unable to find question 2e.
 
 Question 3(a)
 ========
 
 At the end of constructors. The representation invariant is not violated by calling any instance/class methods.
 There is no need to check after/before every instance/class method.
 
 Question 3(b)
 ========
 
 1. checkRep
 Less complex in code clarity.
 More efficient in execution.
 Because checkRep has one less condition to check thanks to the weakened representation invariant.
 
 2. stringValue
 More complex in code clarity.
 Because when extracting a string that is representative of the exponent, the code has to ensure that coefficient != 0.
 
 Question 3(c)
 ========
 
 1. checkRep
 More complex in code clarity.
 Less efficient in execution.
 Changes: add in a block of code to check the add-in invariant:
 Because checkRep has added code to check for the new restriction.
 
 2. initWithCoeff:Exp:
 Slightly more complex in code clarity.
 Slightly less efficient in execution.
 Because when coeff is NaN, expt has to be set to 0.
 
 Note:
 initNaN doesn't change because initNaN: calls initWithCoeff:Exp: for constructing a new RatTerm object.
 
 Question 3(d)
 ========
 
 I prefer having both invariants. Having both these invariants can help keep the internal representation of the class neat.
 Neat internal representations are easier to extend and build on. Developers who are new to this class will have a gentler learning curve.
 
 However, the flexibility of this class is decreased.
 For example, this class cannot store a NaN*x^74 term. But this inflexibility is justified by the rare occurrence of someone
 trying to store a NaN coeff with a non-zero exponent.
 
 Question 5: Reflection (Bonus Question)
 ==========================
 (a) How many hours did you spend on each problem of this problem set?
 
 <Your answer here>
 
 (b) In retrospect, what could you have done better to reduce the time you spent solving this problem set?
 
 <Your answer here>
 
 (c) What could the CS3217 teaching staff have done better to improve your learning experience in this problem set?
 
 <Your answer here>
 
 */
