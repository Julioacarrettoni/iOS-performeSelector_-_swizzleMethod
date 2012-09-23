iOS-performeSelector_-_swizzleMethod
====================================

I explore the use of swizzleMethod in order to add a new "cancelPreviousPerformRequestsWithSelector" that only requires the selector as a parameter and it will cancel ALL of the performRequest no matter the target nor the arguments. In order words you don't need a pointer to the targets anymore.



How to use?
===========

Just add to your project:
* JRSwizzle.h ( https://github.com/rentzsch/jrswizzle )
* JRSwizzle.m  ( https://github.com/rentzsch/jrswizzle )
* NSObject+myProxyForPerformSelectorWithObjectAfterDelay.h
* NSObject+myProxyForPerformSelectorWithObjectAfterDelay.m

Finally, just import "NSObject+myProxyForPerformSelectorWithObjectAfterDelay.h" into whenever you want to use:

```
+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget;
+ (void)cancelALLPreviousPerformRequestsWithSelector:(SEL) selector; //For ALL targets
+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector; //argument is not required
+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector object:(id)anArgument; //the normal one

```
And you are done!


How does the example works?
===========================

Is just a simple example, if you press the top most button a spiner will appear and then after 2 seconds the UISwitch will toggle.
But if you press the any of the other buttons before the 2 seconds, the toggle will not happend.

Yes, the example is not magical as it would be really easy to hold a reference to the current ViewController, but Ii is just that, an example.

Enjoy!



Note
====

I don't really think this will be approved on the App Store but It was fun to code :P
