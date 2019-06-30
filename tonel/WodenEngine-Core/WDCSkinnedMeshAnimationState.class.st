"
I represent the animation state of a skinned mesh.
"
Class {
	#name : #WDCSkinnedMeshAnimationState,
	#superclass : #WDCRenderableAnimationState,
	#instVars : [
		'mesh',
		'poseBuffer',
		'pose',
		'poseMatrices',
		'poseForwardMatrices'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCSkinnedMeshAnimationState >> actionNamed: actionName [
	^ mesh actions at: actionName
]

{ #category : #adding }
WDCSkinnedMeshAnimationState >> addAction: action frame: frame [
	^ self addAction: action repeated: false frame: frame
]

{ #category : #adding }
WDCSkinnedMeshAnimationState >> addAction: action repeated: repeated frame: frame [
	action bones do: [ :bone | self addActionBone: bone repeated: repeated frame: frame ]
]

{ #category : #adding }
WDCSkinnedMeshAnimationState >> addActionBone: actionBone repeated: repeated frame: frame [
	| floorFrameIndex ceilingFrameIndex alpha floorFrame ceilingFrame interpolatedFrame |
	floorFrameIndex := self computeFrameIndex: frame floor asInteger actionBone: actionBone repeated: repeated.
	ceilingFrameIndex := self computeFrameIndex: frame ceiling asInteger actionBone: actionBone repeated: repeated.
	alpha := frame - floorFrameIndex min: 1.0 max: 0.0.
	
	floorFrame := actionBone keyframes at: floorFrameIndex.
	ceilingFrame := actionBone keyframes at: ceilingFrameIndex.
	
	interpolatedFrame := self interpolateFrame: floorFrame with: ceilingFrame alpha: alpha.
	pose at: actionBone boneIndex + 1 put: interpolatedFrame
]

{ #category : #adding }
WDCSkinnedMeshAnimationState >> computeFrameIndex: frame actionBone: actionBone repeated: repeated [
	| result |
	result := repeated
		ifTrue: [ frame % actionBone keyframes size ]
		ifFalse: [ frame min: actionBone keyframes size - 1 max: 0 ].
	^ result + 1
]

{ #category : #'as yet unclassified' }
WDCSkinnedMeshAnimationState >> computePoseMatrices [
	| parents bone parentIndex forwardMatrix restPoseInverseMatrices restPoseInverseMatrix parentForwardMatrix |
	parents := mesh armature boneParents. 
	restPoseInverseMatrices := mesh armature restPoseInverseMatrices.
	
	1 to: pose size do: [ :i |
		bone := pose at: i.
		parentIndex := parents at: i.
		forwardMatrix := bone forwardMatrix.
		restPoseInverseMatrix := restPoseInverseMatrices at: i.
		
		parentIndex >= 0 ifTrue: [
			parentForwardMatrix := poseForwardMatrices at: parentIndex + 1.
			
			forwardMatrix := parentForwardMatrix * forwardMatrix.
		].
	
		poseForwardMatrices at: i put: forwardMatrix.
		poseMatrices at: i put: forwardMatrix * restPoseInverseMatrix. 
	].
]

{ #category : #accessing }
WDCSkinnedMeshAnimationState >> createEngineDependantData [
	| stateSize |
	super createEngineDependantData.
	stateSize := self poseStateSize.
	poseBuffer := engine createStreamingStorageBuffer: stateSize * renderableStateBindings size.

	renderableStateBindings doWithIndex: [ :bindings :index |
		bindings
			bind: 0 storageBuffer: poseBuffer offset: (index - 1) * stateSize size: stateSize
	]
]

{ #category : #accessing }
WDCSkinnedMeshAnimationState >> destroyEngineDependantData [
	poseBuffer := nil.
]

{ #category : #adding }
WDCSkinnedMeshAnimationState >> interpolateFrame: a with: b alpha: alpha [
	| translation rotation |
	translation := (a translation * (1.0 - alpha)) + (b translation * alpha).
	rotation := ((a rotation * (1.0 - alpha)) + (b rotation * alpha)) normalized.
	^ WTAnimationActionBoneFrame new translation: translation; rotation: rotation; yourself
]

{ #category : #accessing }
WDCSkinnedMeshAnimationState >> mesh [
	^ mesh
]

{ #category : #accessing }
WDCSkinnedMeshAnimationState >> mesh: anObject [
	mesh := anObject
]

{ #category : #accessing }
WDCSkinnedMeshAnimationState >> pose [
	^ pose
]

{ #category : #accessing }
WDCSkinnedMeshAnimationState >> pose: anObject [
	pose := anObject.
	poseMatrices := SLVMNativeArray for: WMMatrix4F new: pose size.
	poseForwardMatrices := SLVMNativeArray for: WMMatrix4F new: pose size.
]

{ #category : #accessing }
WDCSkinnedMeshAnimationState >> poseBuffer [
	^ poseBuffer
]

{ #category : #accessing }
WDCSkinnedMeshAnimationState >> poseBuffer: anObject [
	poseBuffer := anObject
]

{ #category : #accessing }
WDCSkinnedMeshAnimationState >> poseMatrices [
	^ poseMatrices
]

{ #category : #accessing }
WDCSkinnedMeshAnimationState >> poseStateSize [
	^ mesh poseStateSize
]

{ #category : #accessing }
WDCSkinnedMeshAnimationState >> requiresAccessFromTheCPU [
	^ true
]

{ #category : #'as yet unclassified' }
WDCSkinnedMeshAnimationState >> setRestPose [
	LibC memCopy: mesh armature bones rawData to: pose rawData size: pose rawDataSize.
	
]

{ #category : #'as yet unclassified' }
WDCSkinnedMeshAnimationState >> setRestPoseAndMatrices [
	self
		setRestPose;
		setRestPoseMatrices
]

{ #category : #'as yet unclassified' }
WDCSkinnedMeshAnimationState >> setRestPoseMatrices [
	LibC memCopy: mesh armature restPoseMatrices rawData to: poseMatrices rawData size: poseMatrices rawDataSize.
]

{ #category : #'renderable state' }
WDCSkinnedMeshAnimationState >> updateCommonGpuStateForFrame: frameIndex [
	| poseStateSize |
	poseStateSize := self poseStateSize.
	LibC memCopy: poseMatrices rawData to: poseBuffer validPointer getHandle + (poseStateSize * (engine bufferingFrameIndex - 1)) size: poseStateSize
]
