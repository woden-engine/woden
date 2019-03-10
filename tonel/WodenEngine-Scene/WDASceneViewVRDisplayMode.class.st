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
	leftProjectionMatrix := engine vrSystem leftEyeProjectionMatrixNear: near far: far invertedY: invertedY.
	rightProjectionMatrix := engine vrSystem rightEyeProjectionMatrixNear: near far: far invertedY: invertedY.
	leftEyeTransform := engine vrSystem leftEyeTransform.
	rightEyeTransform := engine vrSystem rightEyeTransform

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
			vertexShader: engine screenQuadVertexShader;
			fragmentShader: self windowDisplayShader;
			useShaderResources: self compositionShaderSignature defaultSamplers;
			useShaderResources: windowDisplayBinding;
			primitiveType: AGPU_TRIANGLE_STRIP;
			drawArrays: 4 instance_count: 1 first_vertex: 0 base_instance: 0;
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
		windowDisplayBinding := self compositionShaderSignature newSource
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

{ #category : #accessing }
WDASceneViewVRDisplayMode >> windowDisplayShader [
	^ windowDisplayShader ifNil: [ windowDisplayShader := engine loadFragmentShader: 'shaders/composition/passthroughFragment.dastrel' ]
]
