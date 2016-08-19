construction
nx: nx ny: ny px: px py: py
	<argument: #(nx ny px py) type: #float>
	<var: #result type: #(SelfType object)>
	| result |
	result := self new.
	result min x: nx.
	result min y: ny.
	result max x: px.
	result max y: py.
	^ result
		