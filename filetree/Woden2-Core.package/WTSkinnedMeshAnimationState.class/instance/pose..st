accessing
pose: anObject
	pose := anObject.
	poseMatrices := SLVMNativeArray for: WMMatrix4F new: pose size.
	poseForwardMatrices := SLVMNativeArray for: WMMatrix4F new: pose size.