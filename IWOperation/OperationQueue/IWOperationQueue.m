//
//  IWOperationQueue.m
//
//  Created by Idriss on 15/07/2015.
//

#import "IWOperationQueue.h"
#import "IWExclusivityController.h"

#import "IWOperation.h"
#import "IWConditionOperationProtocol.h"
#import "IWOperationBlockObserver.h"

@implementation IWOperationQueue

- (void)addOperation:(nonnull NSOperation *)operation
{
    if ([operation isKindOfClass:[IWOperation class]]) {

        IWOperation *op = (IWOperation*)operation;

        //__weak IWOperationQueue *weakSelf = self;
        
        IWOperationBlockObserver *observer = [[IWOperationBlockObserver alloc] initWithStartBlock:^(IWOperation *operation) {
            [self didStartOperation:op];
        }
                                                                                   andFinishBlock:^(IWOperation *operation, NSArray *errors) {
                                                                                       [self didFinishOperation:op
                                                                                                         withErrors:errors];
                                                                                   }];
        
        [op addObserver:observer];
        
        
        NSMutableArray *mutexClasses = [NSMutableArray new];
        
        for (IWOperation<IWConditionOperationProtocol> *condition in op.conditions) {
            [op addDependency:condition];
            [super addOperation:condition];
            
            if ([condition isMutuallyExclusive]) {
                [mutexClasses addObject:condition.name];
            }
        }
        
        /* Mutual exclusion */
        if ([mutexClasses count] > 0) {
            
            IWExclusivityController *mutexController = [IWExclusivityController defaultExclusivityController];
            [mutexController addOperation:op
                           withCategories:mutexClasses];
            
            IWOperationBlockObserver *mutexObserver = [[IWOperationBlockObserver alloc] initWithStartBlock:nil
                                                                                            andFinishBlock:^(IWOperation *operation, NSArray *errors) {
                                                                                                [mutexController removeOperation:op
                                                                                                                  withCategories:mutexClasses];
                                                                                            }];
            [op addObserver:mutexObserver];
            
        }
        
        
        [super addOperation:op];
        
    } else {
        
        [super addOperation:operation];
    }
}

- (void)didStartOperation:(NSOperation*)operation
{

}

- (void)didFinishOperation:(NSOperation*)operation withErrors:(NSArray*)errors
{
    if (self.delegate) {
        [self.delegate operationQueue:self
                  didFinishOperation:operation
                           withErrors:errors];
    }
}

@end
