construction
halfExtent: anExtent center: center
	<argument: #(anExtent center) type: #(WMVector3D object)>
	^ self min: anExtent negated + center max: anExtent + center