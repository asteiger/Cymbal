#import "NSNetService+TXTRecord.h"

@implementation NSNetService (TXTRecord)

- (NSString*)stringFromTXTRecordForKey:(NSString*)key {
    NSData *txtRecordData = [self TXTRecordData];
    NSDictionary *txtDict = [NSNetService dictionaryFromTXTRecordData:txtRecordData];
    
    NSData *dataFromTXTRecordKey = [txtDict objectForKey:key];
    NSString *dataAsString = [[NSString alloc] initWithData:dataFromTXTRecordKey encoding:NSUTF8StringEncoding];
    
    return [dataAsString autorelease];
}

@end
