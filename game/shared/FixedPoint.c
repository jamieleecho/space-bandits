/*
  FixedPoint.c
  
  This software is for demonstration purposes only. Use at your own
  risk.
*/


#ifndef _FixedPoint_c
#define _FixedPoint_c

#include "FixedPoint.h"
#include "cmoc.h"


/** Table holding powers of 10 */
FixedPoint FixedPointPowersOf10[] = {
  FixedPointInit(10000, 0),
  FixedPointInit(1000, 0),
  FixedPointInit(100, 0),
  FixedPointInit(10, 0),
  FixedPointInit(1, 0),
  FixedPointInit(0, 0x1999),
  FixedPointInit(0, 0x28f),
  FixedPointInit(0, 0x41),
  FixedPointInit(0, 0x6)
};

/** -1 */
FixedPoint FixedPointMinusOne = FixedPointInit(-1, 0);

/** 0 */
FixedPoint FixedPointZero = FixedPointInit(0, 0);

/** Pi */
FixedPoint FixedPointPi;

/** Pi/2 */
FixedPoint FixedPointPi_2;

/** Pi/4 */
FixedPoint FixedPointPi_4;

/** -Pi */
FixedPoint FixedPointMinusPi;

/** -Pi/2 */
FixedPoint FixedPointMinusPi_2;

/** -Pi/4 */
FixedPoint FixedPointMinusPi_4;

/** .5 */
FixedPoint FixedPointPoint5 = FixedPointInit(0, 0x8000);

/** Table holding sin coefficients */
FixedPoint FixedPointSinCoefficients[3];

/** Table holding cos coefficients */
FixedPoint FixedPointCosCoefficients[3];


void FixedPointInitialize() {
  // Initialize constants
  FixedPointParse(&FixedPointPi, "3.14159");
  FixedPointMul(&FixedPointPi_2, &FixedPointPi, &FixedPointPoint5);
  FixedPointMul(&FixedPointPi_4, &FixedPointPi_2, &FixedPointPoint5);
  FixedPointNegate(&FixedPointMinusPi, &FixedPointPi);
  FixedPointNegate(&FixedPointMinusPi_2, &FixedPointPi_2);
  FixedPointNegate(&FixedPointMinusPi_4, &FixedPointPi_4);

  // Initialize sin
  FixedPoint tmp = FixedPointInit(-6, 0);
  FixedPointDiv(&(FixedPointSinCoefficients[0]), 
		&(FixedPointPowersOf10[4]),
		&tmp);
  FixedPointSet(&tmp, 120, 0);
  FixedPointDiv(&(FixedPointSinCoefficients[1]), 
		&(FixedPointPowersOf10[4]),
		&tmp);
  FixedPointSet(&tmp, -5040, 0);
  FixedPointDiv(&(FixedPointSinCoefficients[2]), 
		&(FixedPointPowersOf10[4]),
		&tmp);

  // Initialize cos
  FixedPointSet(&tmp, -2, 0);
  FixedPointDiv(&FixedPointCosCoefficients[0],
 		&(FixedPointPowersOf10[4]), &tmp);
  FixedPointSet(&tmp, 24, 0);
  FixedPointDiv(&FixedPointCosCoefficients[1],
 		&(FixedPointPowersOf10[4]), &tmp);
  FixedPointSet(&tmp, -720, 0);
  FixedPointDiv(&FixedPointCosCoefficients[2],
 		&(FixedPointPowersOf10[4]), &tmp);
}


asm void FixedPointSet(FixedPoint *c, int whole, unsigned decimal) {
  asm {
    ldx     2,s             variable c
    ldd     4,s             variable whole
    std     ,x
    ldd     6,s             variable decimal
    std     2,x
  }
}


