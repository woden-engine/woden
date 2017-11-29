adding
removeFromScene
	parent ifNotNil: [ parent removeChild: self ] ifNil: [ scene ifNotNil: [ scene remove: self ] ]