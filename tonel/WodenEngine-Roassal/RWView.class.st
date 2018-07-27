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
	#instVars : [
		'elements',
		'cameraLight',
		'baseShapes',
		'dynamicsWorld',
		'signalUpdateCallback',
		'isStereo',
		'fullscreen',
		'sceneRenderer',
		'rigidBodies',
		'internalElements',
		'view2D',
		'trachelCanvas',
		'eventHandler'
	],
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #initialization }
RWView class >> initializeWithEngine: anEngine [
	^ self basicNew: anEngine
]

{ #category : #interaction }
RWView >> @ anInteraction [

	self addInteraction: anInteraction
]

{ #category : #adding }
RWView >> add: anElement [
	self assert: anElement isElement.
	elements add: anElement.
	anElement addedIn: self
]

{ #category : #adding }
RWView >> addAll: someElements [
	someElements do: [ :e | self add: e ]
]

{ #category : #scene }
RWView >> addCameraLight: color [
	cameraLight := WDSGLightSource new directional.
	cameraLight state
		intensity: color asWMVector4F.
	camera sceneNode addChild: cameraLight.
]

{ #category : #interaction }
RWView >> addInteraction: anInteraction [
	anInteraction initializeElement: self
]

{ #category : #adding }
RWView >> addInternalElement: anElement [
	self assert: anElement isElement.
	internalElements add: anElement.
	anElement addedIn: self
]

{ #category : #physics }
RWView >> addRigidBody: rigidBody [
	dynamicsWorld ifNotNil: [ dynamicsWorld addRigidBody: rigidBody ].
	rigidBodies add: rigidBody
]

{ #category : #interaction }
RWView >> announce: eventOrClassEvent [
	eventHandler announce: eventOrClassEvent
]

{ #category : #accessing }
RWView >> backgroundColor [
	^ scene backgroundColor
]

{ #category : #accessing }
RWView >> backgroundColor: aWDColor [
	scene backgroundColor: aWDColor
]

{ #category : #'base shapes' }
RWView >> baseShapeNodeFor: baseShapeDescriptor [
	^ baseShapes at: baseShapeDescriptor ifAbsent: [ nil ]
]

{ #category : #'base shapes' }
RWView >> baseShapeNodeFor: baseShapeDescriptor ifAbsentPut: aBlock [
	|node |
	^ baseShapes at: baseShapeDescriptor ifAbsentPut: [
		node := aBlock value.
		scene add: node.
		node
	]
]

{ #category : #'background colors' }
RWView >> blackBackground [
	^ self backgroundColor: Color black
]

{ #category : #accessing }
RWView >> boundingBox [
	"Return the bounding box of the view"
	| aBox |
	elements ifEmpty: [ ^ WMBox3DF new ].
	
	aBox := WMBox3DF new.
	elements do: [ :e | aBox insertBox: e boundingBox ].
	^ aBox
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
	^ cameraLight state intensity
]

{ #category : #scene }
RWView >> cameraLightIntensity: aColor [
	cameraLight state intensity: aColor asWMVector4F
]

{ #category : #accessing }
RWView >> defaultViewClass [
	^ RWSceneView
]

{ #category : #accessing }
RWView >> elementFromModel: aModel [
	^ elements detect: [ :el | el model == aModel ] ifNone: [ nil ]
]

{ #category : #accessing }
RWView >> elements [
	^ elements
]

{ #category : #interaction }
RWView >> eventHandler [
	^ eventHandler
]

{ #category : #accessing }
RWView >> fullscreen [
	^ fullscreen
]

{ #category : #accessing }
RWView >> fullscreen: aBoolean [
	fullscreen := aBoolean
]

{ #category : #initialization }
RWView >> initializeModel [
	elements := OrderedCollection new.
	internalElements := OrderedCollection new.
	eventHandler := Announcer new.
	baseShapes := Dictionary new.
	rigidBodies := OrderedCollection new.
	isStereo := false.
	fullscreen := false.
	self initializeScene.
]

{ #category : #scene }
RWView >> initializeScene [

	"Create the scene."
	scene := WDSGScene for: engine.
	scene backgroundColor: Color white.

	"Add the camera"
	camera := RWCamera new.
	camera translateByZ: 5.0.
	self addInternalElement: camera.
	self addCameraLight: Color lightGray.
]

{ #category : #accessing }
RWView >> isStereo [
	^ isStereo
]

{ #category : #accessing }
RWView >> numberOfElements [
	^ elements size
]

{ #category : #interaction }
RWView >> on: anEvent do: aBlock [
	self deprecated: 'Please use when:do: instead of on:do'.
	eventHandler when: anEvent do: aBlock.
]

{ #category : #'ray casting' }
RWView >> rayCast: ray [
	| bestDistance bestResult distanceResult distance result |
	bestDistance := Float infinity.
	bestResult := nil.
	elements do: [ :element |
		distanceResult := element rayCast: ray.
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
	elements remove: anElement
]

{ #category : #rendering }
RWView >> render2DOnSurface: athensSurface canvas: canvas [
	trachelCanvas ifNil: [ ^ self ].
	
	"We display the elements that are subject to the camera"
	canvas pathTransform
		translateBy: (athensSurface extent / 2) asFloatPoint;
		    scaleBy: trachelCanvas camera scale asFloat;
		translateBy: trachelCanvas camera position negated asFloatPoint.
	trachelCanvas shapes do: [ :trachelShape |
		trachelShape drawOn: canvas.
	].
	
	"We display the elements that are _NOT_ subject to the camera"
	canvas pathTransform loadIdentity scaleBy: 1.001.
		trachelCanvas fixedShapes do: [ :trachelShape |
		trachelShape drawOn: canvas.
	].
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

{ #category : #accessing }
RWView >> selectionRenderer [
	"Return the selection rendered associated to the view. The WDSelectionSceneRenderer, subclass of WDSceneRenderer, is used to identify which object is below the mouse cursor."
	^ selectionRenderer
]

{ #category : #interaction }
RWView >> signalUpdate [
	"Call this method when you wish to update the view"
"	self elements do: #signalUpdate."
	signalUpdateCallback value
]

{ #category : #accessing }
RWView >> signalUpdateCallback [
	^ signalUpdateCallback
]

{ #category : #accessing }
RWView >> signalUpdateCallback: anObject [
	signalUpdateCallback := anObject
]

{ #category : #rendering }
RWView >> simulatePhysics: delta [
	dynamicsWorld ifNil: [ ^ self ].
	dynamicsWorld simulateTime: delta
]

{ #category : #accessing }
RWView >> trachelCanvas [
	^ trachelCanvas ifNil: [ trachelCanvas := RWTRCanvas new engine: engine ].
	
]

{ #category : #rendering }
RWView >> updateForFrameDelta: delta [
	super updateForFrameDelta: delta.
	self simulatePhysics: delta.
	elements do: [ :element | element simulateTime: delta ].
	internalElements do: [ :element | element simulateTime: delta ].

]

{ #category : #accessing }
RWView >> validScene [
	scene ifNil: [ self newScene ].
	^ scene
]

{ #category : #accessing }
RWView >> view2D [
	view2D ifNil: [ self view2D: RTView new ].
	^ view2D
]

{ #category : #accessing }
RWView >> view2D: aRTView [
	view2D := aRTView.
	view2D setCanvas: self trachelCanvas
]

{ #category : #interaction }
RWView >> when: anEvent do: aBlock [
	eventHandler when: anEvent do: aBlock.
]

{ #category : #physics }
RWView >> withPhysics [
	dynamicsWorld := WTPhysicsEngine current createDynamicsWorld.
	dynamicsWorld gravity: (WMVector3F x: 0.0 y: -9.8 z: 0.0).
	dynamicsWorld addRigidBodies: rigidBodies.

]

{ #category : #scene }
RWView >> withShadows [
	"sceneRenderer := WDDeferredSceneRenderer forScene: scene.
	sceneRenderer compositor: WDColorCorrectedSceneCompositor new.
	"
	
]
