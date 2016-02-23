@import UIKit;

@interface UIImage (ImageEffects)

- (UIImage *)xt_applyLightEffect;
- (UIImage *)xt_applyExtraLightEffect;
- (UIImage *)xt_applyDarkEffect;
- (UIImage *)xt_applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)xt_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
