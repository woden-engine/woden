window points
rayAtNormalizedPoint: normalizedPoint
	| nearPoint farPoint |
	nearPoint := self nearNormalizedPoint: normalizedPoint.
	farPoint := self farNormalizedPoint: normalizedPoint.
	^ WMRayF origin: nearPoint direction: (farPoint - nearPoint) normalized.