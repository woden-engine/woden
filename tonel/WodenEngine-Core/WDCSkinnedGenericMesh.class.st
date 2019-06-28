"
I am a generic mesh that is also deformed by an armature.
"
Class {
	#name : #WDCSkinnedGenericMesh,
	#superclass : #WDCMutableRenderable,
	#instVars : [
		'mesh',
		'armature',
		'actions',
		'pose',
		'animationState'
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
WDCSkinnedGenericMesh >> animationState [
	^ animationState ifNil: [ animationState := WDCSkinnedMeshAnimationState new
		mesh: self;
		pose: armature bones copy;
		setRestPoseAndMatrices;
		yourself
	]
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

{ #category : #accessing }
WDCSkinnedGenericMesh >> mesh [
	^ mesh
]

{ #category : #accessing }
WDCSkinnedGenericMesh >> mesh: anObject [
	mesh := anObject
]

{ #category : #'extra per object rendering data' }
WDCSkinnedGenericMesh >> poseStateSize [
	^ WMMatrix4F structureSize * armature bones size alignedTo: 256.
]

{ #category : #copying }
WDCSkinnedGenericMesh >> postCopy [
	super postCopy.
	mesh := mesh copyForResourceCacheInstancing.
	animationState := animationState copy.
]

{ #category : #rendering }
WDCSkinnedGenericMesh >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
]
