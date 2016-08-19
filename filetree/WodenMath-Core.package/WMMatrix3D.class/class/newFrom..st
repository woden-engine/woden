construction
newFrom: anArray
	^ self new
		m11: (anArray at: 1) asNativeDouble; m12: (anArray at: 2) asNativeDouble; m13: (anArray at: 3) asNativeDouble;
		m21: (anArray at: 4) asNativeDouble; m22: (anArray at: 5) asNativeDouble; m23: (anArray at: 6) asNativeDouble;
		m31: (anArray at: 7) asNativeDouble; m32: (anArray at: 8) asNativeDouble; m33: (anArray at: 9) asNativeDouble;
		yourself