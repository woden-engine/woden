window points
lerp: start end: end alpha: alpha
	^ (start * (1.0 - alpha)) + (end * alpha)