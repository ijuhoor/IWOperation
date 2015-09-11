//
//  IWExclusivityController.m
//
//  Created by Idriss on 01/08/2015.
//

#import <dispatch/dispatch.h>

#import "IWExclusivityController.h"
#import "IWOperation.h"

static IWExclusivityController *defaultExclusivityController;

@interface IWExclusivityController ()

@property (nonatomic, strong) NSMutableDictionary *operationsLock;
@property (nonatomic)         dispatch_queue_t    dispatchQueue;

@end

@implementation IWExclusivityController

+ (instancetype)defaultExclusivityController
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        defaultExclusivityController = [[self alloc] init];
    });
    return defaultExclusivityController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _operationsLock = [NSMutableDictionary new];
        _dispatchQueue  = dispatch_queue_create("IWOperationMutexList", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)addOperation:(IWOperation*)operation withCategories:(NSArray *)categories
{
    dispatch_sync(self.dispatchQueue, ^{
        for (NSString * category in categories) {
            [self addMutexOn:operation toCategory:category];
        }
    });
}

- (void)removeOperation:(IWOperation*)operation withCategories:(NSArray *)categories
{
    dispatch_sync(self.dispatchQueue, ^{
        for (NSString * category in categories) {
            [self removeMutexOn:operation toCategory:category];
        }
    });
}

#pragma mark private

- (void)addMutexOn:(IWOperation*)operation toCategory:(NSString*)category
{
    
    if (!self.operationsLock[category]){
        self.operationsLock[category] = [NSMutableArray new];
    }
    
    IWOperation *previousOperation = [self.operationsLock[category] lastObject];
    if (previousOperation) {
        [operation addDependency:previousOperation];
    }
    
    [self.operationsLock[category] addObject:operation];
    
}

- (void)removeMutexOn:(IWOperation*)operation toCategory:(NSString*)category
{
    [self.operationsLock[category] removeObject:operation];
}


@end
