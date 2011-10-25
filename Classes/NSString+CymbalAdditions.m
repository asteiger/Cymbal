
@implementation NSString (CymbalAdditions)

- (NSString*)stringOrNilForBlankString {
    int strLen = [self length];
    
    if (self == nil || strLen == 0)
        return nil;
    
    return self;
}

- (NSString*)stringByRemovingSpecialCharacters {
    NSMutableString *tmp = [NSMutableString string];
    
    int strLen = [self length];
    
    for (int i = 0; i < strLen; i++) {
        unichar c = [self characterAtIndex:i];
        
        if ((c > 64 && c < 91) || (c > 96 && c < 123))
            [tmp appendFormat:@"%C", c];
    }
    
    return tmp;
}

@end