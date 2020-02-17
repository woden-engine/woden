Class {
	#name : #WDCBabylonOverlay,
	#superclass : #WDCMutableRenderable,
	#instVars : [
		'overlayMesh',
		'overlayMaterial',
		'engine',
		'drawingSurfaceExtent',
		'defaultFont',
		'surface'
	],
	#category : #'WodenEngine-Scene-Renderable'
}

{ #category : #'instance creation' }
WDCBabylonOverlay class >> for: anEngine [
	^ self new engine: anEngine
]

{ #category : #'as yet unclassified' }
WDCBabylonOverlay class >> logicalHeight [
	^ 480
]

{ #category : #'as yet unclassified' }
WDCBabylonOverlay >> applyLogicalHeightTransformTo: canvas [
	| actualWidth actualHeight logicalHeight logicalWidth scaleFactor |
	actualWidth := canvas surface extent x asFloat.
	actualHeight := canvas surface extent y asFloat.
	logicalHeight := self logicalHeight asFloat.
	scaleFactor := actualHeight / logicalHeight.
	logicalWidth := actualWidth / scaleFactor.
	canvas transform
		translateX: actualWidth * 0.5 Y: actualHeight * 0.5;
		scaleBy: scaleFactor;
		translateX: logicalWidth * -0.5 Y: logicalHeight * -0.5
]

{ #category : #accessing }
WDCBabylonOverlay >> defaultFont [
	^ defaultFont ifNil: [ defaultFont := engine babylonDriver font: (LogicalFont familyName: 'Arial' pointSize: 20) ]
]

{ #category : #'as yet unclassified' }
WDCBabylonOverlay >> drawingSurfaceExtent [
	^ drawingSurfaceExtent
]

{ #category : #'as yet unclassified' }
WDCBabylonOverlay >> drawingSurfaceExtent: anExtent [
	drawingSurfaceExtent := anExtent.
	surface ifNotNil: [
		surface extent: drawingSurfaceExtent.
		self overlayMaterial colorTexture: surface resolveRenderTargetTexture
	].
]

{ #category : #accessing }
WDCBabylonOverlay >> engine [
	^ engine
]

{ #category : #accessing }
WDCBabylonOverlay >> engine: anObject [
	engine := anObject
]

{ #category : #'as yet unclassified' }
WDCBabylonOverlay >> logicalHeight [
	^ self class logicalHeight
]

{ #category : #accessing }
WDCBabylonOverlay >> overlayMaterial [
	overlayMaterial ifNil: [ 
		overlayMaterial := (WDCFlatColorMaterial for: engine)
			useDepth: false;
			writeDepth: false;
			yourself
	].
	^ overlayMaterial
]

{ #category : #accessing }
WDCBabylonOverlay >> overlayMesh [
	overlayMesh ifNil: [
		overlayMesh := (WDCGenericMeshBuilder for: engine)
			currentMaterial: self overlayMaterial;
			beginTriangles;
			addP: (WMVector3F x: -1.0 y: -1.0) TC: (WMVector2F x: 0.0 y: 1.0);
			addP: (WMVector3F x: 1.0 y: -1.0) TC: (WMVector2F x: 1.0 y: 1.0);
			addP: (WMVector3F x: 1.0 y: 1.0) TC: (WMVector2F x: 1.0 y: 0.0);
			addP: (WMVector3F x: -1.0 y: 1.0) TC: (WMVector2F x: 0.0 y: 0.0);
			addQuadI1: 1 i2: 2 i3: 3 i4: 4;
			mesh			
	].
	^ overlayMesh
]

{ #category : #rendering }
WDCBabylonOverlay >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	^ self overlayMesh renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 
]

{ #category : #'as yet unclassified' }
WDCBabylonOverlay >> validSurface [
	surface ifNil: [
		surface := (engine babylonDriver surfaceWithExtent: drawingSurfaceExtent sampleCount: 1)
			gpuOnly: true;
			yourself.
		self overlayMaterial colorTexture: surface resolveRenderTargetTexture
	].

	^ surface 
]
