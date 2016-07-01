as yet unclassified
checkForOnlyTextSegments: segment
	| currentSegment |
	isJustText := true.
	currentSegment := segment.
	[ currentSegment isNotNil ] whileTrue: [
		(currentSegment isMove or: [ currentSegment isTextSegment ]) ifFalse: [ 
			isJustText := false.
			^ self
		].
	
		currentSegment := currentSegment next.
	]