asm void FixedPointNegate(FixedPoint *c, FixedPoint *a) {
  asm {
* Transfer *a into *c
    ldy 4,s
    ldx 2,s
    ldd ,y
    std ,x
    ldd 2,y
    std 2,x

    neg 3,x
    bcs FixedPointNegateCom2
    neg 2,x
    bcs FixedPointNegateCom1
    neg 1,x
    bcs FixedPointNegateCom0
    neg ,x
    bra FixedPointNegateDone

FixedPointNegateCom2:
    com 2,x
FixedPointNegateCom1:
    com 1,x
FixedPointNegateCom0:
    com ,x
FixedPointNegateDone:
  }  
}


asm void FixedPointAdd(FixedPoint *c, FixedPoint *a, FixedPoint *b) {
  asm {
    pshs u
    ldx 6,s
    ldy 4,s
    ldu 8,s
    
    lda 3,x
    adda 3,u
    sta 3,y
    lda 2,x
    adca 2,u
    sta 2,y
    lda 1,x
    adca 1,u
    sta 1,y
    lda ,x
    adca ,u
    sta ,y

    puls u
  }
}


void FixedPointSub(FixedPoint *c, FixedPoint *a, FixedPoint *b) {
  FixedPoint tmp;
  FixedPointNegate(&tmp, b);
  FixedPointAdd(c, a, &tmp);
}


void FixedPointMul(FixedPoint *c, FixedPoint *a, FixedPoint *b) {
  byte results[8], aa[4], bb[4];
  memset(results, 0, sizeof(results));

  // Convert all operands to positive, count number of negates
  byte numNegatives = 0;
  if (a->Whole < 0x0) {
    FixedPointNegate((FixedPoint *)aa, a);
    numNegatives++;
  } else
    memcpy(aa, (byte *)a, sizeof(aa));
  if (b->Whole < 0x0) {
    FixedPointNegate((FixedPoint *)bb, b);
    numNegatives++;
  } else
    memcpy(bb, (byte *)b, sizeof(bb));

  asm {
    leax aa
    leay bb
    pshs u
    leau results

* Multiply first byte of y
    lda 3,x
    ldb 3,y
    mul
    std 6,u

    lda 2,x
    ldb 3,y
    mul
    addd 5,u
    std 5,u
    lbsr FixedPointMulCarry4

    lda 1,x
    ldb 3,y
    mul
    addd 4,u
    std 4,u
    lbsr FixedPointMulCarry3

    lda ,x
    ldb 3,y
    mul
    addd 3,u
    std 3,u
    lbsr FixedPointMulCarry2

* Multiply second byte of y
    lda 3,x
    ldb 2,y
    mul
    addd 5,u
    std 5,u
    lbsr FixedPointMulCarry4

    lda 2,x
    ldb 2,y
    mul
    addd 4,u
    std 4,u
    lbsr FixedPointMulCarry3

    lda 1,x
    ldb 2,y
    mul
    addd 3,u
    std 3,u
    lbsr FixedPointMulCarry2

    lda ,x
    ldb 2,y
    mul
    addd 2,u
    std 2,u
    lbsr FixedPointMulCarry1

* Multiply third byte of y
    lda 3,x
    ldb 1,y
    mul
    addd 4,u
    std 4,u
    bsr FixedPointMulCarry3

    lda 2,x
    ldb 1,y
    mul
    addd 3,u
    std 3,u
    bsr FixedPointMulCarry2

    lda 1,x
    ldb 1,y
    mul
    addd 2,u
    std 2,u
    bsr FixedPointMulCarry1

    lda ,x
    ldb 1,y
    mul
    addd 1,u
    std 1,u
    bsr FixedPointMulCarry0

* Multiply fourth byte of y
    lda 3,x
    ldb ,y
    mul
    addd 3,u
    std 3,u
    bsr FixedPointMulCarry2

    lda 2,x
    ldb ,y
    mul
    addd 2,u
    std 2,u
    bsr FixedPointMulCarry1

    lda 1,x
    ldb ,y
    mul
    addd 1,u
    std 1,u
    bsr FixedPointMulCarry0

    lda ,x
    ldb ,y
    mul
    addd ,u
    std ,u

    bra FixedPointMulAsmDone

*******************************************************************************
* Routine for performing carry results on product
*******************************************************************************
FixedPointMulCarry8:
    bcc FixedPointMulCarryDone
    lda 8,u
    adda #1
    sta 8,u
FixedPointMulCarry7:
    bcc FixedPointMulCarryDone
    lda 7,u
    adda #1
    sta 7,u
FixedPointMulCarry6:
    bcc FixedPointMulCarryDone
    lda 6,u
    adda #1
    sta 6,u
FixedPointMulCarry5:
    bcc FixedPointMulCarryDone
    lda 5,u
    adda #1
    sta 5,u
FixedPointMulCarry4:
    bcc FixedPointMulCarryDone
    lda 4,u
    adda #1
    sta 4,u
FixedPointMulCarry3:
    bcc FixedPointMulCarryDone
    lda 3,u
    adda #1
    sta 3,u
FixedPointMulCarry2:
    bcc FixedPointMulCarryDone
    lda 2,u
    adda #1
    sta 2,u
FixedPointMulCarry1:
    bcc FixedPointMulCarryDone
    lda 1,u
    adda #1
    sta 1,u
FixedPointMulCarry0:
    bcc FixedPointMulCarryDone
    lda ,u
    adda #1
    sta ,u
FixedPointMulCarryDone:
    rts

*******************************************************************************
* Invoked when calculation is complete
*******************************************************************************
FixedPointMulAsmDone:
    puls u
  }

  // Make result negative if needed
  c->Whole = ((int)results[2] << 8) + results[3];
  c->Fraction = ((unsigned)results[4] << 8) + results[5];
  if (numNegatives & 1)
    FixedPointNegate(c, c);
}


