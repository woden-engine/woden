"
I am a generic mesh that is also deformed by an armature.
"
Class {
	#name : #WDCSkinnedGenericMesh,
	#superclass : #WDCGenericMesh,
	#instVars : [
		'armature',
		'actions',
		'pose'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCSkinnedGenericMesh >> actions [
	^ actions
]

{ #category : #accessing }
WDCSkinnedGenericMesh >> actions: anObject [
	actions := anObject
]

{ #category : #accessing }
WDCSkinnedGenericMesh >> armature [
	^ armature
]

{ #category : #accessing }
WDCSkinnedGenericMesh >> armature: anObject [
	armature := anObject
]

{ #category : #'extra per object rendering data' }
WDCSkinnedGenericMesh >> createSceneDependentDataFor: engine into: bindings [
	| stateSize poseBuffer |
	stateSize := self poseStateSize.
	poseBuffer := engine createStreamingStorageBuffer: stateSize * bindings size.
	bindings doWithIndex: [ :binding :index |
		binding bind: 2 storageBuffer: poseBuffer offset: (index - 1) * stateSize size: stateSize
	].

	^ WDCSkinnedMeshAnimationState new
		mesh: self;
		poseBuffer: poseBuffer;
		pose: armature bones copy;
		setRestPoseAndMatrices;
		yourself
]

{ #category : #'extra per object rendering data' }
WDCSkinnedGenericMesh >> performCommonGpuStateUpdateFor: engine frameIndex: frameIndex into: animationState [
	| poseStateSize |
	poseStateSize := self poseStateSize.
	LibC memCopy: animationState poseMatrices rawData to: animationState poseBuffer validPointer getHandle + (poseStateSize * (frameIndex - 1)) size: poseStateSize
]

{ #category : #'extra per object rendering data' }
WDCSkinnedGenericMesh >> poseStateSize [
	^ WMMatrix4F structureSize * armature bones size alignedTo: 256.
]
