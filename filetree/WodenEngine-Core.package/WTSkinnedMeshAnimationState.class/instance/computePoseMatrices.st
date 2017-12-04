as yet unclassified
computePoseMatrices
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