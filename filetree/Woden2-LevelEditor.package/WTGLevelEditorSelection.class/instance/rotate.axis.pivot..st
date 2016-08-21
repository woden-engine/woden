transforming
rotate: angle axis: axis pivot: pivot
	| quaternion transformation |
	quaternion := WMQuaternionD axis: axis asWMVector3D angle: angle.
	transformation := WMReversibleAffineTransformD identity
		translateBy: pivot negated;
		applyOrthonormalMatrix: quaternion asWMMatrix3D;
		translateBy: pivot.
	self applyTransformation: transformation