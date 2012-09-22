iOS-performeSelector_-_swizzleMethod
====================================

I explore the use of swizzleMethod in order to add a new "cancelPreviousPerformRequestsWithSelector" that only requires the selector as a parameter and it will cancel ALL of the performRequest no matter the target nor the arguments. In order words you don't need a pointer to the targets anymore.