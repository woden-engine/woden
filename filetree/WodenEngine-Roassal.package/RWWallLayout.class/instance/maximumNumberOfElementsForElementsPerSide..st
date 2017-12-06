dimension calculation
maximumNumberOfElementsForElementsPerSide: elementsPerSide
	| nextMinimum |
	nextMinimum := self minimumNumberOfElementsForElementsPerSide: elementsPerSide + 1.
	^ nextMinimum - 1