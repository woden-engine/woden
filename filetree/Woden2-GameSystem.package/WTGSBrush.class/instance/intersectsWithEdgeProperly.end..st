intersection
intersectsWithEdgeProperly: start end: end
	(start closeTo: end) ifTrue: [^ self containsPointInside: start].
	((self containsPointInside: start) or: [ self containsPointInside: end ]) ifTrue: [ ^ true ].
	
	faces do: [ :face |
		| inside intersection |
		intersection := face plane intersectWithSegment: start end: end.
		
		inside := true.
		intersection ifNotNil: [
			faces do: [ :otherFace |
				inside ifTrue: [
					(face ~~ otherFace and: [(otherFace plane isBehind: intersection) not]) ifTrue: [ inside := false ]
				]
			].
		
			inside ifTrue: [ ^ true ].
		]
	].

	^ false