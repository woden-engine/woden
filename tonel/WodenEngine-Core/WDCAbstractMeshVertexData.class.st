"
I contain common methods for interleaved and separated mesh vertex data.
"
Class {
	#name : #WDCAbstractMeshVertexData,
	#superclass : #Object,
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'vertex manipulations' }
WDCAbstractMeshVertexData >> applyTransform: reversibleAffineTransform [
	self
		transformPositionsWith: reversibleAffineTransform;
		transformNormalsWith: reversibleAffineTransform
]

{ #category : #'vertex data channels' }
WDCAbstractMeshVertexData >> colors [
	self subclassResponsibility
]

{ #category : #'display box access' }
WDCAbstractMeshVertexData >> computeBoundingBox [
	^ BoxF32 encompassing: self positions
]

{ #category : #'vertex manipulations' }
WDCAbstractMeshVertexData >> computeNormalsWithTriangles: triangles [
	| normals positions p1 p2 p3 i1 i2 i3 u v n |
	self normals ifNil: [ self generateZeroNormals ].
	
	normals := self normals.
	positions := self positions.
	
	triangles do: [ :triangle |
		i1 := triangle first + 1.
		i2 := triangle second + 1.
		i3 := triangle third + 1.
		
		p1 := positions at: i1.
		p2 := positions at: i2.
		p3 := positions at: i3.
		
		u := p2 - p1.
		v := p3 - p1.
		n := u cross: v.
		
		normals at: i1 put: (normals at: i1) + n.
		normals at: i2 put: (normals at: i2) + n.
		normals at: i3 put: (normals at: i3) + n.
	].

	1 to: normals size do: [ :i |
		normals at: i put: (normals at: i) normalized
	].

]

{ #category : #private }
WDCAbstractMeshVertexData >> computeTangent4WithTangent: rawTangent bitangent: rawBitangent normal: normal [
	| tangent bitangent scaleFactor |

	"Gram schmidth orthogonalization"
	tangent := (rawTangent - (normal * (normal dot: rawTangent))) normalized.
	bitangent := (rawBitangent - (normal * (normal dot: rawBitangent)) - (tangent * (tangent dot: rawBitangent))) normalized.
	scaleFactor := (normal cross: tangent) dot: bitangent.
	^ Float32x4 x: tangent x y: tangent y z: tangent z w: scaleFactor.

]

{ #category : #'vertex manipulations' }
WDCAbstractMeshVertexData >> computeTangents4WithTriangles: triangles [
	| positions texcoords normals tangents bitangents
		i1 i2 i3 p1 p2 p3 tc1 tc2 tc3 u v du1 du2 dv1 dv2 det den
		normal tangent bitangent tangent4 tangents4 |
	positions := self positions.
	texcoords := self texcoords.
	normals := self normals.
	
	tangents := Array new: self size withAll: Float32x3 zeros.
	bitangents := Array new: self size withAll: Float32x3 zeros.

	triangles do: [ :triangle |
		i1 := triangle first + 1.
		i2 := triangle second + 1.
		i3 := triangle third + 1.
		
		p1 := (positions at: i1) asFloat32x3.
		p2 := (positions at: i2) asFloat32x3.
		p3 := (positions at: i3) asFloat32x3.

		tc1 := texcoords at: i1.
		tc2 := texcoords at: i2.
		tc3 := texcoords at: i3.

		u := p2 - p1.
		v := p3 - p1.
		
		du1 := tc2 x - tc1 x.
		dv1 := tc2 y - tc1 y.
		
		du2 := tc3 x - tc1 x.
		dv2 := tc3 y - tc1 y.
		
		det := (du1*dv2) - (du2*dv1).
		(det closeTo: 0.0) ifFalse: [ 
			den := 1.0 / det.
			
			tangent := (u * (den*dv2))  - (v * (den*dv1)).
			bitangent := (v * (den*du1)) - (u * (den*du2)).
			
			tangents at: i1 put: (tangents at: i1) + tangent.
			tangents at: i2 put: (tangents at: i2) + tangent.
			tangents at: i3 put: (tangents at: i3) + tangent.

			bitangents at: i1 put: (bitangents at: i1) + bitangent.
			bitangents at: i2 put: (bitangents at: i2) + bitangent.
			bitangents at: i3 put: (bitangents at: i3) + bitangent.
		].
	].

	tangents4 := (StdnVector for: Float32x4) new: self size.
	1 to: self size do: [ :vertexIndex |
		tangent := tangents at: vertexIndex.
		bitangent := bitangents at: vertexIndex.
		normal := normals at: vertexIndex.
		
		tangent4 := self computeTangent4WithTangent: tangent bitangent: bitangent normal: normal.
		tangents4 add: tangent4		
	].

	self addChannelNativeTangents4: tangents4
]

{ #category : #'gpu binding resources' }
WDCAbstractMeshVertexData >> createVertexBindingFor: engine [
	self subclassResponsibility
]

{ #category : #'gpu binding resources' }
WDCAbstractMeshVertexData >> createVertexBufferFor: engine [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractMeshVertexData >> engine: anEngine [
]

{ #category : #'as yet unclassified' }
WDCAbstractMeshVertexData >> exportModelWith: exporter [
	self subclassResponsibility
]

{ #category : #testing }
WDCAbstractMeshVertexData >> hasVertexColors [
	^ false
]

{ #category : #testing }
WDCAbstractMeshVertexData >> hasVertexNormals [
	^ false
]

{ #category : #testing }
WDCAbstractMeshVertexData >> hasVertexTangents [
	^ false
]

{ #category : #'vertex data channels' }
WDCAbstractMeshVertexData >> normals [
	self subclassResponsibility
]

{ #category : #'vertex data channels' }
WDCAbstractMeshVertexData >> positions [
	self subclassResponsibility
]

{ #category : #'vertex manipulations' }
WDCAbstractMeshVertexData >> scaleBy: scaleFactor [
	self scaleByX: scaleFactor y: scaleFactor z: scaleFactor
]

{ #category : #'vertex manipulations' }
WDCAbstractMeshVertexData >> scaleByX: xScale y: yScale z: zScale [
	self applyTransform: (ReversibleAffineTransform3dF32 identity scaleByX: xScale y: yScale z: zScale)
]

{ #category : #accessing }
WDCAbstractMeshVertexData >> size [
	self subclassResponsibility
]

{ #category : #'vertex data channels' }
WDCAbstractMeshVertexData >> tangents4 [
	self subclassResponsibility
]

{ #category : #'vertex data channels' }
WDCAbstractMeshVertexData >> texcoords [
	self subclassResponsibility
]

{ #category : #'vertex manipulations' }
WDCAbstractMeshVertexData >> transformNormalsWith: aTransform [
	self tangents4 ifNil: [ 
		self transformOnlyNormalsWith: aTransform
	] ifNotNil: [ 
		self transformTBNWith: aTransform
	]
]

{ #category : #'vertex manipulations' }
WDCAbstractMeshVertexData >> transformOnlyNormalsWith: aTransform [
	| normals normal transformedNormal |
	normals := self normals.
	1 to: normals size do: [ :index |
		normal := normals at: index.
		transformedNormal := aTransform transformPosition: normal.
		normals at: index put: transformedNormal
	]

]

{ #category : #'vertex manipulations' }
WDCAbstractMeshVertexData >> transformPositionsWith: aTransform [
	| positions position transformedPosition |
	positions := self positions.
	1 to: positions size do: [ :index |
		position := positions at: index.
		transformedPosition := aTransform transformPosition: position.
		positions at: index put: transformedPosition
	]
]

{ #category : #'vertex manipulations' }
WDCAbstractMeshVertexData >> transformTBNWith: aTransform [
	| normals tangents4 normal tangent4 tangent bitangent transformedNormal transformedTangent transformedBitangent transformedTangent4 |
	normals := self normals.
	tangents4 := self tangents4.
	self assert: normals size = tangents4 size.
	1 to: normals size do: [ :index |
		normal := normals at: index.
		tangent4 := tangents4 at: index.
		tangent := Float32x3 x: tangent4 x y: tangent4 y z: tangent4 z.
		bitangent := (normal cross: tangent) * tangent4 w.
		
		transformedNormal := (aTransform transformNormal: normal) normalized.
		transformedTangent := (aTransform transformNormal: tangent) normalized.
		transformedBitangent := (aTransform transformNormal: bitangent) normalized.

		transformedTangent4 := self computeTangent4WithTangent: transformedTangent bitangent: transformedBitangent normal: transformedNormal.
		tangents4 at: index put: transformedTangent4
	].
]
