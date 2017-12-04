resource building
createVertexBindingForLayout: vertexLayout
	^ (WDCVertexBinding for: self) vertexLayout: vertexLayout; checkSession; yourself