window points
farNormalizedPoint: normalizedPoint
	^ self
		lerp: (self lerp: leftBottomFar end: rightBottomFar alpha: normalizedPoint x asFloat)
		end: (self lerp: leftTopFar end: rightTopFar alpha: normalizedPoint x asFloat)
		alpha: normalizedPoint y asFloat