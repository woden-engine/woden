projection matrices
reverseDepthFrustumLeft: left right: right bottom: bottom top: top near: near far: far invertedY: invertedY
	<argument: #(left right bottom top near far) type: #float>
	<var: #(twoNear) type: #float>
	<var: #result type: #(SelfType object)>
	| twoNear result |
	twoNear := 2.0 asNativeFloat * near.
	result := self new.
	result
		m11: twoNear / (right - left); m13: ((right + left) / (right - left)) negated;
		m22: twoNear / (top - bottom); m23: ((top + bottom) / (top - bottom)) negated;
		m33: near / (far - near); m34: ((near * far) / (far - near));
		m43: -1.0 asNativeFloat.
	invertedY ifTrue: [ 
		result m22: result m22 negated; m24: result m24 negated.
	].

	^ result