Class {
	#name : #RWVRTrackedController,
	#superclass : #RWVRTrackedDevice,
	#instVars : [
		'cursorColor',
		'triggerPressed',
		'triggerTouched',
		'cursorNode'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #adding }
RWVRTrackedController >> addToView: aView [
	| cursorMesh |
	shape := (RWMeshShape for: aView buildWith: [ :builder |
		builder addCubeWithWidth: 0.1 height: 0.1 depth: 0.1
	]).
	element := shape elementOn: self.
	aView addInternalElement: element.
	
	cursorMesh := (WDCComplexGenericMeshBuilder for: aView engine)
		material: WDCFlatColorMaterial new;
		translateToX: 0.0 y: 0.0 z: -50.0;
		addCubeWithWidth: 0.02 height: 0.02 depth: 100.0;
		computeBoundingBox;
		mesh.
	cursorNode := WDSGSpatialObject new
		visible: false;
		color: cursorColor asWMVector4F;
		renderable: cursorMesh;
		yourself.
	element sceneNode addChild: cursorNode.
]

{ #category : #accessing }
RWVRTrackedController >> cursorColor [
	^ cursorColor
]

{ #category : #accessing }
RWVRTrackedController >> cursorColor: anObject [
	cursorColor := anObject.
	cursorNode ifNotNil: [ 
		cursorNode
			color: cursorColor asWMVector4F;
			stateChanged
	]
]

{ #category : #initialization }
RWVRTrackedController >> initialize [
	super initialize.
	triggerPressed := false.
	triggerTouched := false.
	self updateCursor.
]

{ #category : #'as yet unclassified' }
RWVRTrackedController >> onVRButtonPressedEvent: event [
	event isSteamVRTrigger ifTrue: [
		triggerPressed := true.
		self updateCursor
	].
]

{ #category : #'as yet unclassified' }
RWVRTrackedController >> onVRButtonReleasedEvent: event [
	event isSteamVRTrigger ifTrue: [
		triggerPressed := false.
		self updateCursor
	].

]

{ #category : #'as yet unclassified' }
RWVRTrackedController >> onVRButtonTouchEvent: event [
	event isSteamVRTrigger ifTrue: [
		triggerTouched := true.
		self updateCursor
	].
]

{ #category : #'as yet unclassified' }
RWVRTrackedController >> onVRButtonUntouchEvent: event [
	event isSteamVRTrigger ifTrue: [
		triggerTouched := false.
		self updateCursor
	].
]

{ #category : #accessing }
RWVRTrackedController >> transformChanged [
]

{ #category : #'as yet unclassified' }
RWVRTrackedController >> updateCursor [
	self cursorColor: (triggerPressed ifTrue: [
		WMVector4F x: 0.8 y: 0.3 z: 0.3 w: 1.0
	] ifFalse: [
		triggerTouched
			ifTrue: [WMVector4F x: 0.3 y: 0.8 z: 0.3 w: 1.0]
			ifFalse: [WMVector4F x: 0.8 y: 0.8 z: 0.8 w: 1.0 ]
	]).
	cursorNode ifNotNil: [ 
		cursorNode visible: (triggerPressed or: triggerTouched)
	].

]