void FixedPointDiv(FixedPoint *c, FixedPoint *a, FixedPoint *b) {
  // aa[0] = dividend, aa[1] = divisor, aa[2] = quotient
  FixedPoint aa[3];
  char numDivisorShifts = 0, numDividendShifts = 0;
  memset((byte *)(aa + 2), 0, sizeof(aa[2]));

  // Convert all operands to positive, count number of negates
  byte numNegatives = 0;
  if (a->Whole < 0x0) {
    FixedPointNegate(aa, a);
    numNegatives++;
  } else
    memcpy((byte *)aa, (byte *)a, sizeof(aa[0]));
  if (b->Whole < 0x0) {
    FixedPointNegate((aa + 1), b);
    numNegatives++;
  } else
    memcpy((byte *)(aa + 1), (byte *)b, sizeof(aa[1]));

  // Can't divide by zero, set to big value
  if ((aa[1].Whole == 0) && (aa[1].Fraction == 0)) {
    c->Whole = 0x7fff;
    c->Fraction = 0xffff;
    if (numNegatives & 1)
      FixedPointNegate(c, c);
    return;
  }

  // Result is zero, so return 0
  if ((aa[0].Whole == 0) && (aa[0].Fraction == 0)) {
    memset(c, 0, sizeof(*c));
    return;
  }

  // Note to self: Never ever do a div routine again
  asm {
* The first thing we have to do is shift the divisor left until its most
* significant bit is 1
    leax aa
FixedPointDivCheckDivisor:
    lda 4,x
    bmi FixedPointDivFixDividend
    asl 7,x
    rol 6,x
    rol 5,x
    rol 4,x
    inc numDivisorShifts
    bra FixedPointDivCheckDivisor

* We now have to fix the dividend so that its most significant bit is 1
FixedPointDivFixDividend:
    lda ,x    
    bmi FixedPointDivMainSetup
    asl 3,x
    rol 2,x
    rol 1,x
    rol ,x
    inc numDividendShifts
    bra FixedPointDivFixDividend

* At this point our divisor and dividend are shift all the way left.
* We must do the following while we have more quotient bits
* 1. If the most significant bits of the divisor
*     <= most significant bits of the dividend
*          a. Put 1 in the quotient
*     else
*          a. Put 0 in the quotient
*          b. If we have more quotient bits left, shift dividend left
*          c. Put 1 in the quotient
* 2. subtract most signficant divisor bits from most significant dividend bits       
* 3. while we have more quotient bits and there is a zero in the dividend
*          a. Shift the quotient left
*          b. Shift the dividend left
FixedPointDivMainSetup:
    ldb #16      * B = max number of loops
    subb numDividendShifts
    addb numDivisorShifts    

    tstb
    ble FixedPointDivMainLoopEnd
    incb

FixedPointDivMainLoop:
* Compare dividend to divisor
    bsr FixedPointDivCompareDividendToDivisor

* Branch if dividend too small
    blo FixedPointDivDividendTooSmall
    bra FixedPointDivPut1InQuotient

FixedPointDivDividendTooSmall:
    decb
    beq FixedPointDivMainLoopEnd
    bsr FixedPointDivShiftDividendLeft
    bsr FixedPointDivShiftQuotientLeft

FixedPointDivPut1InQuotient:
* Put 1 in quotient, subtract divisor from dividend
    lda #1
    ora 11,x
    sta 11,x

FixedPointDivSubtractAndShift:
    bsr FixedPointDivSubtractDivisorFromDividend

FixedPointDivMainLoopRepeat:
    lda ,x
    bmi FixedPointDivMainLoop

    decb
    beq FixedPointDivMainLoopEnd

    bsr FixedPointDivShiftDividendLeft
    bsr FixedPointDivShiftQuotientLeft
    bra FixedPointDivMainLoopRepeat

FixedPointDivShiftQuotientLeft:
    asl 11,x
    rol 10,x
    rol 9,x
    rol 8,x
    rts

FixedPointDivShiftDividendLeft:
    asl 3,x
    rol 2,x
    rol 1,x
    rol ,x
    rts

FixedPointDivCompareDividendToDivisor:
    lda ,x 
    cmpa 4,x
    bne FixedPointDivCompareDividendToDivisorDone
    lda 1,x 
    cmpa 5,x
    bne FixedPointDivCompareDividendToDivisorDone
    lda 2,x 
    cmpa 6,x
    bne FixedPointDivCompareDividendToDivisorDone
    lda 3,x 
    cmpa 7,x
FixedPointDivCompareDividendToDivisorDone:
    rts

FixedPointDivSubtractNegateDivisor:
    neg 7,x
    bcs FixedPointDivSubtractNegateDivisorCom2
    neg 6,x
    bcs FixedPointDivSubtractNegateDivisorCom1
    neg 5,x
    bcs FixedPointDivSubtractNegateDivisorCom0
    neg 4,x
    rts

FixedPointDivSubtractNegateDivisorCom2:
    com 6,x
FixedPointDivSubtractNegateDivisorCom1:
    com 5,x
FixedPointDivSubtractNegateDivisorCom0:
    com 4,x
    rts

FixedPointDivSubtractDivisorFromDividend:
    bsr FixedPointDivSubtractNegateDivisor
    lda 7,x
    adda 3,x
    sta 3,x
    lda 6,x
    adca 2,x
    sta 2,x
    lda 5,x
    adca 1,x
    sta 1,x
    lda 4,x
    adca ,x
    sta ,x
    bsr FixedPointDivSubtractNegateDivisor
    rts

FixedPointDivMainLoopEnd:
  }

  // Transfer data, making result negative if needed
  if (numNegatives & 1) {
    FixedPointNegate(c, aa + 2);
  } else {
    memcpy((byte *)c, (byte *)(aa + 2), sizeof(aa[2]));
  }
}


