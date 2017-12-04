testing
isPoint: point behindOtherFaces: frontFace
	faces do: [ :face |
		(face ~~ frontFace and: [ (face plane pointDistance: point) > 0.0 ]) ifTrue: [ 
			^ false
		]
	].
	^ true