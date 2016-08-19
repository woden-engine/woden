construction
radius: radius angle: angle
	<argument: #(radius angle) type: #float>
	^ self r: radius * angle cos asNativeFloat i: radius * angle sin asNativeFloat