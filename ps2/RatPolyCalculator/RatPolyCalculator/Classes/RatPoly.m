#import "RatPoly.h"


@implementation RatPoly

@synthesize terms;

// Note that since there is no variable called "degree" in our class,the compiler won't synthesize 
// the "getter" for "degree". and we have to write our own getter
-(int)degree{ // 5 points
    // EFFECTS: returns the degree of this RatPoly object. 
    
	//i'm just a skeleton here, do fill me up please, or
	//I'll throw an exception to remind you of my existence. muahaha
	[NSException raise:@"RatPoly degree not implemented" format:@"fill me up plz!"];
}

// Check that the representation invariant is satisfied
-(void)checkRep{ // 5 points
	//i'm just a skeleton here, do fill me up please, or
	//I'll throw an exception to remind you of my existence. muahaha
	[NSException raise:@"RatPoly checkRep not implemented" format:@"fill me up plz!"];
}

-(id)init { // 5 points
    //EFFECTS: constructs a polynomial with zero terms, which is effectively the zero polynomial
    //           remember to call checkRep to check for representation invariant
    
}

-(id)initWithTerm:(RatTerm*)rt{ // 5 points
    //  REQUIRES: [rt expt] >= 0
    //  EFFECTS: constructs a new polynomial equal to rt. if rt's coefficient is zero, constructs
    //             a zero polynomial remember to call checkRep to check for representation invariant
    
    
}

-(id)initWithTerms:(NSArray*)ts{ // 5 points
    // REQUIRES: "ts" satisfies clauses given in the representation invariant
    // EFFECTS: constructs a new polynomial using "ts" as part of the representation.
    //            the method does not make a copy of "ts". remember to call checkRep to check for representation invariant
    
    
}

-(RatTerm*)getTerm:(int)deg { // 5 points
    // REQUIRES: self != nil && ![self isNaN]
    // EFFECTS: returns the term associated with degree "deg". If no such term exists, return
    //            the zero RatTerm
    
}

-(BOOL)isNaN { // 5 points
    // REQUIRES: self != nil
    //  EFFECTS: returns YES if this RatPoly is NaN
    //             i.e. returns YES if and only if some coefficient = "NaN".
    
}


-(RatPoly*)negate { // 5 points
    // REQUIRES: self != nil 
    // EFFECTS: returns the additive inverse of this RatPoly.
    //            returns a RatPoly equal to "0 - self"; if [self isNaN], returns
    //            some r such that [r isNaN]
    
}


// Addition operation
-(RatPoly*)add:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self+p; if [self isNaN] or [p isNaN], returns
    //            some r such that [r isNaN]
    
}

// Subtraction operation
-(RatPoly*)sub:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self-p; if [self isNaN] or [p isNaN], returns
    //            some r such that [r isNaN]
    
}


// Multiplication operation
-(RatPoly*)mul:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self*p; if [self isNaN] or [p isNaN], returns
    // some r such that [r isNaN]
    
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
    
}

-(double)eval:(double)d { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: returns the value of this RatPoly, evaluated at d
    //            for example, "x+2" evaluated at 3 is 5, and "x^2-x" evaluated at 3 is 6.
    //            if [self isNaN], return NaN
    
    
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
    
}


// Builds a new RatPoly, given a descriptive String.
+(RatPoly*)valueOf:(NSString*)str { // 5 points
    // REQUIRES : 'str' is an instance of a string with no spaces that
    //              expresses a poly in the form defined in the stringValue method.
    //              Valid inputs include "0", "x-10", and "x^3-2*x^2+5/3*x+3", and "NaN".
    // EFFECTS : return a RatPoly p such that [p stringValue] = str
    
}

// Equality test
-(BOOL)isEqual:(id)obj { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: returns YES if and only if "obj" is an instance of a RatPoly, which represents
    //            the same rational polynomial as self. All NaN polynomials are considered equal
    
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
