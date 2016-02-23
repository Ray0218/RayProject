//
//  Limits.h
//  DacaiProject
//
//  Created by WUFAN on 14/11/18.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef DacaiProject_Limits_h
#define DacaiProject_Limits_h

#ifndef INT8_MAX
#define INT8_MAX         127
#endif

#ifndef INT16_MAX
#define INT16_MAX        32767
#endif

#ifndef INT32_MAX
#define INT32_MAX        2147483647
#endif

#ifndef INT64_MAX
#define INT64_MAX        9223372036854775807LL
#endif

#ifndef INT8_MIN
#define INT8_MIN          -128
#endif

#ifndef INT16_MIN
#define INT16_MIN         -32768
#endif

/*
 Note:  the literal "most negative int" cannot be written in C --
 the rules in the standard (section 6.4.4.1 in C99) will give it
 an unsigned type, so INT32_MIN (and the most negative member of
 any larger signed type) must be written via a constant expression.
 */
#ifndef INT32_MIN
#define INT32_MIN        (-INT32_MAX-1)
#endif

#ifndef INT64_MIN
#define INT64_MIN        (-INT64_MAX-1)
#endif

#ifndef UINT8_MAX
#define UINT8_MAX         255
#endif

#ifndef UINT16_MAX
#define UINT16_MAX        65535
#endif

#ifndef UINT32_MAX
#define UINT32_MAX        4294967295U
#endif

#ifndef UINT64_MAX
#define UINT64_MAX        18446744073709551615ULL
#endif


#endif
