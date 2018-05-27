Class {
	#name : #WDASceneViewVRScreenDisplayMode,
	#superclass : #WDASceneViewStereoScreenDisplayMode,
	#instVars : [
		'headsetDescription',
		'vrState',
		'vrTransform',
		'headsetOrientation',
		'headsetTranslation',
		'screenGridVertexBuffer',
		'screenGridIndexBuffer',
		'screenGridIndexCount',
		'screenGridVertexBinding'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'multi eye rendering' }
WDASceneViewVRScreenDisplayMode >> applyVRTransformToCamera: cameraTransform eye: eyeTranslation [
	| orientation extraTranslation |
	orientation := headsetOrientation * cameraTransform matrix.
	extraTranslation := orientation transformPosition3: eyeTranslation.
	^ WMReversibleAffineTransformF new
		orthonormal: orientation translation: (cameraTransform translation + extraTranslation)
]

{ #category : #'viewport composition' }
WDASceneViewVRScreenDisplayMode >> composeEyesIn: stateTracker [
	| resolveTarget renderPass |
	resolveTarget := view window validResolveRenderTarget.

	renderPass := resolveTarget validMainRenderPass.

	stateTracker reset;
		shaderSignature: self shaderSignature;
		frontFaceWinding: AGPU_COUNTER_CLOCKWISE;
		cullMode: AGPU_CULL_MODE_NONE;
		depthEnabled: false;
		blendingAllMode: WDCBlendingMode add; 
		
		beginRenderPass: renderPass renderTarget: resolveTarget bounds: resolveTarget bounds;
	
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader;
		useVertexBinding: screenGridVertexBinding;
		useIndexBuffer: screenGridIndexBuffer;
		useShaderResources: compositionStateBinding;
		useShaderResources: sourceRenderTargetsBinding;
		useShaderResources: self shaderSignature defaultSamplers;
		primitiveType: AGPU_TRIANGLES;
		drawElements: screenGridIndexCount instance_count: 2 first_index: 0 base_vertex: 0 base_instance: 0;
		endRenderPass
]

{ #category : #'rendering process stages' }
WDASceneViewVRScreenDisplayMode >> computeProjectionMatrices [
	| camera sensorState |
	camera := view cameraSceneNode.
	headsetDescription
		nearDistance: camera nearDistance;
		farDistance: camera farDistance;
		invertedY: engine projectionInvertedY.
		
	leftProjectionMatrix := headsetDescription leftUndistortedProjection.
	rightProjectionMatrix := headsetDescription rightUndistortedProjection.
	
	headsetOrientation := WMMatrix3F identity.
	headsetTranslation := WMVector3F new.
	engine vrSensorReader ifNotNil: [ :sensor |
		sensorState := sensor sensorState.
		headsetOrientation := sensorState orientation asWMMatrix3F
	].

]

{ #category : #'rendering process stages' }
WDASceneViewVRScreenDisplayMode >> createCompositionStateBuffer [
	compositionStateBuffer := engine createStreamingUniformBuffer: WTVRState structureSize.
	compositionStateBinding bind: 0 uniformBuffer: compositionStateBuffer.
]

{ #category : #'rendering process stages' }
WDASceneViewVRScreenDisplayMode >> createScreenGrid [
	| steps vertices destIndex rowIndex nextRowIndex indices i1 i2 i3 i4 |
	screenGridVertexBuffer ifNotNil: [ ^ self ].
	
	steps := 33.
	"Create the vertices"
	vertices := SLVMNativeArray for: WTCompositionVertexF new: steps*steps.
	destIndex := 1.
	-1.0 to: 1.0 by: (2.0 / (steps - 1)) do: [ :y |
		-1.0 to: 1.0 by: (2.0 / (steps - 1)) do: [ :x |
			vertices at: destIndex put: (WTCompositionVertexF new position: (WMVector2F x: x y: y)).
			destIndex := destIndex + 1
		].
	].

	"Create the indices"
	rowIndex := 0.
	nextRowIndex := rowIndex + steps.
	indices := SLVMNativeOrderedCollection for: #short.
	1 to: steps - 1 do: [ :r |
		0 to: steps - 2 do: [ :x |
			i1 := rowIndex + x.
			i2 := rowIndex + x + 1.
			i3 := nextRowIndex + x.
			i4 := nextRowIndex + x + 1.
			indices add: i1; add: i2; add: i3.
			indices add: i2; add: i4; add: i3.
		].

		rowIndex := rowIndex + steps.
		nextRowIndex := nextRowIndex + steps.
	].

	"Upload the buffers"
	screenGridVertexBuffer := engine createVertex: WTCompositionVertexF structureSize elements: vertices size immutableBuffer: vertices asByteArray.
	screenGridIndexBuffer := engine createIndex: 2 elements: indices size immutableBuffer: indices asByteArray.
	screenGridIndexCount := indices size.
	
	screenGridVertexBinding := engine createVertexBindingForLayout: (engine vertexLayoutFor: WTCompositionVertexF).
	screenGridVertexBinding vertexBuffers: { screenGridVertexBuffer }
]

{ #category : #'viewport composition' }
WDASceneViewVRScreenDisplayMode >> fragmentShaderFileName [
	^ 'shaders/composition/vrFragment.dastrel'
]

{ #category : #initialization }
WDASceneViewVRScreenDisplayMode >> initialize [
	super initialize.
	headsetDescription := WDCVRHeadsetDescription default.
]

{ #category : #testing }
WDASceneViewVRScreenDisplayMode >> isVR [
	^ true
]

{ #category : #'multi eye rendering' }
WDASceneViewVRScreenDisplayMode >> leftViewportForCamera: camera [
	| cameraState |
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: leftProjectionMatrix.
	
	^ WTSViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: leftRenderTarget;
		resolveRenderTarget: leftResolveRenderTarget;
		bounds: leftRenderTarget bounds;
		cameraTransformFunction: [ :ct | self applyVRTransformToCamera: ct eye: (WMVector3F x: ipd * -0.5) ];
		submode: #full;
		overlayRenderer: view;
		pompeiiCanvasSafeZoneTransform: [ :canvasTransform | self pompeiiSafeZoneTransform: canvasTransform ]
]

{ #category : #'multi eye rendering' }
WDASceneViewVRScreenDisplayMode >> pompeiiSafeZoneTransform: aCanvasTransform [
	aCanvasTransform
		scaleX: 2.0 Y: 2.0;
		translateX: 10.0 Y: 10.0

]

{ #category : #'rendering process stages' }
WDASceneViewVRScreenDisplayMode >> prepareRendering [
	self createScreenGrid.
	^ super prepareRendering
]

{ #category : #'multi eye rendering' }
WDASceneViewVRScreenDisplayMode >> rightViewportForCamera: camera [
	| cameraState |
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: rightProjectionMatrix.
	
	^ WTSViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: rightRenderTarget;
		resolveRenderTarget: rightResolveRenderTarget;
		bounds: rightRenderTarget bounds;
		cameraTransformFunction: [ :ct | self applyVRTransformToCamera: ct eye: (WMVector3F x: ipd * 0.5) ];
		submode: #full;
		overlayRenderer: view;
		pompeiiCanvasSafeZoneTransform: [ :canvasTransform | self pompeiiSafeZoneTransform: canvasTransform ]
]

{ #category : #'rendering process stages' }
WDASceneViewVRScreenDisplayMode >> updateCompositionState [
	super updateCompositionState.
	vrState := headsetDescription state.
	vrState compositionState: compositionState.
]

{ #category : #'rendering process stages' }
WDASceneViewVRScreenDisplayMode >> uploadCompositionState [
	vrState storeBytesIn: compositionStateBuffer validPointer getHandle position: 1.
]

{ #category : #'rendering process stages' }
WDASceneViewVRScreenDisplayMode >> useLateLatching [
	^ false
]

{ #category : #'viewport composition' }
WDASceneViewVRScreenDisplayMode >> vertexShaderFileName [
	^ 'shaders/composition/vrVertex.dastrel'
]

{ #category : #accessing }
WDASceneViewVRScreenDisplayMode >> vrSensorReader [
	^ engine vrSensorReader
]
