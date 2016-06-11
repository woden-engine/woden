accessing
direction: newDirection
	<accessor>
	<argument: #newDirection type: #(WMVector3F object)>
	positionOrDirection x: newDirection x.
	positionOrDirection y: newDirection y.
	positionOrDirection z: newDirection z.
	positionOrDirection w: 0.0 asNativeFloat.