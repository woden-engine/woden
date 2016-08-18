texture transform
textureTransformsValueCollect: aBlock
	| result newResult |
	result := nil.
	self textureTransformsDo: [ :transform |
		newResult := aBlock value: transform.
		(result isNotNil and: [ result ~= newResult ]) ifTrue: [ ^ nil ].
		result := newResult.
	].
	^ result