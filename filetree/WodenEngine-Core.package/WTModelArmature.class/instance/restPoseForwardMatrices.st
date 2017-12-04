accessing
restPoseForwardMatrices
	restPoseForwardMatrices ifNil: [ self computeRestPoseForwardAndInverse ].
	^ restPoseForwardMatrices