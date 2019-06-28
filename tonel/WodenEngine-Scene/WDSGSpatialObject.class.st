"
I am a node  that poses a local coordinate system that is associated with a model matrix in the GPU.
"
Class {
	#name : #WDSGSpatialObject,
	#superclass : #WDSGAbstractSpatialObject,
	#instVars : [
		'renderable',
		'renderingRenderables'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #testing }
WDSGSpatialObject >> canBeRendered [
	^ true
]

{ #category : #initialization }
WDSGSpatialObject >> createSpatialObjectState [
	objectState := WDCSpatialObject new
]

{ #category : #adding }
WDSGSpatialObject >> engineChanged [
	super engineChanged.
	objectState engine: scene engine. 
	renderable ifNotNil: [
		renderable engine: scene engine
	].
]

{ #category : #initialization }
WDSGSpatialObject >> initialize [
	super initialize.
	renderable := WDCNullRenderable new.
	renderingRenderables := #().
]

{ #category : #accessing }
WDSGSpatialObject >> renderable [
	^ renderable
]

{ #category : #accessing }
WDSGSpatialObject >> renderable: aRenderable [
	scene ifNotNil: [ scene removeRenderingRenderables: self renderingRenderables ].
	renderable := aRenderable.
	renderingRenderables := renderable createRenderingRenderablesFor: objectState.
	renderingRenderables do: [ :rr | rr node: self ].
	scene ifNotNil: [ scene addRenderingRenderables: self renderingRenderables ].

]

{ #category : #accessing }
WDSGSpatialObject >> renderingRenderables [
	^ renderingRenderables
]
