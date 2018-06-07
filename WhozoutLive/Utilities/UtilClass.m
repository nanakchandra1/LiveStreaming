//

#import "UtilClass.h"




@implementation UtilClass

+(NSString *)removeCrapFrom:(NSString *)string
{
    NSUInteger location = 0;
    unichar charBuffer[[string length]];
    [string getCharacters:charBuffer];
    int i = 0;
    for (i = [string length]; i >0; i--)
    {
        if (![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:charBuffer[i - 1]])
        {
            break;
        }
    }
    return  [string substringWithRange:NSMakeRange(location, i  - location)];
}


+(UIImage *)changeImageColor:(UIImage *)imag{
    UIImage *image = imag;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage
                                                scale:1.0 orientation: UIImageOrientationDownMirrored];
    return flippedImage;
}


+ (UIImage*)changeImageSize:(UIImage*)imag
              :(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [imag drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
