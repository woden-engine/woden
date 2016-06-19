initialization
initialize
	materialState := WTGenericSurfaceMaterialState new
		albedo: Color white asWMVector4F;
		fresnel: (WMVector3F x: 0.03 y: 0.03 z: 0.03);
		smoothness: 0.45;
		yourself.
		
	self invalidateCache.