//
//  IWGroupOperation.m
//
//  Created by Idriss on 21/07/2015.
//

#import "IWGroupOperation.h"

#import "IWOperationQueue.h"
#import "IWBlockOperation.h"

@interface IWGroupOperation () <IWOperationQueueDelegate>

@property (nonatomic, strong) IWOperationQueue *internalQueue;
@property (nonatomic, strong) NSMutableArray   *aggregatedErrors;


@end

@implementation IWGroupOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _internalQueue = [[IWOperationQueue alloc] init];
        _internalQueue.qualityOfService = NSQualityOfServiceUserInitiated;
        _internalQueue.suspended = YES;
        _internalQueue.delegate  = self;
        
        _aggregatedErrors = [NSMutableArray array];
        
    }
    return self;
}

- (instancetype)initWithOperations:(NSArray*)operations
{
    self = [super init];
    if (self) {
        
        _internalQueue = [[IWOperationQueue alloc] init];
        _internalQueue.qualityOfService = NSQualityOfServiceUserInitiated;
        _internalQueue.suspended = YES;
        _internalQueue.delegate  = self;
        
        _aggregatedErrors = [NSMutableArray array];
        
        for (IWOperation *operation in operations) {
            [_internalQueue addOperation:operation];
        }
        
    }
    return self;
}


- (void)setOperations:(NSArray*)operations
{
    if (self.state == IWOperationStateCreated) {
        for (IWOperation *operation in operations) {
            [self.internalQueue addOperation:operation];
        }
    }
}

- (void)cancel
{
    [self.internalQueue cancelAllOperations];
    [super cancel];
}

-(void)addOperation:(NSOperation *)operation
{
    [self.internalQueue addOperation:operation];
}

- (void)run
{
    self.internalQueue.suspended = NO;
}

- (void)operation:(NSOperation*)operation didFinishWithErrors:(NSArray *)errors
{
    /* if subclassing is needed*/

}



#pragma mark -- Queue Delegate

- (void)operationQueue:(IWOperationQueue *)queue didFinishOperation:(NSOperation *)operation withErrors:(NSArray *)errors
{
    if (errors) {
        [self.aggregatedErrors addObjectsFromArray:errors];
    }
    
    if (queue.operationCount == 0) {
        [self finish:self.aggregatedErrors];
    } else {
        [self operation:operation didFinishWithErrors:errors];
    }
}


@end
