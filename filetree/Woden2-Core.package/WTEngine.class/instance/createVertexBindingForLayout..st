resource building
createVertexBindingForLayout: vertexLayout
	^ (WTVertexBinding for: self) vertexLayout: vertexLayout; checkSession; yourself