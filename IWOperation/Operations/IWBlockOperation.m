//
//  IWBlockOperation.m
//
//  Created by Idriss on 22/07/2015.
//

#import "IWBlockOperation.h"

@interface IWBlockOperation ()

@property (nonatomic, copy) IWOperationBlock block;


@end

@implementation IWBlockOperation

- (instancetype)initWithWithBlock:(IWOperationBlock)block
{
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}


- (void)run
{
    if (self.block) {
        
        self.block(^{
            [self finish:@[]];
        });
        
    } else {
        [self finish:@[]];
    }
}


@end
