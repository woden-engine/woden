construction
radius: radius angle: angle
	<argument: #(radius angle) type: #double>
	^ self r: radius * angle cos asNativeDouble i: radius * angle sin asNativeDouble