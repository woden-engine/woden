accessing
harmonicAt: index amplitude: amplitude frequency: frequency center: center
	materialState harmonicAt: index put: (
		WTWaterHarmonic new
		amplitude: amplitude;
		frequency: frequency;
		center: center;
		radial: true asBit
	).