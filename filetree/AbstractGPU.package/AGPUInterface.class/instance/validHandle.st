accessing
validHandle
	handle ifNil: [ self error: 'Trying to use an object with an invalid handle.' ].
	^ handle