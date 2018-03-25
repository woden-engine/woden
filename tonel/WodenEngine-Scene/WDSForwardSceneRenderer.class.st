Class {
	#name : #WDSForwardSceneRenderer,
	#superclass : #WDSLightedSceneRenderer,
	#instVars : [
		'lightSources',
		'globalLightingStates',
		'currentGlobalLigthingStates'
	],
	#category : 'WodenEngine-Scene-Application'
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
	
	lightSources := SLVMNativeArray for: WTLightSourceData new: 16
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
WDSForwardSceneRenderer >> updateFrameLightingStates: viewports [
	| transform numberOfLights lightingState gpuLightingStates lightSource shadowMapIndex |
	self ensureLightingStatesFor: viewports size.
	currentGlobalLigthingStates := globalLightingStates at: engine bufferingFrameIndex.
	
	viewports doWithIndex: [ :viewport :viewportIndex |
		transform := viewport cameraTransform.
		numberOfLights := visibleLightSources size min: 16.
		1 to: numberOfLights do: [ :lightIndex |
			lightSource := (visibleLightSources at: lightIndex) first.
			shadowMapIndex := shadowCastingLights indexOf: lightSource ifAbsent: [ 0 ].
			lightSources at: lightIndex put: (lightSource viewStateFor: transform engine: engine shadowMapIndex: shadowMapIndex - 1).
		].

		lightingState := WTGlobalLightingState  new.
		lightingState
			skyLighting: Color darkGray asWMVector4F;
			groundLighting: Color veryDarkGray asWMVector4F;
			sunDirection: (transform inverseTransformVector3: (WMVector3F y: 1.0));
			numberOfLights: numberOfLights;
			lightSources: lightSources.
			
		gpuLightingStates := (currentGlobalLigthingStates at: viewportIndex) slotValueAt: 0.
		gpuLightingStates value: lightingState.
	].
]

{ #category : #rendering }
WDSForwardSceneRenderer >> updateRenderingStatesFor: viewports [
	super updateRenderingStatesFor: viewports.
	self
		updateFrameLightingStates: viewports
]
