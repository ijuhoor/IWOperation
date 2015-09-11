//
//  IWOperationBlockObserver.m
//
//  Created by Idriss on 21/07/2015.
//

#import <dispatch/dispatch.h>

#import "IWOperationBlockObserver.h"

#import "IWOperation.h"

@interface IWOperationBlockObserver ()

@property (nonatomic, copy) void(^startBlock) (IWOperation*);
@property (nonatomic, copy) void(^finishBlock)(IWOperation*, NSArray*);

@end

@implementation IWOperationBlockObserver

- (instancetype)initWithStartBlock:(void(^)(IWOperation* operation))startBlock andFinishBlock:(void(^)(IWOperation *operation, NSArray *errors))finishBlock
{
    self = [super init];
    if (self) {
        _startBlock  = startBlock;
        _finishBlock = finishBlock;
    }
    return self;
}

- (void)operationDidStart:(IWOperation *)operation
{
    if (self.startBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.startBlock(operation);
        });
    }
}

- (void)operation:(IWOperation *)operation didFinishWithErrors:(NSArray *)errors
{
    if (self.finishBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
        self.finishBlock(operation, errors);
        });
    }
}

@end
