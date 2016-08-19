instance creation
newFrom: anArray
	^ self new
		m11: (anArray at: 1) asNativeDouble; m12: (anArray at: 2) asNativeDouble; m13: (anArray at: 3) asNativeDouble; m14: (anArray at: 4) asNativeDouble;
		m21: (anArray at: 5) asNativeDouble; m22: (anArray at: 6) asNativeDouble; m23: (anArray at: 7) asNativeDouble; m24: (anArray at: 8) asNativeDouble;
		m31: (anArray at: 9) asNativeDouble; m32: (anArray at: 10) asNativeDouble; m33: (anArray at: 11) asNativeDouble; m34: (anArray at: 12) asNativeDouble;
		m41: (anArray at: 13) asNativeDouble; m42: (anArray at: 14) asNativeDouble; m43: (anArray at: 15) asNativeDouble; m44: (anArray at: 16) asNativeDouble;
		yourself