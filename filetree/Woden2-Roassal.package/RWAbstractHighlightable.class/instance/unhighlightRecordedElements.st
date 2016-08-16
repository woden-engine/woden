actions
unhighlightRecordedElements
	self class lastHighlightedElements ifNil: [ ^ self ].
	self class lastHighlightedElements do: [ :el | self doUnhighlightElement: el ].
	self class lastHighlightedElements: nil