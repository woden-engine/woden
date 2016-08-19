construction
orthoLeft: left right: right bottom: bottom top: top near: near far: far
	leftBottomNear := WMVector3F x: left y: bottom z: near negated.
	rightBottomNear := WMVector3F x: right y: bottom z: near negated.
	leftTopNear := WMVector3F x: left y: top z: near negated.
	rightTopNear := WMVector3F x: right y: top z: near negated.
	
	leftBottomFar := WMVector3F x: left y: bottom z: far negated.
	rightBottomFar := WMVector3F x: right y: bottom z: far negated.
	leftTopFar := WMVector3F x: left y: top z: far negated.
	rightTopFar := WMVector3F x: right y: top z: far negated.
	