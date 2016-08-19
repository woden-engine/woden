window points
nearNormalizedPoint: normalizedPoint
	^ self
		lerp: (self lerp: leftBottomNear end: rightBottomNear alpha: normalizedPoint x asFloat)
		end: (self lerp: leftTopNear end: rightTopNear alpha: normalizedPoint x asFloat)
		alpha: normalizedPoint y asFloat