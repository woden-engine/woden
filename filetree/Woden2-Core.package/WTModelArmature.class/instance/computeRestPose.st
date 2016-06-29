as yet unclassified
computeRestPose
	| identity |
	restPoseMatrices := NativeArray for: WMMatrix4F new: bones size.
	identity := WMMatrix4F identity.
	1 to: restPoseMatrices size do: [ :i |
		restPoseMatrices at: i put: identity
	]