Class {
	#name : #WTGBrushFaceTextureTransform,
	#superclass : #Object,
	#instVars : [
		'face',
		'scale',
		'offset',
		'rotation',
		'lock'
	],
	#classVars : [
		'UDirections',
		'VDirections',
		'VectorDirections'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #'class initialization' }
WTGBrushFaceTextureTransform class >> initialize [
	"
	self initialize.
	"
	super initialize.
	
	VectorDirections := { 
		WMVector3D x: 1.0 y: 0.0 z: 0.0 .
		WMVector3D x: -1.0 y: 0.0 z: 0.0 .
		WMVector3D x: 0.0 y: 1.0 z: 0.0 .
		WMVector3D x: 0.0 y: -1.0 z: 0.0 .
		WMVector3D x: 0.0 y: 0.0 z: 1.0 .
		WMVector3D x: 0.0 y: 0.0 z: -1.0 .
	 }.
	
	UDirections := { 
		WMVector3D x: 0.0 y: 0.0 z: 1.0 .
		WMVector3D x: 0.0 y: 0.0 z: 1.0 .
		WMVector3D x: 1.0 y: 0.0 z: 0.0 .
		WMVector3D x: 1.0 y: 0.0 z: 0.0 .
		WMVector3D x: 1.0 y: 0.0 z: 0.0 .
		WMVector3D x: 1.0 y: 0.0 z: 0.0 .
	}.
	
	VDirections := (1 to: 6) collect: [ :i | (VectorDirections at: i) cross: (UDirections at: i)] 
]

{ #category : #serialization }
WTGBrushFaceTextureTransform class >> loadFromJson: jsonData [
	^ self new loadFromJson: jsonData
]

{ #category : #converting }
WTGBrushFaceTextureTransform >> asJsonData [
	^ OrderedDictionary newFromPairs: { 
		'scale' . scale asJsonData . 
		'offset' . offset asJsonData .
		'rotation' . rotation .
		'lock' . lock .
	}
]

{ #category : #converting }
WTGBrushFaceTextureTransform >> asMatrixForNormal: aNormal [
	| tangents u v|
	tangents := self findTangents: aNormal.
	u := tangents first.
	v := tangents second.
	
	^ self textureMatrix4 * (WMMatrix4D newFrom: { 
		u x . u y . u z . 0.0 .
		v x . v y . v z . 0.0 .
		0.0 . 0.0 . 1.0 . 0.0 .
		0.0 . 0.0 . 0.0 . 1.0
	 }).
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> face [
	^ face
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> face: anObject [
	face := anObject
]

{ #category : #private }
WTGBrushFaceTextureTransform >> findDirectionIndex: aVector [
	| best bestIndex amount |
	best := -5.
	bestIndex := -1.
	1 to: 6 do: [ :i |
		amount := aVector dot: (VectorDirections at: i).
		amount > best ifTrue: [ 
			best := amount.
			bestIndex := i.
		]
	].

	self assert: bestIndex >= 1.
	^ bestIndex
]

{ #category : #private }
WTGBrushFaceTextureTransform >> findTangents: aNormal [
	| dirIndex ui vi u v |
	dirIndex := self findDirectionIndex: aNormal .
	
	"Initial candidate for the direction"
	ui := UDirections at: dirIndex.
	vi := VDirections at: dirIndex.
	
	"Gram-Schmidth orthogonalization for better tangent vectors."
	u := (ui - (aNormal * (aNormal dot: ui))) normalized.
	v := (vi - (aNormal * (aNormal dot: vi)) - (u * (u dot: vi))) normalized.
	^ { u . v }
]

{ #category : #initialization }
WTGBrushFaceTextureTransform >> initialize [
	super initialize.
	scale := WMVector2D x: 1.0 y: 1.0.
	offset := WMVector2D new.
	rotation := 0.0.
	lock := false.
]

{ #category : #private }
WTGBrushFaceTextureTransform >> invalidateModels [
	face ifNotNil: [ face invalidateTexturedModel ]
]

{ #category : #serialization }
WTGBrushFaceTextureTransform >> loadFromJson: jsonData [
	scale := WMVector2D loadFromJson: (jsonData at: 'scale').
	offset := WMVector2D loadFromJson: (jsonData at: 'offset').
	rotation := jsonData at: 'rotation'.
	lock := jsonData at: 'lock'.
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> offset [
	^ offset
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> offset: anObject [
	offset := anObject.
	self invalidateModels
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> rotation [
	^ rotation
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> rotation: anObject [
	rotation := anObject.
	self invalidateModels.
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> scale [
	^ scale
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> scale: anObject [
	scale := anObject.
	self invalidateModels.
]

{ #category : #private }
WTGBrushFaceTextureTransform >> textureMatrix4 [
	| c s sx sy ox oy|
	c := rotation degreeCos.
	s := rotation degreeSin.
	sx := scale x.
	sy := scale y.
	ox := offset x.
	oy := offset y.
	^ WMMatrix4D newFrom: {
		c * sx . s negated * sy . 0.0 . ox .
		s * sx . c * sy . 0.0 . oy .
		0.0 . 0.0 . 1.0 . 0.0 .
		0.0 . 0.0 . 0.0 . 1.0 .
	 }
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> xOffset [
	^ offset x
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> xOffset: aFloat [
	offset x: aFloat.
	self invalidateModels
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> xScale [
	^ scale x
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> xScale: aFloat [
	scale x: aFloat.
	self invalidateModels
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> yOffset [
	^ offset y
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> yOffset: aFloat [
	offset y: aFloat.
	self invalidateModels
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> yScale [
	^ scale y
]

{ #category : #accessing }
WTGBrushFaceTextureTransform >> yScale: aFloat [
	scale y: aFloat.
	self invalidateModels
]
