construction
nx: nx ny: ny nz: nz px: px py: py pz: pz
	<argument: #(nx ny nz px py pz) type: #float>
	<var: #result type: #(SelfType object)>
	| result |
	result := self new.
	result min x: nx.
	result min y: ny.
	result min z: nz.
	result max x: px.
	result max y: py.
	result max z: pz.
	^ result
		