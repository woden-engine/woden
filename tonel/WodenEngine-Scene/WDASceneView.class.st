Class {
	#name : #WDASceneView,
	#superclass : #WDAView,
	#instVars : [
		'sceneRenderer',
		'camera',
		'screenDisplayMode',
		'commandList'
	],
	#category : 'WodenEngine-Scene-Application'
}

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

{ #category : #'as yet unclassified' }
WDASceneView class >> vr [
	^ self new vr
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

{ #category : #accessing }
WDASceneView >> engineChanged [
	super engineChanged.
	screenDisplayMode engine: engine
]

{ #category : #'screen display modes' }
WDASceneView >> flatScreen [
	self screenDisplayMode: WDASceneViewFlatScreenDisplayMode new
]

{ #category : #testing }
WDASceneView >> hasDepth [
	^ true
]

{ #category : #initialization }
WDASceneView >> initialize [
	super initialize.
	self screenDisplayMode: WDASceneViewFlatScreenDisplayMode new.
]

{ #category : #'rendering process stages' }
WDASceneView >> prepareRendering [
	super prepareRendering.
	commandList := screenDisplayMode prepareRendering.

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
	self screenDisplayMode: WDASceneViewVRScreenDisplayMode new
]
