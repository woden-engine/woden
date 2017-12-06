private
childrenFor: anElement
	^ children at: anElement ifAbsent: [ ^#() ]