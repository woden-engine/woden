public
on: elements
	| index |
	index  := 0.
	elements do: [ :el |
		el translateTo: (self getNewPositionFor: index).
		index := index + (self sizeOf: el) + gap ]	