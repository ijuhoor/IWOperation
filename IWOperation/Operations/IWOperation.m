//
//  IWOperation.m
//
//  Created by Idriss on 15/07/2015.
//

#import "IWOperation.h"
#import "IWConditionEvaluator.h"

NSString * const operationCancelledErrorDomain = @"Operation Cancelled";
NSInteger  const operationCancelledErrorCode   = 13001;

@interface IWOperation ()

@property (nonatomic) IWOperationState  state;

@property (nonatomic, strong) NSMutableArray *_conditions;
@property (nonatomic, strong) NSMutableArray *_observers;


@end

@implementation IWOperation

+(NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    if ([@[@"isReady", @"isExecuting", @"isFinished",@"isCancelled"] containsObject:key])
    {
        return [NSSet setWithArray:@[@"state"]];
    }
    return [super keyPathsForValuesAffectingValueForKey:key];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        __conditions = [NSMutableArray array];
        __observers  = [NSMutableArray array];
        _state       = IWOperationStateCreated;
    }
    return self;
}

- (void)addCondition:(IWOperation<IWConditionOperationProtocol> *)condition
{
    if (_state > IWOperationStateCreated) {
        return;
    }
    [self addDependency:condition];
    [self._conditions addObject:condition];
}

- (void)addObserver:(id<IWOperationObserver>)observer
{
    [self._observers addObject:observer];
}

- (void)setState:(IWOperationState)state
{
    [self willChangeValueForKey:@"state"];
    
    if (   _state != IWOperationStateCancelled
        && _state != IWOperationStateFinished
        && state != _state) {
        _state = state;
    }

    [self didChangeValueForKey:@"state"];
    
}

- (void)start
{
    if (self.state != IWOperationStateReady) {
        return;
    }
    
    self.state = IWOperationStateStarted;
    
    [self notifyObservers:^(id<IWOperationObserver> observer) {
        [observer operationDidStart:self];
    }];
    [self run];
}

- (void)run
{
    [self finish:nil];
}

- (void)finish:(NSArray*)errors
{
    self.state = IWOperationStateFinished;
    [self notifyObservers:^(id<IWOperationObserver> observer) {
        [observer operation:self
        didFinishWithErrors:errors];
    }];
}

- (BOOL)isReady
{
    if (self.state == IWOperationStateCreated) {
        if ([super isReady]) {
            [self evaluateConditions];
        }
        return  NO;
        
    } else if (self.state == IWOperationStateReady) {
        return [super isReady];
        
    } else {
        return NO;
    }
}

- (void)cancel
{
    [super cancel];
    self.state = IWOperationStateCancelled;
}

-(BOOL)isExecuting
{
    return self.state == IWOperationStateStarted;
}
-(BOOL)isFinished
{
    return self.state == IWOperationStateFinished;
}
-(BOOL)isCancelled
{
    return self.state == IWOperationStateCancelled;
}

- (void)evaluateConditions
{
    [IWConditionEvaluator evaluateConditions:self.conditions
                                 ofOperation:self
                                onCompletion:^(NSArray *errors) {
                                    
                                    if (errors.count > 0) {
                                        self.state = IWOperationStateCancelled;
                                        [self finish:errors];
                                    } else {
                                        self.state = IWOperationStateReady;
                                    }
                                    
                                }];

}

- (NSArray*)conditions
{
    return [NSArray arrayWithArray:self._conditions];
}

- (NSArray*)observers
{
    return [NSArray arrayWithArray:self._observers];
}

- (void)notifyObservers:(void(^)(id<IWOperationObserver> observer))notificationBlock
{
    for (id<IWOperationObserver> observer in self._observers) {
        dispatch_async(dispatch_get_main_queue(), ^{
            notificationBlock(observer);
        });
    }
}


@end