void FixedPointMod(FixedPoint *c, FixedPoint *d, FixedPoint *a, FixedPoint *b) {
  // aa[0] = dividend, aa[1] = divisor, aa[2] = quotient
  FixedPoint aa[3];
  char numDivisorShifts = 0, numDividendShifts = 0, numTotalShifts;
  memset((byte *)(aa + 2), 0, sizeof(aa[2]));

  // Convert all operands to positive, count number of negates
  byte numNegatives = 0;
  if (a->Whole < 0x0) {
    FixedPointNegate(aa, a);
    numNegatives++;
  } else
    memcpy((byte *)aa, (byte *)a, sizeof(aa[0]));
  if (b->Whole < 0x0) {
    FixedPointNegate((aa + 1), b);
    numNegatives++;
  } else
    memcpy((byte *)(aa + 1), (byte *)b, sizeof(aa[1]));

  // Can't divide by zero, set to big value
  if ((aa[1].Whole == 0) && (aa[1].Fraction == 0)) {
    c->Whole = 0x7fff;
    c->Fraction = 0xffff;
    if (numNegatives & 1)
      FixedPointNegate(c, c);
    return;
  }

  // Result is zero, so return 0
  if ((aa[0].Whole == 0) && (aa[0].Fraction == 0)) {
    memset(c, 0, sizeof(*c));
    return;
  }

  // Note to self: Never ever do a div routine again
  asm {
* The first thing we have to do is shift the divisor left until its most
* significant bit is 1
    leax aa
FixedPointModCheckDivisor:
    lda 4,x
    bmi FixedPointModFixDividend
    asl 7,x
    rol 6,x
    rol 5,x
    rol 4,x
    inc numDivisorShifts
    bra FixedPointModCheckDivisor

* We now have to fix the dividend so that its most significant bit is 1
FixedPointModFixDividend:
    lda ,x    
    bmi FixedPointModMainSetup
    asl 3,x
    rol 2,x
    rol 1,x
    rol ,x
    inc numDividendShifts
    bra FixedPointModFixDividend

* At this point our divisor and dividend are shift all the way left.
* We must do the following while we have more quotient bits
* 1. If the most significant bits of the divisor
*     <= most significant bits of the dividend
*          a. Put 1 in the quotient
*     else
*          a. Put 0 in the quotient
*          b. If we have more quotient bits left, shift dividend left
*          c. Put 1 in the quotient
* 2. subtract most signficant divisor bits from most significant dividend bits       
* 3. while we have more quotient bits and there is a zero in the dividend
*          a. Shift the quotient left
*          b. Shift the dividend left
FixedPointModMainSetup:
    ldb #16      * B = max number of loops
    subb numDividendShifts
    addb numDivisorShifts    
    stb numTotalShifts    
    subb #15
    
    lble FixedPointModMainLoopEnd
    inc numTotalShifts

FixedPointModMainLoop:
* Compare dividend to divisor
    lbsr FixedPointDivCompareDividendToDivisor

* Branch if dividend too small
    blo FixedPointModDividendTooSmall
    bra FixedPointModPut1InQuotient

FixedPointModDividendTooSmall:
    dec numTotalShifts    
    decb
    beq FixedPointModMainLoopEnd
    lbsr FixedPointDivShiftDividendLeft
    lbsr FixedPointDivShiftQuotientLeft

FixedPointModPut1InQuotient:
* Put 1 in quotient, subtract divisor from dividend
    lda #1
    ora 11,x
    sta 11,x

FixedPointModSubtractAndShift:
    lbsr FixedPointDivSubtractDivisorFromDividend

FixedPointModMainLoopRepeat:
    lda ,x
    bmi FixedPointModMainLoop

    dec numTotalShifts    
    decb
    beq FixedPointModMainLoopEnd

    lbsr FixedPointDivShiftDividendLeft
    lbsr FixedPointDivShiftQuotientLeft
    bra FixedPointModMainLoopRepeat

* Shift the quotient into the proper place
FixedPointModMainLoopEnd:
    ldb numTotalShifts
    beq FixedPointModMainLoopEnd3
FixedPointModMainLoopEnd2:
    lbsr FixedPointDivShiftQuotientLeft
    decb
    bne FixedPointModMainLoopEnd2

* Shift the remainder into the proper place
FixedPointModMainLoopEnd3:
    ldb #16
    addb numDivisorShifts    
    subb numTotalShifts
    beq FixedPointModMainLoopEnd5
FixedPointModMainLoopEnd4:
    asr ,x
    ror 1,x
    ror 2,x
    ror 3,x
    lda #$7f
    anda ,x
    sta ,x
    decb
    bne FixedPointModMainLoopEnd4
   
FixedPointModMainLoopEnd5:
  }

  // Transfer data, making result negative if needed
  if (numNegatives & 1) {
    FixedPointNegate(d, aa);
    FixedPointNegate(c, aa + 2);
  } else {
    memcpy((byte *)c, (byte *)(aa + 2), sizeof(aa[2]));
    memcpy((byte *)d, (byte *)(aa), sizeof(aa[0]));
  }

  return;

  // Force FixedPointDiv to not get optimized away
  FixedPointDiv(&aa[0], &aa[0], &aa[0]);
}


