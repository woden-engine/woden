accessing
computeSourceRectangleWithTexcoordScale: texcoordScale margin: margin
	<argument: #texcoordScale type: #(WMVector2F object)>
	<argument: #margin type: #float>
	^ WMBox2DF
		min: ((box min - (WMVector2F x: margin y: margin)) * texcoordScale) asWMVector2F
		max: ((box max + (WMVector2F x: margin y: margin)) * texcoordScale) asWMVector2F
