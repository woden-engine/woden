Extension { #name : #WDCSimpleModel }

{ #category : #'*WodenEngine-Scene' }
WDCSimpleModel >> createViewer [
	| sceneModel scene camera engine mesh node light |
	sceneModel := WDASampleSceneModel new.
	scene := sceneModel newScene.
	scene backgroundColor: Color darkGray.

	camera := sceneModel camera.
	camera transform translateByZ: 3.0.
	engine := scene engine.
	
	mesh := self meshFor: engine.

	node := WDSGSpatialObject new.
	node renderable: mesh.
	scene add: node.
	
	light := WDSGLightSource new.
	light point;
		intensity: Color white asWMVector4F;
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.
	^ sceneModel
]

{ #category : #'*WodenEngine-Scene' }
WDCSimpleModel >> openViewer [
	^ self createViewer openWith: WDAFPSSceneView allowingVR.
]
