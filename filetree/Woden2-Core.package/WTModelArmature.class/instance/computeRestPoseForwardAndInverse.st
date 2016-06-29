as yet unclassified
computeRestPoseForwardAndInverse
	| bone parentIndex parentInverseMatrix parentForwardMatrix forwardMatrix inverseMatrix |
	restPoseForwardMatrices := NativeArray for: WMMatrix4F new: bones size.
	restPoseInverseMatrices := NativeArray for: WMMatrix4F new: bones size.
	1 to: bones size do: [ :i |
		bone := bones at: i.
		parentIndex := boneParents at: i.
		forwardMatrix := bone forwardMatrix.
		inverseMatrix := bone inverseMatrix.
				
		parentIndex >= 0 ifTrue: [
			parentForwardMatrix := restPoseForwardMatrices at: parentIndex + 1.
			parentInverseMatrix := restPoseInverseMatrices at: parentIndex + 1.
			
			forwardMatrix := parentForwardMatrix * forwardMatrix.
			inverseMatrix := inverseMatrix * parentInverseMatrix.
		].
	
		restPoseForwardMatrices at: i put: forwardMatrix.
		restPoseInverseMatrices at: i put: inverseMatrix.
	]