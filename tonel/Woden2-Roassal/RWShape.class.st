Class {
	#name : #RWShape,
	#superclass : #RWObject,
	#instVars : [
		'color',
		'transparencyMode'
	],
	#classVars : [
		'AdditiveAlphaTransparencyMode',
		'AdditiveTransparencyMode',
		'AlphaOverTransparencyMode',
		'OpaqueTransparencyMode'
	],
	#category : 'Woden2-Roassal-Core'
}

{ #category : #accessing }
RWShape class >> additiveAlphaTransparencyMode [
	^ AdditiveAlphaTransparencyMode

]

{ #category : #accessing }
RWShape class >> additiveTransparencyMode [
	^ AdditiveTransparencyMode

]

{ #category : #accessing }
RWShape class >> alphaOverTransparencyMode [
	^ AlphaOverTransparencyMode
]

{ #category : #'instance creation' }
RWShape class >> black [
	^ self new color: Color black
]

{ #category : #'instance creation' }
RWShape class >> blue [
	^ self new color: Color blue
]

{ #category : #'instance creation' }
RWShape class >> cyan [
	^ self new color: Color cyan
]

{ #category : #public }
RWShape class >> element [
	^ self new element
]

{ #category : #public }
RWShape class >> elementOn: anObject [
	^ self new elementOn: anObject
]

{ #category : #public }
RWShape class >> elementsOn: objects [
	^ self new elementsOn: objects
]

{ #category : #'instance creation' }
RWShape class >> green [
	^ self new color: Color green
]

{ #category : #'class initialization' }
RWShape class >> initialize [
	"
	self initialize
	"
	super initialize.
	
	OpaqueTransparencyMode := #blendingReplace.
	AdditiveTransparencyMode := #blendingAdditive.
	AdditiveAlphaTransparencyMode := #blendingAdditiveAlpha.
	AlphaOverTransparencyMode := #blendingOver.
]

{ #category : #'instance creation' }
RWShape class >> magenta [
	^ self new color: Color magenta
]

{ #category : #accessing }
RWShape class >> opaqueTransparencyMode [
	^ OpaqueTransparencyMode
]

{ #category : #'instance creation' }
RWShape class >> red [
	^ self new color: Color red
]

{ #category : #'instance creation' }
RWShape class >> white [
	^ self new color: Color white
]

{ #category : #'instance creation' }
RWShape class >> yellow [
	^ self new color: Color yellow
]

{ #category : #'changing transparency' }
RWShape >> alphaOverTranslucent [
	self transparencyMode: AlphaOverTransparencyMode
]

{ #category : #computing }
RWShape >> boundingBoxFor: element [
	self subclassResponsibility
]

{ #category : #hooks }
RWShape >> buildCollisionShapeFor: element [
	self subclassResponsibility
]

{ #category : #hooks }
RWShape >> buildRenderableFor: anElement view: aView [

	self subclassResponsibility
]

{ #category : #'changing shape' }
RWShape >> changedElement: element sceneNode: sceneNode renderable: renderable [
	"This is used to change an element shape."
]

{ #category : #accessing }
RWShape >> color [
	^ color
]

{ #category : #accessing }
RWShape >> color: aValueOrASymbolOrAOneArgBlock [
	"aValueOrASymbolOrAOneArgBlock is applied on the object model"
	self colorElement: [ :anElement | aValueOrASymbolOrAOneArgBlock rwValue: anElement model ]
]

{ #category : #accessing }
RWShape >> colorElement: aValueOrASymbolOrAOneArgBlock [
	color := aValueOrASymbolOrAOneArgBlock
]

{ #category : #computing }
RWShape >> colorFor: anElement [
	^ color rwValue: anElement
]

{ #category : #public }
RWShape >> element [
	^ self elementOn: nil
]

{ #category : #public }
RWShape >> elementOn: anObject [
	^ RWElement new
			model: anObject;
			shape: self;
			yourself
]

{ #category : #public }
RWShape >> elementsOn: objects [
	^ (objects collect: [ :o | self elementOn: o ]) asRWGroup
]

{ #category : #accessing }
RWShape >> fillColor: arg [
	^ self color: arg
]

{ #category : #accessing }
RWShape >> fillColorElement: arg [
	^ self colorElement: arg
]

{ #category : #initialization }
RWShape >> initialize [
	super initialize.
	transparencyMode := OpaqueTransparencyMode.
]

{ #category : #'changing transparency' }
RWShape >> isAlphaOverTranslucent [
	^ self transparencyMode == AlphaOverTransparencyMode
]

{ #category : #'changing transparency' }
RWShape >> isOpaque [
	^ transparencyMode == OpaqueTransparencyMode
]

{ #category : #'changing transparency' }
RWShape >> isTranslucent [
	^ self transparencyMode == AdditiveAlphaTransparencyMode
]

{ #category : #'changing transparency' }
RWShape >> opaque [
	self transparencyMode: OpaqueTransparencyMode
]

{ #category : #'changing transparency' }
RWShape >> setupTransparency: node renderable: renderable [
	"aWDRenderable blendingMode: transparencyMode."
	self flag: 'TODO: Make proper changes in the renderable'.
	self isTranslucent ifTrue: [ 
		node translucentRenderPriority
	].
	self isAlphaOverTranslucent ifTrue: [ 
		node translucentRenderPriority
	].

]

{ #category : #'changing transparency' }
RWShape >> translucent [
	self transparencyMode: AdditiveAlphaTransparencyMode
]

{ #category : #accessing }
RWShape >> transparencyMode [
	^ transparencyMode
]

{ #category : #accessing }
RWShape >> transparencyMode: aTransparencyMode [
	transparencyMode := aTransparencyMode
]
