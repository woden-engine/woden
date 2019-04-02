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

{ #category : #rendering }
WDSGSpatialObjectCompositeMeshGroup >> invalidateRenderable [
	renderable ifNotNil: #invalidate
]

{ #category : #testing }
WDSGSpatialObjectCompositeMeshGroup >> isCompositeGroup [
	^ true
]

{ #category : #adding }
WDSGSpatialObjectCompositeMeshGroup >> removeChild: aChild [
	super removeChild: aChild.
	self invalidateRenderable
]

{ #category : #rendering }
WDSGSpatialObjectCompositeMeshGroup >> renderOn: stateTracker [
	self validateRenderable.
	^ super renderOn: stateTracker
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
