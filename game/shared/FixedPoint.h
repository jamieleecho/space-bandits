/*
  FixedPoint.h
  
  This software is for demonstration purposes only. Use at your own
  risk.
*/


#ifndef _FixedPoint_h
#define _FixedPoint_h


/** FixedPoint data structure */
typedef struct FixedPoint {
  /** Whole part */
  int Whole;

  /** Fractional Part */
  unsigned Fraction;
} FixedPoint;


/** Must be invoked before using other FixedPoint functions. */
void FixedPointInitialize();


/** 
 * For initializing FixedPoint numbers.
 * @param w[in] whole part
 * @param f[in] fractional part
 */
#define FixedPointInit(w, f) { (w), (f) }

/** 
 * Initize the FixedPoint number to pi
 */
#define FixedPointInitPi() { 3, 0x2434 }

/** 
 * Initize the FixedPoint number to -pi
 */
#define FixedPointInitMinusPi() { 0xfffc, 0xdbcc }

/** 
 * Initize the FixedPoint number to pi/2
 */
#define FixedPointInitPiOver2() { 1, 0x9210 }

/** 
 * Initize the FixedPoint number to -pi/2
 */
#define FixedPointInitMinusPiOver2() { 0xfffe, 0x6df0 }

/** 
 * Initize the FixedPoint number to e
 */
#define FixedPointInitE() { 2, 0xb7d2 }

/**
 * Returns a new FixedPoint containing whole.fraction
 * @param c[out] whole.fraction
 * @param whole[in] whole
 * @param decimal[in] fraction
 */
void FixedPointSet(FixedPoint *c, int whole, unsigned decimal);


/**
 * @param c[out] -input
 * @param a[in] input
 */
void FixedPointNegate(FixedPoint *c, FixedPoint *a);


/**
 * Returns *a + *b
 * @param c[out] sum
 * @param a[in] addened 1
 * @param b[in] addened 2
 */
void FixedPointAdd(FixedPoint *c, FixedPoint *a, FixedPoint *b);


/**
 * Returns *a - *b
 * @param c[out] difference
 * @param a[in] minuend
 * @param b[in] subtrahend
 */
void FixedPointSub(FixedPoint *c, FixedPoint *a, FixedPoint *b);


/**
 * Returns *a * *b
 * @param c[out] product
 * @param a[in] multiplicand
 * @param b[in] multiplicand
 */
void FixedPointMul(FixedPoint *c, FixedPoint *a, FixedPoint *b);


/**
 * Returns *a / *b
 * @param c[out] quotient
 * @param a[in] dividend
 * @param b[in] divisor
 */
void FixedPointDiv(FixedPoint *c, FixedPoint *a, FixedPoint *b);


/**
 * Returns *a / *b and *a % *b
 * @param c[out] quotient
 * @param d[out] mod
 * @param a[in] dividend
 * @param b[in] divisor
 */
void FixedPointMod(FixedPoint *c, FixedPoint *d, FixedPoint *a, FixedPoint *b);


/**
 * Returns *a == *b
 * @param a[in] arg1
 * @param b[in] arg2
 * @return *a == *b
 */
byte FixedPointEquals(FixedPoint *a, FixedPoint *b);

/**
 * Returns *a > *b
 * @param a[in] arg1
 * @param b[in] arg2
 * @return *a > *b
 */
byte FixedPointGreaterThan(FixedPoint *a, FixedPoint *b);

/**
 * Returns *a < *b
 * @param a[in] arg1
 * @param b[in] arg2
 * @return *a < *b
 */
byte FixedPointLessThan(FixedPoint *a, FixedPoint *b);

/**
 * Returns *a >= *b
 * @param a[in] arg1
 * @param b[in] arg2
 * @return *a >= *b
 */
byte FixedPointGreaterThanOrEqualTo(FixedPoint *a, FixedPoint *b);

/**
 * Returns *a <= *b
 * @param a[in] arg1
 * @param b[in] arg2
 * @return *a <= *b
 */
byte FixedPointLessThanOrEqualTo(FixedPoint *a, FixedPoint *b);

/**
 * Copies a to b.
 * @param b[out] destination
 * @param a[in] source
 * @return b
 */
FixedPoint *FixedPointCopy(FixedPoint *b, FixedPoint *a);

/**
 * Creates an ascii decimal version of a.
 * @param buffer[out] output buffer of at least 12 bytes
 * @param a[in] input
 */
char *FixedPointToA(char *buffer, FixedPoint *a);

/**
 * Parses buffer into a FixedPoint value.
 * @param a[out] output parsed result
 * @param buffer[in] input
 */
void FixedPointParse(FixedPoint *a, char *buffer);


/**
 * Returns the square root of b
 * @param a[out] square root of b (must not be an alias of b)
 * @param b[in] input value
 */
void FixedPointSqrt(FixedPoint *a, FixedPoint *b);


/**
 * Computes sin(b)
 * @param a[out] sin(b)
 * @param b[in] input value
 */
void FixedPointSin(FixedPoint *a, FixedPoint *b);


/**
 * Computes cos(b)
 * @param a[out] cos(b)
 * @param b[in] input value
 */
void FixedPointCos(FixedPoint *a, FixedPoint *b);


#endif
