Class {
	#name : #WCADSolidBSPFace,
	#superclass : #Object,
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

{ #category : #sorting }
WCADSolidBSPFace >> centroid [
	^ vertices sum / vertices size
]

{ #category : #'as yet unclassified' }
WCADSolidBSPFace >> computePlane [
	| u v |
	u := vertices second - vertices first.
	v := vertices third - vertices first.
	self computePlaneWithNormal: (u cross: v) normalized.
	
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

{ #category : #accessing }
WCADSolidBSPFace >> plane [

	^ plane
]

{ #category : #accessing }
WCADSolidBSPFace >> plane: anObject [

	plane := anObject
]

{ #category : #'as yet unclassified' }
WCADSolidBSPFace >> splitWithPlane: splitPlane [
	| frontVertices backVertices lastVertexSide lastVertex vertexCount sides |
	self assert: (splitPlane closeTo: plane) not.
	self assert: (splitPlane closeTo: plane negated) not.

	frontVertices := OrderedCollection new.
	backVertices := OrderedCollection new.

	vertexCount := vertices size.
	sides := vertices collect: [ :vertex | (splitPlane pointDistance: vertex) sign ].
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
			splitPoint := ray pointAtDistance: (splitPlane intersectionWithRay: ray).
			frontVertices add: splitPoint.
			backVertices add: splitPoint.
		].
	].
 
	frontVertices ifEmpty: [ ^ { self . nil } ].
	backVertices ifEmpty: [ ^ { nil . self } ].
	
	self assert: frontVertices size = 4.
	self assert: backVertices size = 4.
	^ {
		self copy
			vertices: backVertices asArray .
		self copy
			vertices: frontVertices asArray
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
