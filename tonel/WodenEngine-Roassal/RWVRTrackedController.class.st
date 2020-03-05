Class {
	#name : #RWVRTrackedController,
	#superclass : #RWVRTrackedDevice,
	#instVars : [
		'cursorColor',
		'triggerPressed',
		'triggerTouched',
		'cursorNode',
		'dragElement',
		'movingForward'
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

{ #category : #'as yet unclassified' }
RWVRTrackedController >> elementPointedByCursor [
	| ray view distanceAndElement |
	ray := WMRayF origin: element position
		direction: (element orientation transformVector3: (WMVector3F z: -1.0)).
	view := element view.
	view ifNil: [ ^ nil ].

	distanceAndElement := view rayCast: ray satisfying: [:el | el ~~ element ].
	^ distanceAndElement value
]

{ #category : #initialization }
RWVRTrackedController >> initialize [
	super initialize.
	triggerPressed := false.
	triggerTouched := false.
	movingForward := false.
	self updateCursor.
]

{ #category : #'as yet unclassified' }
RWVRTrackedController >> onVRButtonPressedEvent: event [
	event isSteamVRTouchpad ifTrue: [ 
		movingForward := true.
	].

	event isSteamVRTrigger ifTrue: [
		triggerPressed := true.
		self updateCursor.
		
		dragElement := self elementPointedByCursor.
	].
]

{ #category : #'as yet unclassified' }
RWVRTrackedController >> onVRButtonReleasedEvent: event [
	event isSteamVRTouchpad ifTrue: [
		movingForward := false.
	].

	event isSteamVRTrigger ifTrue: [
		triggerPressed := false.
		dragElement := nil.
		self updateCursor.
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
RWVRTrackedController >> sendCursorOverElements: moveEvent [
	| elementBeingPointed |
	elementBeingPointed := self elementPointedByCursor.
	elementBeingPointed ifNil: [ elementBeingPointed := element view ].
	sceneView dispatchMouseOverElementsEvent: moveEvent newElement: elementBeingPointed
]

{ #category : #accessing }
RWVRTrackedController >> sendDragElementEvent: moveEvent [
	Transcript show: 'TODO: sendDragElementEvent '; cr.
]

{ #category : #accessing }
RWVRTrackedController >> transformChanged [
	| moveEvent |
	(triggerPressed or: [ triggerTouched ]) ifFalse: [ ^ self ].
	moveEvent := RWMouseMove new
		position: (sceneView projectPointToScreen: element position);
		delta: 0@0;
		yourself.
	dragElement
		ifNotNil: [ self sendDragElementEvent: moveEvent ]
		ifNil: [ self sendCursorOverElements: moveEvent ]
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

{ #category : #'rendering process stages' }
RWVRTrackedController >> updateForFrameDelta: delta [
	| direction |
	movingForward ifTrue: [
		direction := sceneView camera orientation transformVector3: (WMVector3F z: -1.0).
		sceneView vrCameraBaseTransform translateBy: direction * delta * 2.0.
	].
]
