@implementation NSMutableArray (QueueAdditions)

- (id) dequeue {
    if ([self count] == 0) return nil;
    id headObject = [self objectAtIndex:0];
    if (headObject != nil) {
        [[headObject retain] autorelease];
        [self removeObjectAtIndex:0];
    }
    return headObject;
}

- (void) enqueue:(id)anObject {
    [self addObject:anObject];
}
@end