byte FixedPointEquals(FixedPoint *a, FixedPoint *b) {
  return (a->Whole == b->Whole) && (a->Fraction == b->Fraction);
}


byte FixedPointGreaterThan(FixedPoint *a, FixedPoint *b) {
  if (a->Whole > b->Whole) return TRUE;
  if (a->Whole < b->Whole) return FALSE;
  return (a->Whole >= 0) ? (a->Fraction > b->Fraction)
    : (b->Fraction > a->Fraction);
}


byte FixedPointLessThan(FixedPoint *a, FixedPoint *b) {
  if (a->Whole < b->Whole) return TRUE;
  if (a->Whole > b->Whole) return FALSE;
  return (a->Whole >= 0) ? (a->Fraction < b->Fraction)
    : (b->Fraction < a->Fraction);
}


byte FixedPointGreaterThanOrEqualTo(FixedPoint *a, FixedPoint *b) {
  if (a->Whole > b->Whole) return TRUE;
  if (a->Whole < b->Whole) return FALSE;
  return (a->Whole >= 0) ? (a->Fraction >= b->Fraction)
    : (b->Fraction >= a->Fraction);
}


byte FixedPointLessThanOrEqualTo(FixedPoint *a, FixedPoint *b) {
  if (a->Whole < b->Whole) return TRUE;
  if (a->Whole > b->Whole) return FALSE;
  return (a->Whole >= 0) ? (a->Fraction <= b->Fraction)
    : (b->Fraction <= a->Fraction);
}


