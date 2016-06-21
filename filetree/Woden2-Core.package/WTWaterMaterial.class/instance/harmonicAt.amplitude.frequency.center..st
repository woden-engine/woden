as yet unclassified
harmonicAt: index amplitude: amplitude frequency: frequency center: center
	| harmonics |
	harmonics := materialState harmonics.
	harmonics at: index put: (
		WTWaterHarmonic new
		amplitude: amplitude;
		frequency: frequency;
		center: center;
		radial: true asBit
	).
	materialState harmonics: harmonics