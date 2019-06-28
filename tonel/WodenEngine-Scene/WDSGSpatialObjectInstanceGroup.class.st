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
	self halt.
]

{ #category : #initialization }
WDSGSpatialObjectInstanceGroup >> createSpatialObjectState [
	objectState := WDCLocalSpatialObject new
]

{ #category : #testing }
WDSGSpatialObjectInstanceGroup >> isInstanceGroup [
	^ true
]

{ #category : #'as yet unclassified' }
WDSGSpatialObjectInstanceGroup >> removeChild: aChild [
	super removeChild: aChild.
	self halt
]

{ #category : #rendering }
WDSGSpatialObjectInstanceGroup >> renderOn: commandList mode: renderMode submode: submode [
	renderable ifNil: [ ^ self ].
	
	commandList
		useShaderResources: self currentObjectStateBinding validHandle.
		
	renderable renderOn: commandList mode: renderMode submode: submode instanceCount: children size baseInstance: 0 baseVertex: 0
]

{ #category : #enumerating }
WDSGSpatialObjectInstanceGroup >> withAllVisibleRenderingChildrenDo: aBlock [
	visible ifFalse: [ ^ self ].
	aBlock value: self.
]
