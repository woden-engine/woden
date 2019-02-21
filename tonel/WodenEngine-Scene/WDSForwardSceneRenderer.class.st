Class {
	#name : #WDSForwardSceneRenderer,
	#superclass : #WDSLightedSceneRenderer,
	#instVars : [
		'globalLightingStates',
		'currentGlobalLigthingStates'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #rendering }
WDSForwardSceneRenderer >> ensureLightingStatesFor: requiredNumberOfCameras [
	| pool currentNumberOfCameras missingNumberOfCameras |
	globalLightingStates ifNil: [ 
		globalLightingStates := engine frameBufferingCollect: [ :f | #() ].
	].

	pool := engine resourceCache streamingUniformBufferPoolFor: WTGlobalLightingState.
	
	currentNumberOfCameras := globalLightingStates first size.
	missingNumberOfCameras := requiredNumberOfCameras - currentNumberOfCameras.
	
	globalLightingStates := globalLightingStates collect: [ :oldLightingStates |
		oldLightingStates , ((pool allocate: missingNumberOfCameras) collect: [ :bufferElement |
			self shaderSignature newLightingState
				bind: 0 uniformBufferElement: bufferElement;
				bind: 1 texture: self shadowMapBuffer startMiplevel: 0 miplevels: -1 lodclamp: 100000;
				yourself
		])
	].
]

{ #category : #initialization }
WDSForwardSceneRenderer >> initializeWithEngine: aWDCEngine [
	super initializeWithEngine: aWDCEngine.

]

{ #category : #accessing }
WDSForwardSceneRenderer >> renderMode [
	^ WDCStateTrackerForwardRenderMode uniqueInstance
]

{ #category : #rendering }
WDSForwardSceneRenderer >> setupViewportRendering: viewport index: viewportIndex [
	super setupViewportRendering: viewport index: viewportIndex.
	stateTracker
		useShaderResources: (currentGlobalLigthingStates at: viewportIndex)
]

{ #category : #accessing }
WDSForwardSceneRenderer >> shaderSignatureClass [
	^ WDCForwardRenderingShaderSignature
]

{ #category : #rendering }
WDSForwardSceneRenderer >> updateFrameLightingStates [
	| transform lightingState gpuLightingStates lightSources viewport viewportLights |
	self ensureLightingStatesFor: renderingViewports size.
	currentGlobalLigthingStates := globalLightingStates at: engine bufferingFrameIndex.

	renderingViewports doWithIndex: [ :renderingViewport :viewportIndex |
		viewport := renderingViewport viewport.
		transform := viewport cameraTransform.

		lightSources := SLVMNativeArray for: WTLightSourceData new: 16.

		viewportLights := renderingViewport lightRenderingStates.
		viewportLights doWithIndex: [ :lightSource :lightIndex |
			lightSources at: lightIndex put: (lightSource viewStateForCameraTransform: transform).
		].
		
		lightingState := WTGlobalLightingState  new.
		lightingState
			skyLighting: Color darkGray asWMVector4F;
			groundLighting: Color veryDarkGray asWMVector4F;
			sunDirection: (transform inverseTransformVector3: (WMVector3F y: 1.0));
			numberOfLights: viewportLights size;
			lightSources: lightSources.
			
		gpuLightingStates := (currentGlobalLigthingStates at: viewportIndex) slotValueAt: 0.
		gpuLightingStates value: lightingState.
	].
]

{ #category : #rendering }
WDSForwardSceneRenderer >> updateGPUStatesForRenderingViewports [
	super updateGPUStatesForRenderingViewports.
	self updateFrameLightingStates
]

{ #category : #rendering }
WDSForwardSceneRenderer >> updateRenderingStatesFor: viewports [
	super updateRenderingStatesFor: viewports.
	self
		updateFrameLightingStates: viewports
]
