construction
halfExtent: anExtent
	<argument: #anExtent type: #(WMVector3F object)>
	^ self min: anExtent negated max: anExtent