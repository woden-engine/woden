Extension { #name : #WDCModel }

{ #category : #'*WodenEngine-Scene' }
WDCModel >> createViewer [
	| sceneModel scene camera engine mesh node light |
	sceneModel := WDASampleSceneModel new.
	scene := sceneModel newScene.
	scene backgroundColor: Color lightGray.

	camera := sceneModel camera.
	camera transform translateByZ: 3.0.
	engine := scene engine.
	
	mesh := self meshFor: engine.

	node := WDSGSpatialObject new.
	node renderable: mesh.
	scene add: node.
	
	light := WDSGLightSource new.
	light point.
	light state
		intensity: Color white asWMVector4F.
	light transform
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.
	^ sceneModel
]

{ #category : #'*WodenEngine-Scene' }
WDCModel >> openViewer [
	^ self createViewer openWith: WDAFPSSceneView.
]