FixedPoint *FixedPointCopy(FixedPoint *b, FixedPoint *a) {
  memcpy((byte *)b, (byte *)a, sizeof(*a));
  return b;
}


char *FixedPointToA(char *buffer, FixedPoint *a) {
  // Note that this algorithm uses mod. It is probably more
  // efficient to multiply by the reciprocal to get the digit
  // and due a FixedPoint / integer multiply and subtract to
  // get the remainder.

  FixedPoint quotient, remainder;
  byte powerIndex = 0;
  char *startBuffer = buffer;

  // Deal with negatives
  byte isNegative = (a->Whole < 0);
  if (isNegative) {
    FixedPointNegate(&remainder, a);
    *buffer++ = '-';
  } else {
    FixedPointCopy(&remainder, a);
  }

  // Output the whole part
  for(byte ii=0; ii<5; ii++) {
    FixedPointMod(&quotient, &remainder, &remainder,
		  FixedPointPowersOf10 + powerIndex);
    *buffer++ = '0' + (byte)quotient.Whole;
    powerIndex++;
  }

  // Deal with the fractional part
  if (remainder.Fraction != 0) {
    *buffer++ = '.';
    for(byte ii=0; ii<4; ii++) {
      FixedPointMod(&quotient, &remainder, &remainder,
		    FixedPointPowersOf10 + powerIndex);
      
      // Deal with round off error.
      if (quotient.Whole > 9) {
	// This becomes 0 and we carry 1 all the way up
	quotient.Whole = 0;
	for(char *ptr = buffer - 1; ptr >= startBuffer; ptr--) {
	  char c = *ptr;
	  if ((c == '.') || (c == '-')) continue;
	  c = c + 1;
	  if (c <= '9') {
	    *ptr = c;
	    break;
	  }
	  
	  c = '0';
	  *ptr = c;
	}
      }
      
      *buffer++ = '0' + (byte)quotient.Whole;
      powerIndex++;
    }

    // Rewind buffer to the point to the last non-zero char
    for(buffer--; (buffer > startBuffer) && (*buffer == '0'); buffer--);
    buffer += (*buffer == '.') ? 0 : 1;
  }
  
  // Find the first non-zero char
  char *ptr = startBuffer;
  char *ptr2 = buffer - 1;
  for(; (ptr < ptr2) && (*ptr == '0' || *ptr == '-'); ptr++);
  if (*ptr == '.') ptr--; // make sure we show 0.1 not .1

  // Copy the text to the beginning
  byte numChars = (byte)(buffer - ptr);
  if (isNegative) {
    memcpy(startBuffer + 1, ptr, numChars);
    startBuffer[numChars + 1] = '\0';  
    return startBuffer + numChars;
  } else {
    memcpy(startBuffer, ptr, numChars);
    startBuffer[numChars] = '\0';
    return startBuffer + numChars - 1;
  }
}


