accessing
restPoseInverseMatrices
	restPoseInverseMatrices ifNil: [ self computeRestPoseForwardAndInverse ].
	^ restPoseInverseMatrices