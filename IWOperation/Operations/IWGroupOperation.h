//
//  IWGroupOperation.h
//  TestOperations
//
// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2015 Idriss Juhoor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.



#import "IWOperation.h"

/**
 *  Base class for a grouped operation.
 *  A group operation has an internal queue that starts when the task is ready to run.
 *  It Finished when all the task finishes and aggregates the resulting errors.
 */
@interface IWGroupOperation : IWOperation


/**
 *  Initializer with and Array of IWOperations
 *
 *  @param operations an array of IWOperations.
 *
 *  @return the initialized IWGroupOperation
 */
- (instancetype)initWithOperations:(NSArray*)operations;


/**
 *  Sets the operations for the Group. Works only if the group operation (self)
 *  is in the 'Created' state
 *
 *  @param operations the array of IWOperations
 */
- (void)setOperations:(NSArray*)operations;


@end
