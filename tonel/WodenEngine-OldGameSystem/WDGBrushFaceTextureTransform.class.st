Class {
	#name : #WDGBrushFaceTextureTransform,
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
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #'class initialization' }
WDGBrushFaceTextureTransform class >> initialize [
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
WDGBrushFaceTextureTransform class >> loadFromJson: jsonData [
	^ self new loadFromJson: jsonData
]

{ #category : #converting }
WDGBrushFaceTextureTransform >> asJsonData [
	^ OrderedDictionary newFromPairs: { 
		'scale' . scale asJsonData . 
		'offset' . offset asJsonData .
		'rotation' . rotation .
		'lock' . lock .
	}
]

{ #category : #converting }
WDGBrushFaceTextureTransform >> asMatrixForNormal: aNormal [
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
WDGBrushFaceTextureTransform >> face [
	^ face
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> face: anObject [
	face := anObject
]

{ #category : #private }
WDGBrushFaceTextureTransform >> findDirectionIndex: aVector [
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
WDGBrushFaceTextureTransform >> findTangents: aNormal [
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
WDGBrushFaceTextureTransform >> initialize [
	super initialize.
	scale := WMVector2D x: 1.0 y: 1.0.
	offset := WMVector2D new.
	rotation := 0.0.
	lock := false.
]

{ #category : #private }
WDGBrushFaceTextureTransform >> invalidateModels [
	face ifNotNil: [ face invalidateTexturedModel ]
]

{ #category : #serialization }
WDGBrushFaceTextureTransform >> loadFromJson: jsonData [
	scale := WMVector2D loadFromJson: (jsonData at: 'scale').
	offset := WMVector2D loadFromJson: (jsonData at: 'offset').
	rotation := jsonData at: 'rotation'.
	lock := jsonData at: 'lock'.
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> offset [
	^ offset
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> offset: anObject [
	offset := anObject.
	self invalidateModels
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> rotation [
	^ rotation
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> rotation: anObject [
	rotation := anObject.
	self invalidateModels.
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> scale [
	^ scale
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> scale: anObject [
	scale := anObject.
	self invalidateModels.
]

{ #category : #private }
WDGBrushFaceTextureTransform >> textureMatrix4 [
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
WDGBrushFaceTextureTransform >> xOffset [
	^ offset x
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> xOffset: aFloat [
	offset x: aFloat.
	self invalidateModels
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> xScale [
	^ scale x
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> xScale: aFloat [
	scale x: aFloat.
	self invalidateModels
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> yOffset [
	^ offset y
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> yOffset: aFloat [
	offset y: aFloat.
	self invalidateModels
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> yScale [
	^ scale y
]

{ #category : #accessing }
WDGBrushFaceTextureTransform >> yScale: aFloat [
	scale y: aFloat.
	self invalidateModels
]
