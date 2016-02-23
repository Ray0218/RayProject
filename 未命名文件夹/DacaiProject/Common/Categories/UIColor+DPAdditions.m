//
//  UIColor+DPAdditions.m
//  DacaiProject
//
//  Created by WUFAN on 14-6-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UIColor+DPAdditions.h"

const CGFloat *DPColorGetComponents(UIColor *color) {
    /**
     *
     *  + (UIColor *)blackColor;      // 0.0 white
     *  + (UIColor *)darkGrayColor;   // 0.333 white
     *  + (UIColor *)lightGrayColor;  // 0.667 white
     *  + (UIColor *)whiteColor;      // 1.0 white
     *  + (UIColor *)grayColor;       // 0.5 white
     *
     */
    if ([color isEqual:[UIColor blackColor]]) {
        static CGFloat components[] = { 0.f, 0.f, 0.f, 1.f };
        return components;
    }
    else if ([color isEqual:[UIColor darkGrayColor]]) {
        static CGFloat components[] = { 0.333f, 0.333f, 0.333f, 1.f };
        return components;
    }
    else if ([color isEqual:[UIColor lightGrayColor]]) {
        static CGFloat components[] = { 0.667f, 0.667f, 0.667f, 1.f };
        return components;
    }
    else if ([color isEqual:[UIColor whiteColor]]) {
        static CGFloat components[] = { 1.f, 1.f, 1.f, 1.f };
        return components;
    }
    else if ([color isEqual:[UIColor grayColor]]) {
        static CGFloat components[] = { 0.5f, 0.5f, 0.5f, 1.f };
        return components;
    }
    
    return CGColorGetComponents(color.CGColor);
}

@implementation UIColor (DPAdditions)

+ (UIColor *)dp_colorWithUInt8Red:(UInt8)red green:(UInt8)green blue:(UInt8)blue alpha:(UInt8)alpha {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha / 255.0];
}

+ (UIColor *)dp_colorFromRGBA:(NSUInteger)rgba {
    return [UIColor colorWithRed:((float)((rgba & 0xFF000000) >> 24)) / 255.0
                           green:((float)((rgba & 0x00FF0000) >> 16)) / 255.0
                            blue:((float)((rgba & 0x0000FF00) >> 8)) / 255.0
                           alpha:((float)((rgba & 0x000000FF) >> 0)) / 255.0];
}

+ (UIColor *)dp_colorFromRGB:(NSUInteger)rgb {
    return [UIColor colorWithRed:((float)((rgb & 0x00FF0000) >> 16)) / 255.0
                           green:((float)((rgb & 0x0000FF00) >> 8)) / 255.0
                            blue:((float)((rgb & 0x000000FF) >> 0)) / 255.0
                           alpha:1.0];
}

+ (UIColor *)dp_colorFromHexString:(NSString *)hexString {
    hexString = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"# "]];
    hexString = [hexString uppercaseString];
    
    unsigned int hexInt;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    if ([scanner scanHexInt:&hexInt]) {
        if (hexString.length == 6) {
            return [self dp_colorFromRGB:hexInt];
        }
        if (hexString.length == 8) {
            return [self dp_colorFromRGBA:hexInt];
        }
    }
    return nil;
}

+ (UIColor *)dp_oppositeColorOf:(UIColor *)mainColor {
//    
//    /**
//     *
//     *  + (UIColor *)blackColor;      // 0.0 white
//     *  + (UIColor *)darkGrayColor;   // 0.333 white
//     *  + (UIColor *)lightGrayColor;  // 0.667 white
//     *  + (UIColor *)whiteColor;      // 1.0 white
//     *  + (UIColor *)grayColor;       // 0.5 white
//     *
//     */
//    
//    if ([mainColor isEqual:[UIColor blackColor]]) {
//        mainColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//    }
//    else if ([mainColor isEqual:[UIColor darkGrayColor]]) {
//        mainColor = [UIColor colorWithRed:84.915/255.f green:84.915/255.f blue:84.915/255.f alpha:1];
//    }
//    else if ([mainColor isEqual:[UIColor lightGrayColor]]) {
//        mainColor = [UIColor colorWithRed:170.085/255.f green:170.085/255.f blue:170.085/255.f alpha:1];
//    }
//    else if ([mainColor isEqual:[UIColor whiteColor]]) {
//        mainColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
//    }
//    else if ([mainColor isEqual:[UIColor grayColor]]) {
//        mainColor = [UIColor colorWithRed:127.5/255.f green:127.5/255.f blue:127.5/255.f alpha:1];
//    }
//    
//    const CGFloat *componentColors = DPColorGetComponents(mainColor);
//    UIColor *convertedColor = [[UIColor alloc] initWithRed:(1.0 - componentColors[0])
//                                                     green:(1.0 - componentColors[1])
//                                                      blue:(1.0 - componentColors[2])
//                                                     alpha:componentColors[3]];
//    return convertedColor;
    
    const CGFloat *componentColors = DPColorGetComponents(mainColor);
    UIColor *convertedColor = [[UIColor alloc] initWithRed:(1.0 - componentColors[0])
                                                     green:(1.0 - componentColors[1])
                                                      blue:(1.0 - componentColors[2])
                                                     alpha:componentColors[3]];
    return convertedColor;
}

#pragma mark -

- (CGFloat)dp_red {
    return DPColorGetComponents(self)[0];
}

- (CGFloat)dp_green {
    return DPColorGetComponents(self)[1];
}

- (CGFloat)dp_blue {
    return DPColorGetComponents(self)[2];
}

- (CGFloat)dp_alpha {
    return CGColorGetAlpha(self.CGColor);
}

#pragma mark - flat color

+ (UIColor *)dp_coverColor {
    return [UIColor colorWithWhite:0 alpha:0.6];
}

+ (UIColor *)dp_flatWhiteColor {
    return [UIColor whiteColor];
}

+ (UIColor *)dp_flatBackgroundColor {
    return [UIColor colorWithRed:0.957 green:0.953 blue:0.937 alpha:1];
}

+ (UIColor *)dp_flatBlackColor {
    return UIColorFromRGB(0x1A1A1A);
//    return [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
}

+ (UIColor *)dp_flatRedColor {
//    return UIColorFromRGB(0xbe0201);
    return [UIColor colorWithRed:0.91 green:0.09 blue:0.1 alpha:1];
}

+ (UIColor *)dp_flatDarkRedColor {
    return UIColorFromRGB(0xbe0201);
}

+ (UIColor *)dp_flatBlueColor {
    return [UIColor colorWithRed:0.12 green:0.31 blue:0.64 alpha:1];
//    return [UIColor colorWithRed:0.12 green:0.25 blue:0.96 alpha:1];
}

+ (UIColor *)dp_flatMediumElectricBlueColor {
    return [UIColor colorWithRed:0.02 green:0.36 blue:0.6 alpha:1];
}

+ (UIColor *)dp_flatGreenColor {
    return [UIColor colorWithRed:0.09 green:0.38 blue:0.01 alpha:1];
}

@end
