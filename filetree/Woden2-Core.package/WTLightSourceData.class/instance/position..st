accessing
position: newPosition
	<accessor>
	<argument: #newPosition type: #(WMVector3F object)>
	positionOrDirection x: newPosition x.
	positionOrDirection y: newPosition y.
	positionOrDirection z: newPosition z.
	positionOrDirection w: 1.0 asNativeFloat.