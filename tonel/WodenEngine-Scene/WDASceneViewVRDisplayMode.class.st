Class {
	#name : #WDASceneViewVRDisplayMode,
	#superclass : #WDASceneViewStereoDisplayMode,
	#instVars : [
		'leftEyeTransform',
		'rightEyeTransform',
		'windowDisplayBinding',
		'windowDisplayShader'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'render targets' }
WDASceneViewVRDisplayMode >> computeProjectionMatrices [
	| camera near far invertedY vrSystem |
	camera := view cameraSceneNode.
	invertedY := engine projectionInvertedY.
	
	near := camera nearDistance.
	far := camera farDistance.

	vrSystem := engine vrSystem.
	leftEyeFrustum := vrSystem leftEyeFrustumNear: near far: far.
	leftProjectionMatrix := vrSystem leftEyeProjectionMatrixNear: near far: far invertedY: invertedY.
	leftEyeTransform := vrSystem leftEyeTransform.
	
	rightEyeFrustum := vrSystem rightEyeFrustumNear: near far: far.
	rightProjectionMatrix := vrSystem rightEyeProjectionMatrixNear: near far: far invertedY: invertedY.
	rightEyeTransform := vrSystem rightEyeTransform

]

{ #category : #testing }
WDASceneViewVRDisplayMode >> isVR [
	^ true
]

{ #category : #'multi eye rendering' }
WDASceneViewVRDisplayMode >> leftEyeTransform [
	^ leftEyeTransform
]

{ #category : #'render targets' }
WDASceneViewVRDisplayMode >> leftRenderTargetRequiredExtent [
	^ engine vrSystem leftEyeRenderTargetExtent
]

{ #category : #'rendering process stages' }
WDASceneViewVRDisplayMode >> renderSceneViewports [
	| windowTarget |
	windowTarget := view window validResolveRenderTarget.
	
	^ view sceneRenderer renderSceneViewportsThenDo: [ :stateTracker |

		"Render into the main window."
		stateTracker
			reset;
			beginRenderPass: windowTarget validMainRenderPass renderTarget: windowTarget;
			shaderSignature: self compositionShaderSignature;
			vertexShader: engine resourceCache screenQuadVertexShader;
			fragmentShader: self fragmentShader;
			useShaderResources: self compositionShaderSignature defaultSamplers;
			useShaderResources: windowDisplayBinding;
			dispatchScreenQuadRender;
			endRenderPass.
			
		"Submit the eyes."
		engine frameBufferingDriver setCurrentVRLeftEyeTexture:
			leftRenderTarget currentFramebuffer colorAttachments first
			rightEyeTexture: rightRenderTarget currentFramebuffer colorAttachments first
	]
]

{ #category : #'render targets' }
WDASceneViewVRDisplayMode >> renderTargetExtentChanged [
	super renderTargetExtentChanged.
	
	windowDisplayBinding ifNil: [
		windowDisplayBinding := self compositionShaderSignature newSources
	].

	windowDisplayBinding
		bind: 0 renderTargetTexture: leftRenderTarget;
		bind: 1 renderTargetTexture: rightRenderTarget

]

{ #category : #'multi eye rendering' }
WDASceneViewVRDisplayMode >> rightEyeTransform [
	^ rightEyeTransform
]

{ #category : #'render targets' }
WDASceneViewVRDisplayMode >> rightRenderTargetRequiredExtent [
	^ engine vrSystem rightEyeRenderTargetExtent
]
