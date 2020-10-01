Class {
	#name : #WDCTerrainData,
	#superclass : #WDCResourceWithDependants,
	#instVars : [
		'engine',
		'heightMap',
		'splatterMap',
		'heightScale',
		'heightMapScale',
		'heightMapOffset',
		'heightOffset',
		'terrainExtent',
		'minHeight',
		'maxHeight',
		'clipMapLevels',
		'collisionShape'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCTerrainData class >> textureExtent: textureExtent heightRenderWith: aBlock [
	| heightMapData |
	heightMapData := WDCTextureData extent: textureExtent heightRenderWith: aBlock.
	^ self new
		heightMap: heightMapData
]

{ #category : #'mesh building' }
WDCTerrainData >> buildTerrainMeshWith: builder [
	self doBuildTerrainMeshWith: builder cellSize: self terrainCellSize
]

{ #category : #'mesh building' }
WDCTerrainData >> buildWaterMeshWith: builder [
	self doBuildTerrainMeshWith: builder cellSize: (Float32x3 x: 0.1 y: 0.1)
]

{ #category : #accessing }
WDCTerrainData >> clipMapLevels [
	^ clipMapLevels
]

{ #category : #accessing }
WDCTerrainData >> clipMapLevels: anObject [
	clipMapLevels := anObject
]

{ #category : #accessing }
WDCTerrainData >> collisionShape [
	heightMap ifNil: [ ^ nil ].
	engine ifNil: [ ^ nil ].
	
	collisionShape ifNil: [ 
		collisionShape := WDCAbstractGeometryBuilder new createHeightMapCollision: heightMap heightScale: heightScale minHeight: minHeight maxHeight: maxHeight scale: self heightMapScale offset: self heightMapOffset.
	].

	^ collisionShape
]

{ #category : #accessing }
WDCTerrainData >> computeTerrainClipMapMagnificationFactors [
	
	| r1 s1 s2 r2 sn rn |
	r1 := 1.0.
	s1 := r1*2.0.
	clipMapLevels = 1 ifTrue: [ ^ { r1 . s1 } ].
	
	r2 := r1 + s1.
	s2 := s1.
	
	sn := s2.
	rn := r2.
	3 to: clipMapLevels  do: [ :i |
		rn := rn + sn.
		sn := 3*sn.
	].
	^ { rn . sn }
]

{ #category : #'mesh building' }
WDCTerrainData >> createTerrainMeshWithMaterial: material [
	| builder terrainMesh |
	builder := WDCTerrainMeshBuilder for: engine.
	builder material: material.
	self buildTerrainMeshWith: builder.
	terrainMesh := builder terrainMesh.
	terrainMesh deformationState
		terrainData: self;
		yourself.
	^ terrainMesh
		
]

{ #category : #'mesh building' }
WDCTerrainData >> doBuildTerrainMeshWith: builder cellSize: cellSize [
	| magnificationFactors firstLevelExtent firstLevelSubdivisions firstLevelSubdivisionsPower |
	builder
		minHeight: minHeight;
		maxHeight: maxHeight.

	clipMapLevels > 0 ifTrue: [ 
		magnificationFactors := self computeTerrainClipMapMagnificationFactors.
		firstLevelExtent := terrainExtent / (magnificationFactors first * 2.0).
		firstLevelSubdivisions := firstLevelExtent / cellSize.
		firstLevelSubdivisionsPower := ((firstLevelSubdivisions x max: firstLevelSubdivisions y) ceiling asLargerPowerOfTwo max: (1 << (clipMapLevels + 1))) min: 256.
		
		builder
			createClipMapWithLevels: clipMapLevels size: firstLevelExtent subdivisions: firstLevelSubdivisionsPower;
			terrainExtent: terrainExtent
	] ifFalse: [
		builder createGridWithSize: terrainExtent subdivisions: (heightMap width max: heightMap height)
	].

]

{ #category : #accessing }
WDCTerrainData >> engine [
	^ engine
]

{ #category : #accessing }
WDCTerrainData >> engine: anObject [
	engine := anObject.
	
	heightMap ifNotNil: [ heightMap := heightMap asTextureFor: engine ].
	splatterMap ifNotNil: [ splatterMap := splatterMap asTextureFor: engine ].
]

{ #category : #accessing }
WDCTerrainData >> heightMap [
	^ heightMap
]

{ #category : #accessing }
WDCTerrainData >> heightMap: anObject [
	heightMap := anObject
]

{ #category : #accessing }
WDCTerrainData >> heightMapOffset [
	heightMapOffset ifNil: [ self validateCoordinateTransform  ].
	^ heightMapOffset
]

{ #category : #accessing }
WDCTerrainData >> heightMapScale [
	heightMapScale ifNil: [ self validateCoordinateTransform  ].
	^ heightMapScale
]

{ #category : #accessing }
WDCTerrainData >> heightOffset [
	heightOffset ifNil: [ self validateHeightTransform ].
	^ heightOffset
]

{ #category : #accessing }
WDCTerrainData >> heightScale [
	heightScale ifNil: [ self validateHeightTransform ].
	^ heightScale
]

{ #category : #initialization }
WDCTerrainData >> initialize [
	super initialize.
	terrainExtent := Float32x2 ones.
	minHeight := 0.0.
	maxHeight := 1.0.

	heightMapScale := nil.
	heightMapOffset := nil.
	heightOffset := nil.
	heightScale := nil.
	clipMapLevels := 0.

]

{ #category : #private }
WDCTerrainData >> invalidateCoordinateTransform [
	heightMapScale := nil.
	heightMapOffset := nil.
]

{ #category : #private }
WDCTerrainData >> invalidateHeightTransform [
	heightScale := nil.
	heightOffset := nil.
]

{ #category : #accessing }
WDCTerrainData >> maxHeight [
	^ maxHeight
]

{ #category : #accessing }
WDCTerrainData >> maxHeight: anObject [
	maxHeight := anObject.
	self invalidateHeightTransform.
]

{ #category : #accessing }
WDCTerrainData >> minHeight [
	^ minHeight
]

{ #category : #accessing }
WDCTerrainData >> minHeight: anObject [
	minHeight := anObject.
	self invalidateHeightTransform.
]

{ #category : #accessing }
WDCTerrainData >> splatterMap [
	^ splatterMap
]

{ #category : #accessing }
WDCTerrainData >> splatterMap: anObject [
	splatterMap := anObject
]

{ #category : #accessing }
WDCTerrainData >> terrainCellSize [
	heightMap ifNil: [ ^ Float32x2 ones ].
	^ terrainExtent / heightMap extent asFloat32x2
]

{ #category : #accessing }
WDCTerrainData >> terrainExtent [
	^ terrainExtent
]

{ #category : #accessing }
WDCTerrainData >> terrainExtent: anObject [
	terrainExtent := anObject asFloat32x2.
	self invalidateCoordinateTransform.
]

{ #category : #private }
WDCTerrainData >> validateCoordinateTransform [
	heightMapScale := Float32x2 ones / (terrainExtent * 0.5).
	heightMapOffset := Float32x2 zero.
]

{ #category : #private }
WDCTerrainData >> validateHeightTransform [
	heightScale := maxHeight - minHeight.
	(heightMap isNotNil and: [ heightMap hasSignedHeightFieldFormat ]) ifTrue: [ 
		heightOffset := (maxHeight + minHeight) * 0.5.
		heightScale := heightScale * 0.5
	] ifFalse: [
		heightOffset := minHeight
	].


]
