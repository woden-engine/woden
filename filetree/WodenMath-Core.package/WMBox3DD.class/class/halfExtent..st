construction
halfExtent: anExtent
	<argument: #anExtent type: #(WMVector3D object)>
	^ self min: anExtent negated max: anExtent