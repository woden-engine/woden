Extension { #name : #DASLPharoBlockConverterVisitor }

{ #category : #'*WodenEngine-Core' }
DASLPharoBlockConverterVisitor class >> noise [
	<messageMaps>
	self
		mapMessage: #randomNoise toFunction: #randomNoise returnType: #float;
		mapMessage: #signedRandomNoise toFunction: #signedRandomNoise returnType: #float;

		mapMessage: #valueNoise toFunction: #valueNoise returnType: #float;
		mapMessage: #signedValueNoise toFunction: #signedValueNoise returnType: #float;

		mapMessage: #gradientNoise toFunction: #gradientNoise returnType: #float;
		mapMessage: #signedGradientNoise toFunction: #signedGradientNoise returnType: #float;

		mapMessage: #voronoiNoise toFunction: #voronoiNoise returnType: #float;
		mapMessage: #signedVoronoiNoise toFunction: #signedVoronoiNoise returnType: #float;

		mapMessage: #worleyNoise toFunction: #worleyNoise returnType: #float;
		mapMessage: #signedWorleyNoise toFunction: #signedWorleyNoise returnType: #float;

		mapMessage: #fbmValueNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmValueNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedValueNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmSignedValueNoiseOctaves returnType: #float;
		mapMessage: #fbmTiledValueNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmTiledValueNoiseOctaves returnType: #float;
		mapMessage: #fbmTiledSignedValueNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmTiledSignedValueNoiseOctaves returnType: #float;

		mapMessage: #fbmGradientNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmGradientNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedGradientNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmSignedGradientNoiseOctaves returnType: #float;
		mapMessage: #fbmTiledGradientNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmTiledGradientNoiseOctaves returnType: #float;
		mapMessage: #fbmTiledSignedGradientNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmTiledSignedGradientNoiseOctaves returnType: #float;

		mapMessage: #fbmVoronoiNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmVoronoiNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedVoronoiNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmSignedVoronoiNoiseOctaves returnType: #float;
		mapMessage: #fbmTiledVoronoiNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmTiledVoronoiNoiseOctaves returnType: #float;
		mapMessage: #fbmTiledSignedVoronoiNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmTiledSignedVoronoiNoiseOctaves returnType: #float;

		mapMessage: #fbmWorleyNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmWorleyNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedWorleyNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmSignedWorleyNoiseOctaves returnType: #float;
		mapMessage: #fbmTiledWorleyNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmTiledWorleyNoiseOctaves returnType: #float;
		mapMessage: #fbmTiledSignedWorleyNoiseOctaves:lacunarity:initialAmplitude:tiledWith: toFunction: #fbmTiledSignedWorleyNoiseOctaves returnType: #float;

		yourself

]
