//
//  IWOperationTests.m
//  TestOperations
//
//  Created by Idriss on 05/08/2015.
//  Copyright © 2015 lastminute. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "IWOperation.h"
#import "IWTestCondition.h"
#import "IWTestObserver.h"


@interface IWOperation ()

@property (nonatomic) IWOperationState  state;

- (void)evaluateConditions;

@end

@interface IWOperationTests : XCTestCase

@property (nonatomic, strong) NSString *kvoObserving;

@end

@implementation IWOperationTests

- (void)testAddCondition
{
    
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    XCTAssertEqual(0, [[op conditions] count]);
    
    IWTestCondition *testCondition = [IWTestCondition new];
    testCondition.succeeds = YES;
    [op addCondition:testCondition];
    
    XCTAssertEqual(1, [[op conditions] count]);
    XCTAssertEqualObjects([op conditions][0], testCondition);
    
}

- (void)testConditionMet
{
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    IWTestCondition *testCondition = [IWTestCondition new];
    testCondition.succeeds = YES;
    [op addCondition:testCondition];
    
    XCTAssertEqual(1, [[op conditions] count]);
    
    
    
}

- (void)testStateCreated
{
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    XCTAssertEqual(op.state, IWOperationStateCreated);
    
}

- (void)testStateCreatedToReady
{
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    XCTAssertEqual(op.state, IWOperationStateCreated);

    
    
}

- (void)testReadyToStarted
{
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    op.state = IWOperationStateReady;
    
    [op start];
    
    XCTAssertEqual(op.state, IWOperationStateStarted);

    
}

- (void)testStartedToFinished
{
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    op.state = IWOperationStateStarted;
    
    [op finish:nil];
    
    XCTAssertEqual(op.state, IWOperationStateFinished);
    
    
}

- (void)testStartedToCancelled
{
    IWOperation *op = [[IWOperation alloc] init];
     
    XCTAssertNotNil(op);
    
    op.state = IWOperationStateStarted;
    
    [op cancel];
    
    XCTAssertEqual(op.state, IWOperationStateCancelled);
    
    
}


 - (void)testAddObserver
{
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    XCTAssertEqual(0, [[op observers] count]);
    
    IWTestObserver *obs = [IWTestObserver new];
    [op addObserver:obs];
    
    XCTAssertEqual(1, [[op observers] count]);
    XCTAssertEqualObjects([op observers][0], obs);

}

- (void)testObserverStarted
{
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    
    IWTestObserver *obs = [IWTestObserver new];
    [op addObserver:obs];
    XCTAssertEqual(1, [[op observers] count]);
    
    XCTAssert(obs.opStarted  == NO);
    XCTAssert(obs.opFinished == NO);
    XCTAssertNil(obs.errors);

    op.state = IWOperationStateReady;
    [op start];
    
    XCTAssert(obs.opStarted == YES);
    XCTAssertNil(obs.errors);
    
}

- (void)testObserverFinishedNoErrors
{
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    
    IWTestObserver *obs = [IWTestObserver new];
    [op addObserver:obs];
    XCTAssertEqual(1, [[op observers] count]);
    
    XCTAssert(obs.opStarted  == NO);
    XCTAssert(obs.opFinished == NO);
    XCTAssertNil(obs.errors);
    
    [op finish:nil];
    
    XCTAssert(obs.opFinished == YES);
    XCTAssertNil(obs.errors);
    
}

- (void)testObserverFinishedWithErrors
{
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    
    IWTestObserver *obs = [IWTestObserver new];
    [op addObserver:obs];
    XCTAssertEqual(1, [[op observers] count]);
    
    XCTAssert(obs.opStarted  == NO);
    XCTAssert(obs.opFinished == NO);
    XCTAssertNil(obs.errors);
    
    NSError *e1 = [NSError errorWithDomain:@"test"
                                      code:1
                                  userInfo:nil];
    [op finish:@[e1]];
    
    XCTAssert(obs.opFinished == YES);
    XCTAssert([obs.errors count] == 1);
    XCTAssertEqualObjects(obs.errors[0], e1);
    
}

