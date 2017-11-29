as yet unclassified
harmonicAt: index amplitude: amplitude frequency: frequency direction: direction
	| harmonics |
	harmonics := materialState harmonics.
	harmonics at: index put: (
		WTWaterHarmonic new
		amplitude: amplitude;
		frequency: frequency;
		center: direction;
		radial: false asBit
	).
	materialState harmonics: harmonics