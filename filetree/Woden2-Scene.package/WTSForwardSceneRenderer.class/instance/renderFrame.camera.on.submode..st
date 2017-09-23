rendering
renderFrame: frameIndex camera: camera on: aRenderTarget submode: submode
	| viewports |
	viewports := camera viewportsForRenderTarget: aRenderTarget submode: submode.
	^ self renderFrame: frameIndex viewports: viewports on: aRenderTarget