actions
doHighlight: element
	| elements |
	self unhighlightRecordedElements.
	elements := highlightElements rtValue: element.
	elements := elements copyWithout: nil.
	elements do: [ :eachElement | self doHighlightElement: eachElement ].
	element attributes at: self attributeIdentificator put: elements.
	self class lastHighlightedElements: elements