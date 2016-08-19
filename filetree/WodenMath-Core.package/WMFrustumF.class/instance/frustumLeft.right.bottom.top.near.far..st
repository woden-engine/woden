construction
frustumLeft: left right: right bottom: bottom top: top near: near far: far
	| factor |
	leftBottomNear := WMVector3F x: left y: bottom z: near negated.
	rightBottomNear := WMVector3F x: right y: bottom z: near negated.
	leftTopNear := WMVector3F x: left y: top z: near negated.
	rightTopNear := WMVector3F x: right y: top z: near negated.

	factor := far / near.	
	leftBottomFar := leftBottomNear * factor.
	rightBottomFar := rightBottomNear * factor.
	leftTopFar := leftTopNear * factor.
	rightTopFar := rightTopNear * factor.
