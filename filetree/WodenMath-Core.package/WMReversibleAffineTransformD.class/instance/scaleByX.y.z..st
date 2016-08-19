transformation building
scaleByX: x y: y z: z
	self applyMatrix: (WMMatrix3D scaleX: x y: y z: z) matrixInverse: (WMMatrix3D scaleX: x reciprocalFloatQuiet y: y reciprocalFloatQuiet z: z reciprocalFloatQuiet)