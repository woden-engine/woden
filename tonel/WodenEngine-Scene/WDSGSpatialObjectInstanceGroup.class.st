"
I take care of binding all of the per-instance data of a group of objects.
"
Class {
	#name : #WDSGSpatialObjectInstanceGroup,
	#superclass : #WDSGSpatialObject,
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #'as yet unclassified' }
WDSGSpatialObjectInstanceGroup >> addChild: aChild [
	super addChild: aChild.
	objectState addChild: aChild objectState.
]

{ #category : #initialization }
WDSGSpatialObjectInstanceGroup >> createSpatialObjectState [
	objectState := WDCInstanceGroupSpatialObject new
]

{ #category : #accessing }
WDSGSpatialObjectInstanceGroup >> depthSorted: aBoolean [
	objectState depthSorted: aBoolean
]

{ #category : #'as yet unclassified' }
WDSGSpatialObjectInstanceGroup >> exportNodeElementsWith: exporter [
	exporter
		visible: self visible;
		transform: self transform
]

{ #category : #testing }
WDSGSpatialObjectInstanceGroup >> isInstanceGroup [
	^ true
]

{ #category : #'as yet unclassified' }
WDSGSpatialObjectInstanceGroup >> removeChild: aChild [
	super removeChild: aChild.
	objectState removeChild: aChild objectState
]

{ #category : #'as yet unclassified' }
WDSGSpatialObjectInstanceGroup >> updatedPerFrame [
	^ objectState updatedPerFrame
]

{ #category : #'as yet unclassified' }
WDSGSpatialObjectInstanceGroup >> updatedPerFrame: aBoolean [
	objectState updatedPerFrame: aBoolean
]

{ #category : #enumerating }
WDSGSpatialObjectInstanceGroup >> withAllVisibleRenderingChildrenDo: aBlock [
	visible ifFalse: [ ^ self ].
	aBlock value: self.
]
