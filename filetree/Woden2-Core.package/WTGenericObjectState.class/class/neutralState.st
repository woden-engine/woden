as yet unclassified
neutralState
	^ self new
		transform: WMReversibleAffineTransformF identity asWMReversibleAffineTransformF;
		color: (WMVector4F x: 1.0 asNativeFloat32 y: 1.0 asNativeFloat32 z: 1.0 asNativeFloat32 w: 1.0 asNativeFloat32);
		yourself