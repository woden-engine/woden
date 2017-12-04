testing
hasValidHandle
	^ handle isNotNil and: [ session == Smalltalk session ]