void FixedPointParse(FixedPoint *a, char *buffer) {
  // Zero out a by default
  FixedPointSet(a, 0, 0);

  // Skip any whitespace in buffer
  char c;
  for(c = *buffer++; (c == ' ' || c == '\t' || c=='\0'); c = *buffer++);
  if (c == '\0') return;

  // First char may be + or -
  byte resultIsNegative = FALSE;
  if (c == '-') {
    resultIsNegative = TRUE;
  } else if (c == '+') {
  } else if (c == '\0') {
    return;
  } else {
    buffer--;
  }

  // Go through each character adding the digits
  byte sawDecimalPoint = FALSE;
  int powerIndex = 5;
  FixedPoint tmp;
  for(c = *buffer++; ((c >= '0' && c <= '9') || (c == '.')) ; c = *buffer++) {
    if (c == '.') {
      if (sawDecimalPoint) break;
      sawDecimalPoint = TRUE;
      continue;
    }

    FixedPointSet(&tmp, c - '0', 0);
    if (sawDecimalPoint) {
      FixedPointMul(&tmp, &tmp, FixedPointPowersOf10 + powerIndex);
      FixedPointAdd(a, a, &tmp);
      powerIndex++;
      if (powerIndex >= sizeof(FixedPointPowersOf10)/sizeof(FixedPointPowersOf10[0]))
	break;
    } else {
      FixedPointMul(a, a, FixedPointPowersOf10 + 3);
      FixedPointAdd(a, a, &tmp);
    }    
  }  

  if (resultIsNegative)
    FixedPointNegate(a, a);
}


void FixedPointSqrt(FixedPoint *a, FixedPoint *b) {
  // Can't deal with negatives :(
  if (b->Whole < 0) {
    FixedPointSet(a, 0x7fff, 0xffff);
    return;
  }

  // Make sure zero is exact
  if ((b->Whole == 0) && (b->Fraction == 0)) {
    FixedPointSet(a, 0x0, 0x0);
    return;
  }

  // Compute a good estimate for the square root of b. The basic idea is to
  // approximate log base 2, divide that result by 2 and then raise that to the
  // power of 2.
  int whole;
  unsigned fraction;
  byte numBits = 0;
  if (b->Whole > 0) {
    whole = b->Whole;
    fraction = 0;
    do {
      numBits++;
      whole = whole >> 1;
    } while(whole > 0);
   numBits = 1 + (numBits >> 1);
    whole = 1 << numBits;
  } else {
    whole = 0;
    fraction = b->Fraction;
    while((fraction & 0x8000) == 0x0) {
      numBits++;
      fraction = fraction << 1;
    }
    numBits = (numBits >> 1);
    fraction = (unsigned)0x8000 >> numBits;
  }

  // Use Newton Rhapson to compute sqrt
  FixedPointSet(a, whole, fraction);
  FixedPoint c;
  for(byte ii=0; ii<4; ii++) {
    FixedPointDiv(&c, b, a);
    FixedPointAdd(&c, &c, a);    
    FixedPointMul(a, &c, &FixedPointPoint5);
  }
}


