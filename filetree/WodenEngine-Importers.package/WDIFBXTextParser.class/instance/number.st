accessing
number
	^ super number ==> [ :token |
		| val |
		val := token inputValue.
		(val first = $+ ifTrue: [ val allButFirst ] ifFalse: [ val ]) asNumber
	]