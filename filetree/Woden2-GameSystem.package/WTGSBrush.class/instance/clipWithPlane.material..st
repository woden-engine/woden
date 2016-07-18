clipping
clipWithPlane: aPlane material: aMaterial
	| frontFaces backFaces side backBrush frontBrush negatedPlane |
	negatedPlane := aPlane negated.
	faces detect: [ :face |
		(face plane closeTo: aPlane) or: [face plane closeTo: negatedPlane]] ifFound: [ ^ nil ].
	(self intersectsWithPlane: aPlane) ifFalse: [ ^ nil ].
	
	frontFaces := OrderedCollection new.
	backFaces := OrderedCollection new.
	faces do: [ :face |
		side := face sideOfPlane: aPlane.
		side = 0 ifTrue: [
			frontFaces add: face copy.
			backFaces add: face copy.
		] ifFalse: [ 
			side < 0 ifTrue: [ backFaces add: face copy]
			ifFalse: [ frontFaces add: face copy]
		]
	].

	self assert: frontFaces isNotEmpty.
	self assert: backFaces isNotEmpty.
	backFaces add: ((WTGSBrushFace plane: aPlane) material: aMaterial).
	frontFaces add: ((WTGSBrushFace plane: aPlane negated) material: aMaterial).
	backBrush := self class faces: backFaces asArray.
	frontBrush := self class faces: frontFaces asArray .
	backBrush triangulate.
	frontBrush triangulate.
	^ { backBrush . frontBrush }
	