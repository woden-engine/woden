initialization
reverseDepthPerspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY
	eyes do: [ :eye |
		eye reverseDepthPerspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY
	]