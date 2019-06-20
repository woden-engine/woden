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
				bind: 1 texture: self shadowMapBuffer;
				bind: 4 texture: engine resourceCache imageBasedLightingBRDFLut;
				bind: 5 texture: engine resourceCache whiteCubeMap;
				bind: 6 texture: engine resourceCache blackCubeMap;
				yourself
		])
	].
]

{ #category : #initialization }
WDSForwardSceneRenderer >> initializeWithEngine: aWDCEngine [
	super initializeWithEngine: aWDCEngine.

]

{ #category : #'rendering preparations' }
WDSForwardSceneRenderer >> intermediateRenderTargetsClass [
	^ WDSForwardSceneRendererIntermediateTextures
]

{ #category : #accessing }
WDSForwardSceneRenderer >> renderMode [
	^ WDCStateTrackerForwardRenderMode uniqueInstance
]

{ #category : #rendering }
WDSForwardSceneRenderer >> setupRenderingViewportStates: renderingViewport [
	super setupRenderingViewportStates: renderingViewport.
	stateTracker
		useShaderResources: renderingViewport globalLightingStateShaderBindings
]

{ #category : #rendering }
WDSForwardSceneRenderer >> updateFrameLightingStates [
	| transform lightingState lightingStateBinding lightSources viewport viewportLights shadowMapExtent shadowMapInverseExtent scene ambientLightingFactor |
	self ensureLightingStatesFor: renderingViewports size.
	currentGlobalLigthingStates := globalLightingStates at: engine bufferingFrameIndex.

	shadowMapExtent := self shadowMapExtent asWMVector2F.
	shadowMapInverseExtent := (WMVector2F x: 1.0 y: 1.0) / shadowMapExtent.

	renderingViewports doWithIndex: [ :renderingViewport :viewportIndex |
		viewport := renderingViewport viewport.
		transform := viewport cameraTransform.
		scene := viewport camera scene.

		lightSources := SLVMNativeArray for: WTLightSourceData new: 16.

		viewportLights := renderingViewport lightRenderingStates.
		viewportLights doWithIndex: [ :lightSource :lightIndex |
			lightSources at: lightIndex put: (lightSource viewStateForCameraTransform: transform).
		].
		
		lightingState := WTGlobalLightingState  new.
		ambientLightingFactor := scene lightingProbe ifNil: [ Float pi ] ifNotNil: [ 1.0 ]. 
		lightingState
			skyLighting: scene skyLighting*ambientLightingFactor;
			groundLighting: scene groundLighting*ambientLightingFactor;
			sunDirection: scene sunDirection;
			shadowMapExtent: shadowMapExtent;
			shadowMapInverseExtent: shadowMapInverseExtent;
			numberOfLights: viewportLights size;
			lightSources: lightSources.
			
		"Submit the lighting state to the GPU memory."
		lightingStateBinding := currentGlobalLigthingStates at: viewportIndex.
		renderingViewport globalLightingStateShaderBindings: lightingStateBinding.
		
		(lightingStateBinding slotValueAt: 0) value: lightingState.
		
		"Bind the ambient occlusion texture."
		lightingStateBinding bind: 3 texture: renderingViewport ambientOcclusionTexture.
		scene lightingProbe ifNotNil: [ 
			lightingStateBinding
				bind: 5 texture: scene lightingProbe diffuseIrradianceMap;
				bind: 6 texture: scene lightingProbe specularIrradianceMap
		]
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
