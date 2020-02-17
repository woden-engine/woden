Class {
	#name : #WDASceneView,
	#superclass : #WDAView,
	#instVars : [
		'sceneRenderer',
		'camera',
		'screenDisplayMode',
		'commandList',
		'allowingVR'
	],
	#category : #'WodenEngine-Scene-Application'
}

{ #category : #'as yet unclassified' }
WDASceneView class >> allowingVR [
	^ self new allowingVR
]

{ #category : #'as yet unclassified' }
WDASceneView class >> anaglyph [
	^ self new anaglyph
]

{ #category : #'as yet unclassified' }
WDASceneView class >> stereo [
	^ self new stereo
]

{ #category : #'as yet unclassified' }
WDASceneView class >> stereoInterleaved [
	^ self new stereoInterleaved
]

{ #category : #'as yet unclassified' }
WDASceneView class >> stereoSideBySide [
	^ self new stereoSideBySide
]

{ #category : #'as yet unclassified' }
WDASceneView class >> stereoTopDown [
	^ self new stereoTopDown
]

{ #category : #accessing }
WDASceneView >> allowingVR [
	allowingVR := true.
	(engine isNotNil and: [engine hasSupportForVR]) ifTrue: [
		self vr
	]
]

{ #category : #'screen display modes' }
WDASceneView >> anaglyph [
	self screenDisplayMode: WDASceneViewStereoAnaglyphScreenDisplayMode new
]

{ #category : #accessing }
WDASceneView >> camera [
	^ camera ifNil: [camera := model camera]
]

{ #category : #accessing }
WDASceneView >> camera: aCamera [
	camera := aCamera
]

{ #category : #accessing }
WDASceneView >> cameraSceneNode [
	^ self camera ifNotNil: [:c | c asSceneNode]
]

{ #category : #'rendering process stages' }
WDASceneView >> constructRenderingCommandLists [
	super constructRenderingCommandLists.
	commandList := screenDisplayMode renderSceneViewports.

]

{ #category : #accessing }
WDASceneView >> engineChanged [
	super engineChanged.
	(allowingVR and: [engine hasSupportForVR]) ifTrue: [
		self vr
	] ifFalse: [
		screenDisplayMode engine: engine
	]
	
]

{ #category : #'as yet unclassified' }
WDASceneView >> filterForCameraViewport: aCamera [
	^ [ :o | true ]
]

{ #category : #'screen display modes' }
WDASceneView >> flatScreen [
	self screenDisplayMode: WDASceneViewFlatScreenDisplayMode new
]

{ #category : #'framebuffer description' }
WDASceneView >> hasDepth [
	^ true
]

{ #category : #initialization }
WDASceneView >> initialize [
	super initialize.
	allowingVR := false.
	self screenDisplayMode: WDASceneViewFlatScreenDisplayMode new.
]

{ #category : #testing }
WDASceneView >> isInVirtualReality [
	^ screenDisplayMode isVR
]

{ #category : #'framebuffer description' }
WDASceneView >> needsDirectRenderTarget [
	^ false
]

{ #category : #'rendering process stages' }
WDASceneView >> prepareRendering [
	super prepareRendering.
	screenDisplayMode prepareRendering.

]

{ #category : #accessing }
WDASceneView >> renderSubMode [
	^ #full
]

{ #category : #rendering }
WDASceneView >> renderViewport: viewport overlayWith: stateTracker [
]

{ #category : #accessing }
WDASceneView >> sceneRenderer [
	^ sceneRenderer ifNil: [sceneRenderer := WDSForwardSceneRenderer for: engine].

]

{ #category : #'screen display modes' }
WDASceneView >> screenDisplayMode [
	^ screenDisplayMode
]

{ #category : #accessing }
WDASceneView >> screenDisplayMode: aScreenDisplayMode [
	screenDisplayMode := aScreenDisplayMode.
	screenDisplayMode engine: engine; view: self
]

{ #category : #'rendering process stages' }
WDASceneView >> sendRenderingCommands [
	super sendRenderingCommands.
	commandList ifNil: [ ^ self ].
	engine graphicsQueue addCommandList: commandList validHandle.
	screenDisplayMode submitLowLatencyData
		
]

{ #category : #'screen display modes' }
WDASceneView >> stereo [
	self stereoSideBySide
]

{ #category : #'screen display modes' }
WDASceneView >> stereoInterleaved [
	self screenDisplayMode: WDASceneViewStereoInterleavedScreenDisplayMode new
]

{ #category : #'screen display modes' }
WDASceneView >> stereoSideBySide [
	self screenDisplayMode: WDASceneViewStereoSideBySideScreenDisplayMode new
]

{ #category : #'screen display modes' }
WDASceneView >> stereoTopDown [
	self screenDisplayMode: WDASceneViewStereoTopDownScreenDisplayMode new
]

{ #category : #'screen display modes' }
WDASceneView >> vr [
	model isInVirtualReality: true.
	self screenDisplayMode: WDASceneViewVRDisplayMode new
]
