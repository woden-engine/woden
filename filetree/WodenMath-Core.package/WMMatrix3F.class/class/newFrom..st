construction
newFrom: anArray
	^ self new
		m11: (anArray at: 1) asNativeFloat; m12: (anArray at: 2) asNativeFloat; m13: (anArray at: 3) asNativeFloat;
		m21: (anArray at: 4) asNativeFloat; m22: (anArray at: 5) asNativeFloat; m23: (anArray at: 6) asNativeFloat;
		m31: (anArray at: 7) asNativeFloat; m32: (anArray at: 8) asNativeFloat; m33: (anArray at: 9) asNativeFloat;
		yourself