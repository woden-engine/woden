accessing
validMainRenderPass
	^ mainRenderPass ifNil: [ mainRenderPass := self createRenderPassWithColor: Color transparent ].