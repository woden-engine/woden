accessing
albedoColor: aColor
	materialState albedo: aColor asWMVector4F.
	self uploadMaterialStateData.