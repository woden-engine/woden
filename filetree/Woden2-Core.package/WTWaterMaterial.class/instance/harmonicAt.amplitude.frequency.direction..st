accessing
harmonicAt: index amplitude: amplitude frequency: frequency direction: direction
	materialState harmonicAt: index put: (
		WTWaterHarmonic new
		amplitude: amplitude;
		frequency: frequency;
		center: direction;
		radial: false asBit
	).