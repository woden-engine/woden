Class {
	#name : #WCADSolidBSPFace,
	#superclass : #WCADObject,
	#instVars : [
		'vertices',
		'plane'
	],
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #'as yet unclassified' }
WCADSolidBSPFace class >> vertices: vertices normal: normal [
	^ self new
		vertices: vertices;
		computePlaneWithNormal: normal;
		yourself
]

{ #category : #'as yet unclassified' }
WCADSolidBSPFace class >> vertices: vertices normal: normal distance: distance [
	^ self new
		vertices: vertices;
		plane: (PlaneF64 normal: normal distance: distance);
		yourself
]

{ #category : #'as yet unclassified' }
WCADSolidBSPFace >> allVerticesAreInPlane [
	^ vertices allSatisfy: [ :v |
		|distance |
		distance := plane pointDistance: v.
		Epsilon negated < distance and: [ distance < Epsilon ] 
	]
]

{ #category : #sorting }
WCADSolidBSPFace >> centroid [
	^ vertices sum / vertices size
]

{ #category : #'as yet unclassified' }
WCADSolidBSPFace >> computeNormal [
	| u v |
	u := vertices second - vertices first.
	v := vertices third - vertices first.
	^ (u cross: v) normalized.
	
]

{ #category : #'as yet unclassified' }
WCADSolidBSPFace >> computePlane [
	self computePlaneWithNormal: self computeNormal
]

{ #category : #'as yet unclassified' }
WCADSolidBSPFace >> computePlaneWithNormal: normal [
	plane := PlaneF64 normal: normal distance: (normal dot: vertices first)
]

{ #category : #'as yet unclassified' }
WCADSolidBSPFace >> computeSubdivisionsInto: output [
	| centroid vertexCount |
	vertexCount := vertices size.

	"Subdivide only into 4 triangles."
	vertexCount = 3 ifTrue: [
		| m1 m2 m3 |
		m1 := (vertices first + vertices second) / 2.
		m2 := (vertices second + vertices third) / 2.
		m3 := (vertices third + vertices first) / 2.

		output
			add: (self class new
				vertices: { m3 . vertices first . m1 };
				plane: plane;
				yourself);

			add: (self class new
				vertices: { m1 . vertices second . m2 };
				plane: plane;
				yourself);
			add: (self class new
				vertices: { m2 . vertices third . m3 };
				plane: plane;
				yourself);
			add: (self class new
				vertices: { m1 . m2 . m3 };
				plane: plane;
				yourself).		
		^ self
	].

	centroid := self centroid.

	"Handle the quad case specially."
	vertexCount = 4 ifTrue: [ 
		| bottom right top left |
		bottom := (vertices first + vertices second) / 2.
		right := (vertices second + vertices third) / 2.
		top := (vertices third + vertices fourth) / 2.
		left := (vertices fourth + vertices first) / 2.

		output
			add: (self class new
				vertices: { left . vertices first . bottom . centroid };
				plane: plane;
				yourself);
			add: (self class new
				vertices: { bottom . vertices second . right . centroid };
				plane: plane;
				yourself);
			add: (self class new
				vertices: { right . vertices third .  top . centroid};
				plane: plane;
				yourself);
			add: (self class new
				vertices: { top . vertices fourth . left . centroid };
				plane: plane;
				yourself).
		
		^ self.
	].

	0 to: vertexCount - 1 do: [ :i |
		| leftVertex rightVertex middleVertex |
		leftVertex := vertices at: i + 1.
		rightVertex := vertices at: (i + 1) % vertexCount + 1.
		middleVertex := (leftVertex + rightVertex) / 2.
		
		output
			add: (self class new
				vertices: { leftVertex . middleVertex . centroid };
				plane: plane;
				yourself);
			add: (self class new
				vertices: { middleVertex . rightVertex . centroid };
				plane: plane;
				yourself)
	]
]

{ #category : #sorting }
WCADSolidBSPFace >> fixVerticesOrientationAlongNormal [
	| expectedNormal v1 v2 v3 normal |
	v1 := vertices first.
	v2 := vertices second.
	v3 := vertices third.
	normal := (v2 - v1) cross: (v3 - v1).
	expectedNormal := plane normal.
	(normal dot: expectedNormal) < 0 ifTrue: [
		vertices := vertices reversed
	]
]

{ #category : #properties }
WCADSolidBSPFace >> flipped [
	^ self copy plane: plane negated; vertices: vertices reversed; yourself
]

{ #category : #accessing }
WCADSolidBSPFace >> plane [

	^ plane
]

{ #category : #accessing }
WCADSolidBSPFace >> plane: anObject [

	plane := anObject
]

{ #category : #sorting }
WCADSolidBSPFace >> sortVerticesAlongNormal [
	| centroid normal |
	centroid := self centroid.
	normal := plane normal.
	vertices sort: [ :a :b |
		| u v |
		u := a - centroid.
		v := b - centroid.
		((u cross: v) dot: normal) >= Epsilon negated
	]
]

{ #category : #'as yet unclassified' }
WCADSolidBSPFace >> splitInTriangleFanInto: output [
	vertices size <= 3 ifTrue: [ output add: self. ^ self ].
	
	2 to: vertices size - 1 do: [ :i |
		output add: (self class new
			vertices: {vertices first . vertices at: i . vertices at: i + 1};
			computePlane;
			yourself)
	]
]

{ #category : #'as yet unclassified' }
WCADSolidBSPFace >> splitWithPlane: splitPlane [
	| frontVertices backVertices vertexCount sides minSide maxSide planeVertices |
	self assert: (splitPlane closeTo: plane precision: Epsilon) not.
	self assert: (splitPlane closeTo: plane negated precision: Epsilon) not.

	frontVertices := OrderedCollection new.
	backVertices := OrderedCollection new.
	planeVertices := OrderedCollection new.

	vertexCount := vertices size.
	sides := vertices collect: [ :vertex |
		| distance |
		distance := (splitPlane pointDistance: vertex).
		distance > Epsilon
			ifTrue: [ 1 ]
			ifFalse: [
				distance < Epsilon negated
					ifTrue: [ -1 ]
					ifFalse: [ 0 ]
				]
	].
	minSide := sides min.
	maxSide := sides max.
	self assert: (minSide ~= 0 or: [maxSide ~= 0]).
	(minSide = -1 and: [maxSide <= 0]) ifTrue: [ ^ { self . nil . #() } ].
	(minSide >= 0 and: [maxSide = 1]) ifTrue: [ ^ { nil . self . #() } ].

	0 to: vertexCount - 1 do: [ :i |
		| vi nvi side nextSide vertex |
		vi := i + 1.
		nvi := (i + 1) % vertexCount + 1.
		side := sides at: vi.
		nextSide := sides at: nvi.
		vertex := vertices at: vi.
		
		side = 0 ifTrue: [ 
			frontVertices add: vertex.
			backVertices add: vertex.
			planeVertices add: vertex.
		] ifFalse: [
			side < 0 ifTrue: [ 
				backVertices add: vertex.
			] ifFalse: [ 
				frontVertices add: vertex.
			]
		].
	
		(side ~= 0 and: [side = nextSide negated]) ifTrue: [ 
			| ray splitPoint nextVertex |
			nextVertex := vertices at: nvi.
			ray := Ray3dF64 from: vertex to: nextVertex.
			ray tmax: ray tmax + Epsilon.
			splitPoint := ray pointAtDistance: (splitPlane intersectionWithRay: ray).
			frontVertices add: splitPoint.
			backVertices add: splitPoint.
			planeVertices add: splitPoint.
		].
	].
 	
	^ {
		self copy
			vertices: backVertices asArray .
		self copy
			vertices: frontVertices asArray.
		planeVertices asArray.
	}
]

{ #category : #accessing }
WCADSolidBSPFace >> vertices [

	^ vertices
]

{ #category : #accessing }
WCADSolidBSPFace >> vertices: anObject [

	vertices := anObject
]

{ #category : #sorting }
WCADSolidBSPFace >> withSameNormalOfPlane: expectedPlane [
	^ (plane normal dot: expectedPlane normal) < 0 ifTrue: [
		self flipped
	] ifFalse: [
		self
	]
]
