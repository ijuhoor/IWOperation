# IWOperation
Obj-c Wrapper around NSOperation to be able to group them, chain them and make them mutually exclusive (Form WWDC 2015 Advanced NSOperations)

## What it is
IWOperation is the Obj-c implementation of the code presented at WWDC 2015's Advanced NSOperations ([https://developer.apple.com/videos/wwdc/2015/?id=226]). 

It allows to create great apps in a flexible way, where all the business logic would be contained in a small unit. 
These units can be chained together, depend on other units and event be mutually exclusive. 

For example, an application that would need to:
1. download data
2. parse data
3. display data

would simply chain all these operations together and execute it as a unit. 

For more information have a look at the WWDC 2015 talk about it.

## Targets

There is 3 usable targets:

1. a static lib
2. a framework (iOS >= 8)
3. a fat static lib contained in a 'old' framework

## What's left to do

### Unit test. 
There is more coverage to do in the unit test 

### Operations cannot generate new operations 
In the talk, an operation can create another operation. 

