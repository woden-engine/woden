comparing
= other
	^ self class = other class and: [ (x = other x) and: [ (y = other y) and: [z = other z] ] ]