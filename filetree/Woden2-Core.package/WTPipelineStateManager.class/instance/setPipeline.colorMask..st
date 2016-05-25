pipeline state object building
setPipeline: pipeline colorMask: colorMask
	| renderTargetMask redEnabled greenEnabled blueEnabled alphaEnabled |
	renderTargetMask := colorMask at: 'render-target-mask'.
	redEnabled := colorMask at: 'red-enabled'.
	greenEnabled := colorMask at: 'green-enabled'.
	blueEnabled := colorMask at: 'blue-enabled'.
	alphaEnabled := colorMask at: 'alpha-enabled'.
	pipeline setColorMask: renderTargetMask redEnabled: redEnabled greenEnabled: greenEnabled blueEnabled: blueEnabled alphaEnabled: alphaEnabled