construction
newFrom: anArray
	^ self new
		m11: (anArray at: 1) asNativeFloat; m12: (anArray at: 2) asNativeFloat; m13: (anArray at: 3) asNativeFloat; m14: (anArray at: 4) asNativeFloat;
		m21: (anArray at: 5) asNativeFloat; m22: (anArray at: 6) asNativeFloat; m23: (anArray at: 7) asNativeFloat; m24: (anArray at: 8) asNativeFloat;
		m31: (anArray at: 9) asNativeFloat; m32: (anArray at: 10) asNativeFloat; m33: (anArray at: 11) asNativeFloat; m34: (anArray at: 12) asNativeFloat;
		m41: (anArray at: 13) asNativeFloat; m42: (anArray at: 14) asNativeFloat; m43: (anArray at: 15) asNativeFloat; m44: (anArray at: 16) asNativeFloat;
		yourself