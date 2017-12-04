commands
beginRenderPass: renderPass renderTarget: renderTarget bounds: bounds
	| origin extent |
	origin := bounds origin.
	extent := bounds extent.
	self beginRenderPass: renderPass renderTarget: renderTarget x: origin x y: origin y width: extent x height: extent y.