void FixedPointSin(FixedPoint *a, FixedPoint *b) {
  // If b is negative, make it positive and reverse the result later
  FixedPoint newb;
  byte negateAnswer;
  if (FixedPointLessThan(b, &FixedPointZero)) {
    FixedPointNegate(&newb, b);
    negateAnswer = TRUE;
  } else {
    memcpy(&newb, b, sizeof(newb));
    negateAnswer = FALSE;
  }

  // If newb is greater than pi/2, then figure out the quadrant
  FixedPoint tmp;
  if (FixedPointGreaterThan(&newb, &FixedPointPi_2)) {
    FixedPointMod(&tmp, &newb, &newb, &FixedPointPi_2);
    byte quadrant = (byte)(tmp.Whole & 3);

    if (quadrant == 1) {
      FixedPointSub(&newb, &FixedPointPi_2, &newb);
    } else if (quadrant == 2) {
      negateAnswer = negateAnswer ^ TRUE;
    } else if (quadrant == 3) {
      FixedPointSub(&newb, &FixedPointPi_2, &newb);
      negateAnswer = negateAnswer ^ TRUE;
    }
  }

  // x - 
  FixedPoint bb, bbb;
  memcpy(a, &newb, sizeof(newb));

  // x^3/6 + 
  FixedPointMul(&bb, &newb, &newb);
  FixedPointMul(&bbb, &bb, &newb);
  FixedPointMul(&tmp, &bbb, &(FixedPointSinCoefficients[0]));
  FixedPointAdd(a, a, &tmp);

  // x^5/120 -
  FixedPointMul(&bbb, &bb, &bbb);
  FixedPointMul(&tmp, &bbb, &(FixedPointSinCoefficients[1]));
  FixedPointAdd(a, a, &tmp);

  // x^7/5040
  FixedPointMul(&bbb, &bb, &bbb);
  FixedPointMul(&tmp, &bbb, &(FixedPointSinCoefficients[2]));
  FixedPointAdd(a, a, &tmp);

  if (negateAnswer)
    FixedPointNegate(a, a);
}


void FixedPointCos(FixedPoint *a, FixedPoint *b) {
  // If b is negative, make it positive and reverse the result later
  FixedPoint newb;
  if (FixedPointLessThan(b, &FixedPointZero)) {
    FixedPointNegate(&newb, b);
  } else {
    memcpy(&newb, b, sizeof(newb));
  }

  // If newb is greater than pi/2, then figure out the quadrant
  FixedPoint tmp;  
  byte negateAnswer;
  if (FixedPointGreaterThan(&newb, &FixedPointPi_2)) {
    FixedPointMod(&tmp, &newb, &newb, &FixedPointPi_2);
    byte quadrant = (byte)(tmp.Whole & 3);

    if (quadrant == 1) {
      FixedPointSub(&newb, &FixedPointPi_2, &newb);
      negateAnswer = TRUE;
    } else if (quadrant == 2) {
      negateAnswer = TRUE;
    } else if (quadrant == 3) {
      FixedPointSub(&newb, &FixedPointPi_2, &newb);
      negateAnswer = FALSE;
    } else {
      negateAnswer = FALSE;
    }

  } else {
    negateAnswer = FALSE;
  }

  // 1 -
  FixedPoint bb;
  memcpy(a, &(FixedPointPowersOf10[4]), sizeof(tmp));

  // b^2/2 + 
  FixedPointMul(&bb, &newb, &newb);
  FixedPointMul(&tmp, &bb, &(FixedPointCosCoefficients[0]));
  FixedPointAdd(a, a, &tmp);

  // b^4/24 -
  FixedPointMul(&newb, &bb, &bb);
  FixedPointMul(&tmp, &newb, &(FixedPointCosCoefficients[1]));
  FixedPointAdd(a, a, &tmp);

  // b^6/720
  FixedPointMul(&newb, &newb, &bb);
  FixedPointMul(&tmp, &newb, &(FixedPointCosCoefficients[2]));
  FixedPointAdd(a, a, &tmp);

  if (negateAnswer)
    FixedPointNegate(a, a);
}


#endif
