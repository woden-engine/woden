extra per object rendering data
createSceneDependentDataFor: engine into: bindings
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