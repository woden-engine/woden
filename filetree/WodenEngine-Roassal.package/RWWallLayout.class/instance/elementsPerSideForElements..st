dimension calculation
elementsPerSideForElements: numberOfElements
	| elementsPerSide |
	self assert: numberOfElements >= 0.
	elementsPerSide := 1.
	[ 
	| min max |
	min := self minimumNumberOfElementsForElementsPerSide: elementsPerSide.
	max := self maximumNumberOfElementsForElementsPerSide: elementsPerSide.
	numberOfElements >= min and: [ numberOfElements <= max ] ] whileFalse: [ elementsPerSide := elementsPerSide + 1 ].
	^ elementsPerSide