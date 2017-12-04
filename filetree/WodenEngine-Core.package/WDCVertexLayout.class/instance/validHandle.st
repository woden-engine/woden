accessing
validHandle
	(handle isNil or: [ handle isNull ]) ifTrue: [ self error: 'Handle is not valid' ].
	^ handle