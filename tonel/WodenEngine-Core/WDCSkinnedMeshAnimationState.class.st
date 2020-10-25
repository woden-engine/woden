"
I represent the animation state of a skinned mesh.
"
Class {
	#name : #WDCSkinnedMeshAnimationState,
	#superclass : #WDCRenderableDeformationState,
	#instVars : [
		'mesh',
		'poseBuffer',
		'poseMatrices',
		'poseForwardMatrices',
		'poseState'
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
	poseState at: actionBone boneIndex + 1 put: interpolatedFrame
]

{ #category : #adding }
WDCSkinnedMeshAnimationState >> applyAnimation: animation repeated: isRepeated inTime: animationTime [
	animation channels do: [ :each | self applyAnimationChannel: each repeated: isRepeated inTime: animationTime ]
]

{ #category : #adding }
WDCSkinnedMeshAnimationState >> applyAnimationChannel: channel repeated: isRepeated inTime: animationTime [
	| bonePoseState |
	bonePoseState := poseState at: channel targetBoneIndex + 1.
	channel applyToBoneState: bonePoseState repeated: isRepeated inTime: animationTime.
]

{ #category : #accessing }
WDCSkinnedMeshAnimationState >> armature [
	^ mesh armature
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
	poseForwardMatrices := self armature computeForwardMatricesWithPoseMatrices: (poseState collect: [:each | each matrix]).
	poseMatrices := self armature computeSkinningMatricesWithForwardMatrices: poseForwardMatrices.
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
	^ WDCSkinnedModelBoneState new translation: translation; rotation: rotation; yourself
]

{ #category : #'as yet unclassified' }
WDCSkinnedMeshAnimationState >> invalidateMatrices [
	poseMatrices := nil.
	poseForwardMatrices := nil.
]

{ #category : #testing }
WDCSkinnedMeshAnimationState >> isSkinningState [
	^ true
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
WDCSkinnedMeshAnimationState >> pose: anObject [
	poseState := anObject.
	self invalidateMatrices.
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
WDCSkinnedMeshAnimationState >> poseState [
	^ poseState
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
	self pose: self armature restPoseState
]

{ #category : #'as yet unclassified' }
WDCSkinnedMeshAnimationState >> setRestPoseAndMatrices [
	self
		setRestPose;
		setRestPoseMatrices
]

{ #category : #'as yet unclassified' }
WDCSkinnedMeshAnimationState >> setRestPoseMatrices [
	poseMatrices := self armature restPoseMatrices.
	poseForwardMatrices := self armature restPoseForwardMatrices.
]

{ #category : #'renderable state' }
WDCSkinnedMeshAnimationState >> updateCommonGpuStateForFrame: frameIndex [
	| poseStateSize |
	poseStateSize := self poseStateSize.
	LibC memCopy: poseMatrices rawData to: poseBuffer validPointer getHandle + (poseStateSize * (engine bufferingFrameIndex - 1)) size: poseStateSize
]
