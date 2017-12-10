accessing
string
	^ super string ==> [ :token |
		| val |
		val := token inputValue.
		val copyFrom: 2 to: val size - 1
	]