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

{ #category : #'as yet unclassified' }
WDSGSpatialObject >> exportNodeElementsWith: exporter [
	super exportNodeElementsWith: exporter.
	exporter renderable: renderable.
]

{ #category : #initialization }
WDSGSpatialObject >> initialize [
	super initialize.
	renderable := WDCNullRenderable new.
	renderingRenderables := #().
]

{ #category : #'as yet unclassified' }
WDSGSpatialObject >> localBoundingBox [
	^ renderable boundingBox
]

{ #category : #copying }
WDSGSpatialObject >> postCopy [
	| oldRenderable |
	oldRenderable := renderable.
	renderingRenderables := #().
	super postCopy.
	self renderable: oldRenderable copyForResourceCacheInstancing.
]

{ #category : #enumerating }
WDSGSpatialObject >> precacheResources [
	renderable precacheResources
]

{ #category : #accessing }
WDSGSpatialObject >> renderable [
	^ renderable
]

{ #category : #accessing }
WDSGSpatialObject >> renderable: aRenderable [
	self sceneLayer ifNotNil: [ :sceneLayer |
		sceneLayer removeRenderingRenderables: self renderingRenderables
	].

	renderable := aRenderable.
	renderingRenderables := renderable createRenderingRenderablesFor: objectState.
	renderingRenderables do: [ :rr | rr node: self ].
	self sceneLayer ifNotNil: [ :sceneLayer |
		sceneLayer addRenderingRenderables: self renderingRenderables
	].

]

{ #category : #accessing }
WDSGSpatialObject >> renderingRenderables [
	^ renderingRenderables
]
