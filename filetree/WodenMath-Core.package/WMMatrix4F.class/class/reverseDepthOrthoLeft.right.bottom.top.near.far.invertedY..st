projection matrices
reverseDepthOrthoLeft: left right: right bottom: bottom top: top near: near far: far invertedY: invertedY
	<argument: #(left right bottom top near far) type: #float>
	<var: #result type: #(SelfType object)>
	| result |
	result := self new.
	result
		m11: 2.0 asNativeFloat / (right - left); m14: ((right + left) / (right - left)) negated;
		m22: 2.0 asNativeFloat / (top - bottom); m24: ((top + bottom) / (top - bottom)) negated;
		m33: 1.0 asNativeFloat / (far - near); m34: ((far) / (far - near));
		m44: 1.0 asNativeFloat.
	invertedY ifTrue: [ 
		result m22: result m22 negated; m24: result m24 negated.
	].

	^ result