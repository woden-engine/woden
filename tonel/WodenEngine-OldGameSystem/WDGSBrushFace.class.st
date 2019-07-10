Class {
	#name : #WDGSBrushFace,
	#superclass : #WDGSSubComponent,
	#instVars : [
		'brush',
		'indices',
		'plane',
		'material',
		'textureTransform',
		'materialCache'
	],
	#classVars : [
		'Epsilon'
	],
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #serialization }
WDGSBrushFace class >> fuelIgnoredInstanceVariableNames [
	^ #('materialCache')
]

{ #category : #'class initialization' }
WDGSBrushFace class >> initialize [
	"
	self initialize
	"
	super initialize.
	Epsilon := 0.0000001.
]

{ #category : #serialization }
WDGSBrushFace class >> loadFromJson: jsonData [
	^ self new loadFromJson: jsonData
]

{ #category : #construction }
WDGSBrushFace class >> nx: nx ny: ny nz: nz d: d [
	^ self new plane: (WMPlaneD nx: nx ny: ny nz: nz d: d)
]

{ #category : #construction }
WDGSBrushFace class >> plane: aPlane [
	^ self new plane: aPlane
]

{ #category : #adding }
WDGSBrushFace >> addIndex: index [
	indices add: index
]

{ #category : #adding }
WDGSBrushFace >> addedToBrush: aBrush [
	brush := aBrush
]

{ #category : #serialization }
WDGSBrushFace >> asJsonData [
	^ OrderedDictionary newFromPairs: {
		'plane' . plane asJsonData .
		'material' . material .
		'texture-transform' . textureTransform asJsonData.
	}
]

{ #category : #accessing }
WDGSBrushFace >> brush [
	^ brush
]

{ #category : #rendering }
WDGSBrushFace >> buildSolidModelInto: meshBuilder [
	| positions position normal |
	meshBuilder
		beginTriangles;
		currentColor: self currentColor asWMVector4F.
		
	positions := brush positions.
	normal := plane normal asWMVector3F.
	indices do: [ :i |
		position := (positions at: i + 1) asWMVector3F.
		meshBuilder addP: position N: normal.
	].

	3 to: indices size do:[ :i |
		meshBuilder addI1: 1 i2: i - 1 i3: i
	].

]

{ #category : #rendering }
WDGSBrushFace >> buildTexturedModelInto: meshBuilder [
	| positions position normal texcoord textureMatrix texcoord3 tangentAndBitangent tangent bitangent tangentScaleFactor tangent4 |
	meshBuilder
		currentColor: self currentTexturedColor asWMVector4F;
		material: self validMaterial;
		beginTriangles.
		
	positions := brush positions.
	normal := plane normal asWMVector3F.
	textureMatrix := textureTransform asMatrixForNormal: plane normal.
	tangentAndBitangent := textureTransform findTangents: plane normal.
	tangent := tangentAndBitangent first.
	bitangent := tangentAndBitangent second.
	tangentScaleFactor := (plane normal cross: tangent) dot: bitangent.
	tangent4 := WMVector4F x: tangent x y: tangent y z: tangent z w: tangentScaleFactor.
	
	indices do: [ :i |
		position := positions at: i + 1.
		texcoord3 := textureMatrix transformPosition3: position.
		texcoord := WMVector2F x: texcoord3 x y: texcoord3 y.
		meshBuilder addP: position asWMVector3F N: normal T4: tangent4 TC: texcoord.
	].

	3 to: indices size do:[ :i |
		meshBuilder addI1: 1 i2: i - 1 i3: i
	].

]

{ #category : #rendering }
WDGSBrushFace >> buildWireModelInto: meshBuilder [
	2 to: indices size do: [ :i |
		meshBuilder addI1: (indices at: i - 1) + 1 i2: (indices at: i) + 1
	].

	meshBuilder addI1: indices last + 1 i2: indices first + 1

]

{ #category : #accessing }
WDGSBrushFace >> center [	
	| center |
	center := WMVector3D new.
	1 to: indices size do: [ :i | center := center + (self positionAt: i)].
	^ center / indices size
]

{ #category : #changing }
WDGSBrushFace >> changedSelectionState [
	self invalidateModels
]

{ #category : #'as yet unclassified' }
WDGSBrushFace >> clearIndices [
	indices removeAll.
]

{ #category : #accessing }
WDGSBrushFace >> currentColor [
	^ selected ifTrue: [
		lastSelected
			ifTrue: [ LastSelectionColor ]
			ifFalse: [ SelectionColor ]
	] ifFalse: [ brush currentColor]
]

{ #category : #rendering }
WDGSBrushFace >> currentTexturedColor [
	^  selected ifTrue: [
		lastSelected
			ifTrue: [ LastSelectionColor ]
			ifFalse: [ SelectionColor ]
	] ifFalse: [ brush currentTexturedColor ]
]

{ #category : #iterator }
WDGSBrushFace >> edgesDo: aBlock [
	| start end |
	1 to: indices size do: [ :i |
		start := i.
		end := ((i + 1) % indices size) + 1.
		aBlock value: start value: end
	]
]

{ #category : #'as yet unclassified' }
WDGSBrushFace >> fixWinding [
 	| normal center positions |
	center := self center.
	normal := plane normal.
	positions := brush positions.
	
	indices sort: [ :first :second |
		| a b u v |
		a := positions at: first + 1.
		b := positions at: second + 1.
		u := a - center.
		v := b - center.
		((u cross: v) dot: normal) >= Epsilon negated
	].

]

{ #category : #accessing }
WDGSBrushFace >> indices [
	^ indices
]

{ #category : #initialization }
WDGSBrushFace >> initialize [
	super initialize.
	indices := SLVMNativeOrderedCollection for: #int.
	material := ''.
	textureTransform := WDGBrushFaceTextureTransform new.
	textureTransform face: self.
]

{ #category : #rendering }
WDGSBrushFace >> invalidateModels [
	brush ifNotNil: [ brush invalidateModels ]
]

{ #category : #rendering }
WDGSBrushFace >> invalidateTexturedModel [
	brush ifNotNil: [ brush invalidateTexturedModel ]
]

{ #category : #serialization }
WDGSBrushFace >> loadFromJson: jsonData [
	material := jsonData at: 'material'.
	plane := WMPlaneD loadFromJson: (jsonData at: 'plane').
	textureTransform := WDGBrushFaceTextureTransform loadFromJson: (jsonData at: 'texture-transform').
	
]

{ #category : #accessing }
WDGSBrushFace >> material [
	^ material
]

{ #category : #accessing }
WDGSBrushFace >> material: anObject [
	material := anObject.
	self assert: material isNotNil.
	materialCache := nil.
	self invalidateTexturedModel
]

{ #category : #accessing }
WDGSBrushFace >> plane [
	^ plane
]

{ #category : #accessing }
WDGSBrushFace >> plane: anObject [
	plane := anObject
]

{ #category : #accessing }
WDGSBrushFace >> positionAt: index [
	^ brush positions at: (indices at: index) + 1
]

{ #category : #'as yet unclassified' }
WDGSBrushFace >> positionsDo: aBlock [
	indices do: [ :index | aBlock value: (brush positions at: index + 1) ]
]

{ #category : #copying }
WDGSBrushFace >> postCopy [
	indices := indices copy.
	plane := plane copy.
]

{ #category : #'as yet unclassified' }
WDGSBrushFace >> rebuildPlane [
	| v1 v2 v3 u v n d d2 d3|
	v1 := self positionAt: 1.
	v2 := self positionAt: 2.
	v3 := self positionAt: 3.
	u := v2 - v1.
	v := v3 - v1.
	n := (u cross: v) normalized.
	d := v1 dot: n.
	d2 := v2 dot: n.
	d3 := v3 dot: n.
	plane := WMPlaneD normal: n distance: d.
]

{ #category : #accessing }
WDGSBrushFace >> scene [
	^ brush scene
]

{ #category : #'as yet unclassified' }
WDGSBrushFace >> sideOfPlane: aPlane [
	| front back |
	front := false.
	back := false.
	
	self positionsDo: [ :vert |
		(aPlane isInFront: vert) ifTrue: [ front := true ] ifFalse: [ back := true ].
		(front and: back) ifTrue: [ ^ 0 ].
	].

	(front and: back) ifTrue: [ ^ 0 ].
	^ front ifTrue: [ 1 ] ifFalse: [ -1 ].

]

{ #category : #accessing }
WDGSBrushFace >> textureTransform [
	^ textureTransform
]

{ #category : #accessing }
WDGSBrushFace >> textureTransform: aTextureTransform [
	textureTransform ifNotNil: [ textureTransform face: nil ].
	textureTransform := aTextureTransform copy.
	textureTransform ifNotNil: [ textureTransform face: self ].
	self invalidateTexturedModel.
]

{ #category : #'as yet unclassified' }
WDGSBrushFace >> textureTransformsDo: aBlock [
	aBlock value: textureTransform
]

{ #category : #'as yet unclassified' }
WDGSBrushFace >> validMaterial [
	materialCache ifNotNil: [ ^ materialCache ].
	^ materialCache := brush map loadMaterial: material.
	
]
