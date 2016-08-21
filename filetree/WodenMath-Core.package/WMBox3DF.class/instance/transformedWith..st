transforming
transformedWith: transformation
	| result |
	result := self class empty.
	self cornersDo: [ :corner | result insertPoint: ((transformation transformPosition3: corner)) ].
	^ result