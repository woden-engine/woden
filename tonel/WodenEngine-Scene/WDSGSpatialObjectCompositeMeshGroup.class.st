Class {
	#name : #WDSGSpatialObjectCompositeMeshGroup,
	#superclass : #WDSGSpatialObject,
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #adding }
WDSGSpatialObjectCompositeMeshGroup >> addChild: aChild [
	super addChild: aChild.
	self invalidateRenderable
]

{ #category : #'as yet unclassified' }
WDSGSpatialObjectCompositeMeshGroup >> exportNodeElementsWith: exporter [
	self validateRenderable.
	super exportNodeElementsWith: exporter.
]

{ #category : #rendering }
WDSGSpatialObjectCompositeMeshGroup >> invalidateRenderable [
	renderable ifNotNil: #invalidate.
	renderingRenderables do: #renderableChanged.
]

{ #category : #testing }
WDSGSpatialObjectCompositeMeshGroup >> isCompositeGroup [
	^ true
]

{ #category : #copying }
WDSGSpatialObjectCompositeMeshGroup >> postCopy [
	super postCopy.
	self invalidateRenderable.
]

{ #category : #adding }
WDSGSpatialObjectCompositeMeshGroup >> removeChild: aChild [
	super removeChild: aChild.
	self invalidateRenderable
]

{ #category : #changing }
WDSGSpatialObjectCompositeMeshGroup >> stateChanged [
	super stateChanged.
	parent ifNotNil: [ parent invalidateRenderable ]
]

{ #category : #rendering }
WDSGSpatialObjectCompositeMeshGroup >> validateRenderable [
	renderable ifNotNil: [ renderable validateForNode: self ]
]
