transformations
scaleBy: factor
	matrix := matrix * (factor isPoint
		ifTrue: [ WMMatrix3F scaleX: factor x asFloat y: factor y asFloat z: 1.0 ]
		ifFalse: [ WMMatrix3F scaleX: factor asFloat y: factor asFloat z: 1.0 ])