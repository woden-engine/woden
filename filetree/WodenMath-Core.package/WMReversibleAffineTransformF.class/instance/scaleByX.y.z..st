transformation building
scaleByX: x y: y z: z
	self applyMatrix: (WMMatrix3F scaleX: x y: y z: z) matrixInverse: (WMMatrix3F scaleX: x reciprocalFloatQuiet y: y reciprocalFloatQuiet z: z reciprocalFloatQuiet)