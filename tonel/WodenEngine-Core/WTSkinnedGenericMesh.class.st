Class {
	#name : #WTSkinnedGenericMesh,
	#superclass : #WTGenericMesh,
	#instVars : [
		'armature',
		'actions',
		'pose'
	],
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WTSkinnedGenericMesh >> actions [
	^ actions
]

{ #category : #accessing }
WTSkinnedGenericMesh >> actions: anObject [
	actions := anObject
]

{ #category : #accessing }
WTSkinnedGenericMesh >> armature [
	^ armature
]

{ #category : #accessing }
WTSkinnedGenericMesh >> armature: anObject [
	armature := anObject
]

{ #category : #'extra per object rendering data' }
WTSkinnedGenericMesh >> createSceneDependentDataFor: engine into: bindings [
	| stateSize poseBuffer |
	stateSize := self poseStateSize.
	poseBuffer := engine createStreamingStorageBuffer: stateSize * bindings size.
	bindings doWithIndex: [ :binding :index |
		binding bind: 2 storageBuffer: poseBuffer offset: (index - 1) * stateSize size: stateSize
	].

	^ WTSkinnedMeshAnimationState new
		mesh: self;
		poseBuffer: poseBuffer;
		pose: armature bones copy;
		setRestPoseAndMatrices;
		yourself
]

{ #category : #'extra per object rendering data' }
WTSkinnedGenericMesh >> performGpuStateUpdateFor: engine frameIndex: frameIndex into: animationState [
	| poseStateSize |
	poseStateSize := self poseStateSize.
	LibC memCopy: animationState poseMatrices rawData to: animationState poseBuffer validPointer getHandle + (poseStateSize * (frameIndex - 1)) size: poseStateSize
]

{ #category : #'extra per object rendering data' }
WTSkinnedGenericMesh >> poseStateSize [
	^ WMMatrix4F structureSize * armature bones size alignedTo: 256.
]
