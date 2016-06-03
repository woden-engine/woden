public
clear: clearColor
	| color w h |
	color := clearColor asWMVector4F.
	w := extent x asFloat.
	h := extent y asFloat.
	self
		beginShape: AGPU_TRIANGLES pipeline: convexColorTrianglePipeline;
		beginWithNewBaseVertex;
		addVertex: (WMVector2F x: 0.0 y: 0.0) color: color;
		addVertex: (WMVector2F x: w y: 0.0) color: color;
		addVertex: (WMVector2F x: w y: h) color: color;
		addVertex: (WMVector2F x: 0.0 y: h) color: color;
		addIndex: 0;
		addIndex: 1;
		addIndex: 2;
		addIndex: 2;
		addIndex: 3;
		addIndex: 0