- (void)testConditionEvaluationSuccess
{
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    IWTestCondition *testCondition = [IWTestCondition new];
    testCondition.succeeds = YES;
    [op addCondition:testCondition];
    
    XCTAssertEqual(1, [[op conditions] count]);
    
    XCTAssertEqual(op.state, IWOperationStateCreated);
    
    [op evaluateConditions];
    
    XCTestExpectation *testExpectation = [self expectationWithDescription:@"The state should change to 'Ready'"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        XCTAssertEqual(op.state, IWOperationStateReady);
        [testExpectation fulfill];
        
    });
    
    [self waitForExpectationsWithTimeout:0.3
                                 handler:nil];
    
    }


- (void)testConditionEvaluationFailure
{
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    IWTestCondition *testCondition = [IWTestCondition new];
    testCondition.succeeds = NO;
    [op addCondition:testCondition];
    
    XCTAssertEqual(1, [[op conditions] count]);
    
    XCTAssertEqual(op.state, IWOperationStateCreated);
    
    [op evaluateConditions];
    
    XCTestExpectation *testExpectation = [self expectationWithDescription:@"The state should change to 'Cancelled'"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        XCTAssertEqual(op.state, IWOperationStateCancelled);
        [testExpectation fulfill];
        
    });
    
    [self waitForExpectationsWithTimeout:0.3
                                 handler:nil];
    
}

- (void)testKVOIsReady
{
    
    self.kvoObserving = nil;
    
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    [op addObserver:self
         forKeyPath:@"isReady"
            options:NSKeyValueObservingOptionNew
            context:nil];

    XCTAssertEqual([op isReady], NO);
    
    op.state = IWOperationStateReady;
    
    XCTAssertEqualObjects(@"isReady", self.kvoObserving);
    
    XCTAssertEqual([op isReady], YES);
    
    [op removeObserver:self
            forKeyPath:@"isReady"
               context:nil];
    
}

- (void)testKVOIsExecuting
{
    
    self.kvoObserving = nil;
    
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    [op addObserver:self
         forKeyPath:@"isExecuting"
            options:NSKeyValueObservingOptionNew
            context:nil];
    
    XCTAssertEqual([op isExecuting], NO);
    
    op.state = IWOperationStateStarted;
    
    XCTAssertEqualObjects(@"isExecuting", self.kvoObserving);
    
    XCTAssertEqual([op isExecuting], YES);
    
    [op removeObserver:self
            forKeyPath:@"isExecuting"
               context:nil];
    
}


- (void)testKVOIsFinished
{
    
    self.kvoObserving = nil;
    
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    [op addObserver:self
         forKeyPath:@"isFinished"
            options:NSKeyValueObservingOptionNew
            context:nil];
    
    XCTAssertEqual([op isExecuting], NO);
    
    op.state = IWOperationStateFinished;
    
    XCTAssertEqualObjects(@"isFinished", self.kvoObserving);
    
    XCTAssertEqual([op isFinished], YES);
    
    [op removeObserver:self
            forKeyPath:@"isFinished"
               context:nil];
    
}

- (void)testKVOIsCancelled
{
    
    self.kvoObserving = nil;
    
    IWOperation *op = [[IWOperation alloc] init];
    
    XCTAssertNotNil(op);
    
    [op addObserver:self
         forKeyPath:@"isCancelled"
            options:NSKeyValueObservingOptionNew
            context:nil];
    
    XCTAssertEqual([op isExecuting], NO);
    
    op.state = IWOperationStateCancelled;
    
    XCTAssertEqualObjects(@"isCancelled", self.kvoObserving);
    
    XCTAssertEqual([op isCancelled], YES);
    
    [op removeObserver:self
            forKeyPath:@"isCancelled"
               context:nil];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.kvoObserving = keyPath;
    
}

@end
