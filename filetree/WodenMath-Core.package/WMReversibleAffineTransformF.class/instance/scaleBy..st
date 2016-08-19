transformation building
scaleBy: vectorOrScalar
	vectorOrScalar isNumber
		ifTrue: [ self scaleByX: vectorOrScalar y: vectorOrScalar z: vectorOrScalar ]
		ifFalse: [ self scaleByX: vectorOrScalar x y: vectorOrScalar y z: vectorOrScalar z ]