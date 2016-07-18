private
triangulate
	| faceCount f1 f2 f3|
	faceCount := self numberOfFaces.
	positions removeAll.
	faces do: [ :face | face clearIndices ].

	1 to: faceCount do: [ :i |
		f1 := faces at: i.
		i + 1 to: faceCount do: [ :j |
			f2 := faces at: j.
			j + 1 to: faceCount do: [ :k |
				f3 := faces at: k.
				(i ~~ j and: [j ~~ k]) ifTrue: [ self intersectFace: f1 with: f2 with: f3 ]
			]
		]
	].

	faces do: [ :face | face fixWinding ].
	self computeBoundingBox.