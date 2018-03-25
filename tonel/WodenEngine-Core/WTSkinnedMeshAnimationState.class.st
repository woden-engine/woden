Class {
	#name : #WTSkinnedMeshAnimationState,
	#superclass : #Object,
	#instVars : [
		'mesh',
		'poseBuffer',
		'pose',
		'poseMatrices',
		'poseForwardMatrices'
	],
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WTSkinnedMeshAnimationState >> actionNamed: actionName [
	^ mesh actions at: actionName
]

{ #category : #adding }
WTSkinnedMeshAnimationState >> addAction: action frame: frame [
	^ self addAction: action repeated: false frame: frame
]

{ #category : #adding }
WTSkinnedMeshAnimationState >> addAction: action repeated: repeated frame: frame [
	action bones do: [ :bone | self addActionBone: bone repeated: repeated frame: frame ]
]

{ #category : #adding }
WTSkinnedMeshAnimationState >> addActionBone: actionBone repeated: repeated frame: frame [
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
WTSkinnedMeshAnimationState >> computeFrameIndex: frame actionBone: actionBone repeated: repeated [
	| result |
	result := repeated
		ifTrue: [ frame % actionBone keyframes size ]
		ifFalse: [ frame min: actionBone keyframes size - 1 max: 0 ].
	^ result + 1
]

{ #category : #'as yet unclassified' }
WTSkinnedMeshAnimationState >> computePoseMatrices [
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

{ #category : #adding }
WTSkinnedMeshAnimationState >> interpolateFrame: a with: b alpha: alpha [
	| translation rotation |
	translation := (a translation * (1.0 - alpha)) + (b translation * alpha).
	rotation := ((a rotation * (1.0 - alpha)) + (b rotation * alpha)) normalized.
	^ WTAnimationActionBoneFrame new translation: translation; rotation: rotation; yourself
]

{ #category : #accessing }
WTSkinnedMeshAnimationState >> mesh [
	^ mesh
]

{ #category : #accessing }
WTSkinnedMeshAnimationState >> mesh: anObject [
	mesh := anObject
]

{ #category : #accessing }
WTSkinnedMeshAnimationState >> pose [
	^ pose
]

{ #category : #accessing }
WTSkinnedMeshAnimationState >> pose: anObject [
	pose := anObject.
	poseMatrices := SLVMNativeArray for: WMMatrix4F new: pose size.
	poseForwardMatrices := SLVMNativeArray for: WMMatrix4F new: pose size.
]

{ #category : #accessing }
WTSkinnedMeshAnimationState >> poseBuffer [
	^ poseBuffer
]

{ #category : #accessing }
WTSkinnedMeshAnimationState >> poseBuffer: anObject [
	poseBuffer := anObject
]

{ #category : #accessing }
WTSkinnedMeshAnimationState >> poseMatrices [
	^ poseMatrices
]

{ #category : #'as yet unclassified' }
WTSkinnedMeshAnimationState >> setRestPose [
	LibC memCopy: mesh armature bones rawData to: pose rawData size: pose rawDataSize.
	
]

{ #category : #'as yet unclassified' }
WTSkinnedMeshAnimationState >> setRestPoseAndMatrices [
	self
		setRestPose;
		setRestPoseMatrices
]

{ #category : #'as yet unclassified' }
WTSkinnedMeshAnimationState >> setRestPoseMatrices [
	LibC memCopy: mesh armature restPoseMatrices rawData to: poseMatrices rawData size: poseMatrices rawDataSize.
]
