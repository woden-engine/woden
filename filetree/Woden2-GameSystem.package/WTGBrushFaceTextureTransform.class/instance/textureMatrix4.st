private
textureMatrix4
	| c s sx sy ox oy|
	c := rotation degreeCos.
	s := rotation degreeSin.
	sx := scale x.
	sy := scale y.
	ox := offset x.
	oy := offset y.
	^ WMMatrix4D newFrom: {
		c * sx . s negated * sy . 0.0 . ox .
		s * sx . c * sy . 0.0 . oy .
		0.0 . 0.0 . 1.0 . 0.0 .
		0.0 . 0.0 . 0.0 . 1.0 .
	 }