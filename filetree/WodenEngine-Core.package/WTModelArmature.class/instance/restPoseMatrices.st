accessing
restPoseMatrices
	restPoseMatrices ifNil: [ self computeRestPose ].
	^ restPoseMatrices