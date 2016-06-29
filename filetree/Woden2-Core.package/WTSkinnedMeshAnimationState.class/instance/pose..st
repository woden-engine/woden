accessing
pose: anObject
	pose := anObject.
	poseMatrices := NativeArray for: WMMatrix4F new: pose size.
	poseForwardMatrices := NativeArray for: WMMatrix4F new: pose size.