"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	baseShapes:		<Object>
	camera:		<RWCamera>  Camera from which the scene is visible
	cameraLight:		<Object>
	dynamicsWorld:		<Object>
	elements:		<Object>
	eventHandler:		<Announcer> take care of the event sent to the view
	fullscreen:		<Object>
	isStereo:		<Object>
	lightCamera:		<Object>
	scene:		<WDScene>	Contains all the elements that are displayed
	sceneRenderer:		<WDSceneRendered> Indicates how the scene can be rendered
	selectionRenderer:		<WDSelectionSceneRenderer> used to identify which object is pointed by the mouse
	signalUpdateCallback:		<Object>


    Implementation Points
"
Class {
	#name : #RWView,
	#superclass : #WDASceneModel,
	#traits : 'TRWInteractableObject',
	#classTraits : 'TRWInteractableObject classTrait',
	#instVars : [
		'cameraLight',
		'dynamicsWorld',
		'signalUpdateCallback',
		'sceneRenderer',
		'rigidBodies',
		'eventHandler',
		'overlays',
		'babylonDefaultFont',
		'elementByIdDictionary',
		'genidCount',
		'activeGroup',
		'internalElementsGroup',
		'groups',
		'tickingElements',
		'transmissibleItemActivationBlock',
		'genericTrackedDevices',
		'nodeWithTrackerAttachments',
		'touch3DCursorVolumeSet'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #initialization }
RWView class >> initializeWithEngine: anEngine [
	^ self basicNew: anEngine
]

{ #category : #hooks }
RWView >> activateTransmissibleItem: item [
	transmissibleItemActivationBlock cull: item
]

{ #category : #adding }
RWView >> add: anElement [
	activeGroup addChild: anElement
]

{ #category : #adding }
RWView >> addAll: someElements [
	someElements do: [ :e | self add: e ]
]

{ #category : #adding }
RWView >> addAllInternalElements: someElements [
	someElements do: [ :e | self addInternalElement: e ]
]

{ #category : #scene }
RWView >> addCameraLight: color [
	cameraLight := WDSGLightSource new directional.
	cameraLight intensity: color asFloat32x4.
	camera sceneNode addChild: cameraLight.
]

{ #category : #adding }
RWView >> addGenericTrackedDevice: device [
	genericTrackedDevices add: device.
	device index: genericTrackedDevices size
]

{ #category : #adding }
RWView >> addGroup: aGroup [
	groups add: aGroup.
	aGroup addedInView: self.
]

{ #category : #adding }
RWView >> addInternalElement: anElement [
	internalElementsGroup addChild: anElement
]

{ #category : #adding }
RWView >> addNodeWithTrackerAttachment: nodeWithAttachment [
	(nodeWithTrackerAttachments at: nodeWithAttachment trackerAttachment trackerIndex ifAbsentPut: [ OrderedCollection new ]) add: nodeWithAttachment
]

{ #category : #adding }
RWView >> addOverlay: anOverlay [
	overlays add: anOverlay.
	anOverlay addedIn: self
]

{ #category : #physics }
RWView >> addRigidBody: rigidBody [
	dynamicsWorld ifNotNil: [ dynamicsWorld addRigidBody: rigidBody ].
	rigidBodies add: rigidBody
]

{ #category : #adding }
RWView >> addTickingElement: anElement [
	self assert: (tickingElements includes: anElement) not.
	tickingElements add: anElement.
]

{ #category : #adding }
RWView >> addTrackedStylusControl [
	^ self addTrackedStylusControlAttachedToTrackerWithIndex: 1
]

{ #category : #adding }
RWView >> addTrackedStylusControlAttachedToTrackerWithIndex: trackerIndex [
	| stylus stylusBbox stylusTipLocation tip stylusController tipShape tipSize |
	stylus := (RWModelShape modelNamed: 'models/vr/stylus.obj') element.
	stylusBbox := stylus localBoundingBox.
	tipSize := 0.001.
	stylusTipLocation := Float32x3 x: 0 y: stylusBbox min y / 2 z: stylusBbox max z - (tipSize / 2).
	
	tipShape := RWUVSphere blue
		size: tipSize;
		yourself.
	tip := tipShape element
		translateTo: stylusTipLocation.

	stylusController := RWGroup new
		addChild: stylus;
		addChild: tip.
	stylusController attachTrackerAt: (RWVRTrackerAttachment new
		trackerIndex: trackerIndex;
		touch3DCursorVolume: (SphereF32 new center: stylusTipLocation; radius: tipSize/2; yourself);
		attachmentPointTransform:
		(ReversibleAffineTransform3dF32 identity
			orthonormal: (Float32x3x3 yRotation: Float pi) * (Float32x3x3 xRotation: Float halfPi);
			yourself)).

	self add: stylusController
]

{ #category : #accessing }
RWView >> allElementsInScene [
	| result |
	result := OrderedCollection new.
	self allElementsInSceneDo: [ :each |
		result add: each.
	].
	^ result
]

{ #category : #accessing }
RWView >> allElementsInSceneDo: aBlock [
	groups do: [ :each | each allElementsDo: aBlock ]
]

{ #category : #interaction }
RWView >> announce: eventOrClassEvent [
	eventHandler announce: eventOrClassEvent
]

{ #category : #vr }
RWView >> applyGenericTrackedDevice: trackedDevice transform: newTransform [
	(nodeWithTrackerAttachments at: trackedDevice index ifAbsent: [ #() ]) do: [ :eachNode |
		eachNode trackerAttachment applyTransform: newTransform to: eachNode inView: self
	].
]

{ #category : #converting }
RWView >> asSceneNode [
	^ self validScene normalLayer
]

{ #category : #accessing }
RWView >> backgroundColor [
	^ scene backgroundColor
]

{ #category : #accessing }
RWView >> backgroundColor: aWDColor [
	scene backgroundColor: aWDColor
]

{ #category : #'as yet unclassified' }
RWView >> beginNewGroup [
	| group |
	group := RWGroup new.
	self addGroup: group.
	activeGroup := group.
	^ group
]

{ #category : #'background colors' }
RWView >> blackBackground [
	^ self backgroundColor: Color black
]

{ #category : #accessing }
RWView >> boundingBox [
	"Return the bounding box of the view"
	| aBox |
	activeGroup ifEmpty: [ ^ BoxF32 new ].
	
	^ activeGroup boundingBox
]

{ #category : #overlays }
RWView >> buildUISceneGraphWith: builder [
	^ builder containerWith: (overlays collect: [ :overlay |
		overlay buildUISceneGraphWith: builder
	])
]

{ #category : #scene }
RWView >> cameraLightColor [
	^ self cameraLightIntensity 
]

{ #category : #scene }
RWView >> cameraLightColor: aWDColor [
	self cameraLightIntensity: aWDColor
]

{ #category : #scene }
RWView >> cameraLightIntensity [
	^ cameraLight intensity
]

{ #category : #scene }
RWView >> cameraLightIntensity: aColor [
	cameraLight intensity: aColor asFloat32x4
]

{ #category : #overlays }
RWView >> createBillboardAtWorldPosition: worldPosition drawingWith: aBlock [
	| overlay |
	overlay := RWBillboardOverlay new
		position: worldPosition;
		drawingBlock: aBlock.
	self addOverlay: overlay.
	^ overlay
]

{ #category : #overlays }
RWView >> createPopupAtViewPosition: viewPosition drawingWith: aBlock [
	| overlay |
	overlay := RWPopupOverlay new
		position: viewPosition;
		drawingBlock: aBlock.
	self addOverlay: overlay.
	^ overlay
]

{ #category : #accessing }
RWView >> defaultViewClass [
	^ RWSceneView
]

{ #category : #internal }
RWView >> element: element idChangedFrom: oldId into: newId [
	oldId ifNotNil: [ 
		elementByIdDictionary removeKey: oldId
	].

	newId ifNotNil: [ 
		elementByIdDictionary at: newId put: element
	].
]

{ #category : #accessing }
RWView >> elementFromModel: aModel [
	^ activeGroup elementFromModel: aModel
]

{ #category : #accessing }
RWView >> elements [
	^ activeGroup children
]

{ #category : #serialization }
RWView >> encodeAllElementsInSceneAsJSON [
	^ NeoJSONWriter toString: (Dictionary newFromPairs: {
		#elements . RWJSONSerializeVisitor new visitAndCollectObjects: self allElementsInScene
	})
]

{ #category : #serialization }
RWView >> encodeAllElementsInSceneAsJSONPretty [
	^ NeoJSONWriter toStringPretty: (Dictionary newFromPairs: {
		#elements . RWJSONSerializeVisitor new visitAndCollectObjects: self allElementsInScene
	})
]

{ #category : #serialization }
RWView >> encodeForJSON [
	^ NeoJSONWriter toString: (Dictionary newFromPairs: {
		#elements . RWJSONSerializeVisitor new visitAndCollectObjects: self elements
	})
]

{ #category : #interaction }
RWView >> eventHandler [
	^ eventHandler
]

{ #category : #'as yet unclassified' }
RWView >> exportModelToFileNamed: aFileName [
	scene exportModelToFileNamed: aFileName
]

{ #category : #'as yet unclassified' }
RWView >> exportModelToFileNamed: aFileName withScaleFactor: scaleFactor [
	scene exportModelToFileNamed: aFileName withScaleFactor: scaleFactor
]

{ #category : #'ray casting' }
RWView >> findElementsIntersectingSphereVolume: sphere [
	| result |
	result := Set new.
	groups do: [ :each |
		each findElementsIntersectingSphereVolume: sphere into: result
	].

	^ result
]

{ #category : #'as yet unclassified' }
RWView >> generateIdForElement: anElement [
	| id |
	id := genidCount.
	genidCount := genidCount + 1.
	
	anElement id: ('<genid:' , id asString, '>') asSymbol.
]

{ #category : #'as yet unclassified' }
RWView >> generateIdForShape: aShape [
	| id |
	id := genidCount.
	genidCount := genidCount + 1.
	
	aShape id: ('<genid_shape:' , id asString, '>') asSymbol.
]

{ #category : #accessing }
RWView >> getElementById: id [
	^ self getElementById: id ifAbsent: [nil]
]

{ #category : #accessing }
RWView >> getElementById: id ifAbsent: aBlock [
	^ elementByIdDictionary at: id ifAbsent: aBlock
]

{ #category : #initialization }
RWView >> initializeModel [
	transmissibleItemActivationBlock := [].
	groups := OrderedCollection new.
	eventHandler := Announcer new.
	rigidBodies := OrderedCollection new.
	overlays := OrderedCollection new.
	elementByIdDictionary := Dictionary new.
	tickingElements := OrderedCollection new.
	genericTrackedDevices := OrderedCollection new.
	nodeWithTrackerAttachments := Dictionary new.
  	touch3DCursorVolumeSet := Dictionary new.
	genidCount := 0.
	self initializeScene.
]

{ #category : #scene }
RWView >> initializeScene [

	"Create the scene."
	self newScene.
	scene backgroundColor: Color white.

	"Add the camera"
	internalElementsGroup := self beginNewGroup.
	camera := RWCamera new.
	camera translateByZ: 5.0.
	self addInternalElement: camera.
	self addCameraLight: Color lightGray.
	
	self beginNewGroup.

]

{ #category : #testing }
RWView >> isAnimated [
	^ false
]

{ #category : #'as yet unclassified' }
RWView >> moveTouch3DCursorSphereVolume: touch3DCursorVolume for: trackedDevice to: cursorTransform [
	| oldSet newSet leaveSet enterSet moveSet |
	oldSet := touch3DCursorVolumeSet at: trackedDevice ifAbsent: [ Set new ].
	newSet := self findElementsIntersectingSphereVolume: (touch3DCursorVolume transformedWith: cursorTransform).
	leaveSet := oldSet difference: newSet.
	enterSet := newSet difference: oldSet.
	moveSet := oldSet intersection: newSet.
	
	leaveSet select: [ :each | each isElement ] thenDo: [ :each |
		RWTouch3DCursorLeave new
			element: each;
			device: trackedDevice;
			volume: touch3DCursorVolume;
			cursorTransform: cursorTransform;
			sendToElement
	].
	enterSet select: [ :each | each isElement ] thenDo: [ :each |
		RWTouch3DCursorEnter new
			element: each;
			device: trackedDevice;
			volume: touch3DCursorVolume;
			cursorTransform: cursorTransform;
			sendToElement
	].
	moveSet select: [ :each | each isElement ] thenDo: [ :each |
		RWTouch3DCursorMove new
			element: each;
			device: trackedDevice;
			volume: touch3DCursorVolume;
			cursorTransform: cursorTransform;
			sendToElement
	].
	touch3DCursorVolumeSet at: trackedDevice put: newSet
]

{ #category : #accessing }
RWView >> numberOfElements [
	^ activeGroup numberOfElements
]

{ #category : #accessing }
RWView >> numberOfOverlays [
	^ overlays size
]

{ #category : #accessing }
RWView >> overlays [
	^ overlays
]

{ #category : #'ray casting' }
RWView >> rayCast: ray [
	| bestDistance bestResult distanceResult distance result |
	bestDistance := Float infinity.
	bestResult := nil.
	groups do: [ :group |
		distanceResult := group rayCast: ray.
		distance := distanceResult key.
		result := distanceResult value.
		(result notNil and: [ distance < bestDistance ]) ifTrue: [ 
			bestDistance := distance.
			bestResult := result.
		]
	].

	^ bestDistance -> bestResult.
]

{ #category : #'ray casting' }
RWView >> rayCast: ray satisfying: predicate [
	| bestDistance bestResult distanceResult distance result |
	bestDistance := Float infinity.
	bestResult := nil.
	groups do: [ :group |
		distanceResult := group rayCast: ray satisfying: predicate.
		distance := distanceResult key.
		result := distanceResult value.
		(result notNil and: [ distance < bestDistance ]) ifTrue: [ 
			bestDistance := distance.
			bestResult := result.
		]
	].

	^ bestDistance -> bestResult.
]

{ #category : #'ray casting' }
RWView >> rayPickNormalizedPosition: aPoint [
	| ray distanceElement |
	ray := camera worldRayAtWindowCoordinate: aPoint.
	ray ifNil: [ ^ self ].
	
	distanceElement := self rayCast: ray.
	^ distanceElement value ifNil: [ self ]
	
]

{ #category : #adding }
RWView >> removeElement: anElement [
	self flag: 'TODO: Implement this properly'.
	"elements remove: anElement ifAbsent: [ internalElements remove: anElement ifAbsent: [ ] ]"
]

{ #category : #adding }
RWView >> removeOverlay: anOverlay [
	overlays remove: anOverlay
]

{ #category : #adding }
RWView >> removeTickingElement: anElement [
	tickingElements remove: anElement.
]

{ #category : #rendering }
RWView >> render3DOnWindow: aWindow extraRenderTime: extraRenderTime [
	| aspect frameIndex |
	frameIndex := engine bufferingFrameIndex. 
	aspect := aWindow screenWidth asFloat / aWindow screenHeight asFloat.
	camera updateProjectionWithAspectRatio: aspect.
	sceneRenderer ifNil: [ self createSceneRenderer ].
	sceneRenderer
		currentTime: currentTime + extraRenderTime;
		renderFrame: frameIndex camera: camera sceneNode on: aWindow.

]

{ #category : #path }
RWView >> sessionChanged [
	babylonDefaultFont := nil.
	groups do: [ :each | each changed ].
	super sessionChanged.

]

{ #category : #interaction }
RWView >> signalUpdate [
	"Call this method when you wish to update the view"
"	self elements do: #signalUpdate."
	signalUpdateCallback value.
	self changed.
]

{ #category : #rendering }
RWView >> simulatePhysics: delta [
	dynamicsWorld ifNil: [ ^ self ].
	dynamicsWorld simulateTime: delta
]

{ #category : #rendering }
RWView >> updateForFrameDelta: delta [
	super updateForFrameDelta: delta.
	self flag: 'TODO: Use a deterministic timestep here!!!'.
	delta > (1.0 / 10.0) ifTrue: [ ^ self ].
	self simulatePhysics: delta.
	tickingElements do: [ :each | each simulateTime: delta ].

]

{ #category : #accessing }
RWView >> validScene [
	scene ifNil: [ self newScene ].
	^ scene
]

{ #category : #interaction }
RWView >> when: anEvent do: aBlock [
	eventHandler when: anEvent do: aBlock.
]

{ #category : #hooks }
RWView >> whenTransmissibleItemActivatedDo: aBlock [
	transmissibleItemActivationBlock := aBlock
]

{ #category : #physics }
RWView >> withPhysics [
	dynamicsWorld := WDPhyPhysicsEngine current createDynamicsWorld.
	dynamicsWorld gravity: (Float32x3 x: 0.0 y: -9.8 z: 0.0).
	dynamicsWorld addRigidBodies: rigidBodies.

]

{ #category : #scene }
RWView >> withShadows [
	"sceneRenderer := WDDeferredSceneRenderer forScene: scene.
	sceneRenderer compositor: WDColorCorrectedSceneCompositor new.
	"
	
]
