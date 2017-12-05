multi eye rendering
applyVRTransformToCamera: cameraTransform eye: eyeTranslation
	| orientation extraTranslation |
	orientation := headsetOrientation * cameraTransform matrix.
	extraTranslation := orientation transformPosition3: eyeTranslation.
	^ WMReversibleAffineTransformF new
		orthonormal: orientation translation: (cameraTransform translation + extraTranslation)