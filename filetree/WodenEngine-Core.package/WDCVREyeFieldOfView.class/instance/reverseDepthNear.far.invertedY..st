as yet unclassified
reverseDepthNear: nearDistance far: farDistance invertedY: invertedY
	^ WMMatrix4F reverseDepthFrustumLeft: left tan * nearDistance negated
		right: right tan * nearDistance
		bottom: bottom tan * nearDistance negated
		top: top tan * nearDistance
		near: nearDistance far: farDistance invertedY: invertedY