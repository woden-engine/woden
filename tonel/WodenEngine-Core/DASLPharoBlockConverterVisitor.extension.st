Extension { #name : #DASLPharoBlockConverterVisitor }

{ #category : #'*WodenEngine-Core' }
DASLPharoBlockConverterVisitor class >> fuzzyLogic [
	<messageMaps>
	self
		mapMessage: #fuzzyAnd: toFunction: #fuzzyAnd returnType: #float;
		mapMessage: #fuzzyNot toFunction: #fuzzyNot returnType: #float;
		mapMessage: #fuzzyOr: toFunction: #fuzzyOr returnType: #float;
		mapMessage: #fuzzyXor: toFunction: #fuzzyXor returnType: #float;

		mapMessage: #productFuzzyAnd: toFunction: #productFuzzyAnd returnType: #float;
		mapMessage: #productFuzzyNot toFunction: #productFuzzyNot returnType: #float;
		mapMessage: #productFuzzyOr: toFunction: #productFuzzyOr returnType: #float;
		mapMessage: #productFuzzyXor: toFunction: #productFuzzyXor returnType: #float;

		yourself

]

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

		mapMessage: #fbmValueNoiseOctaves:lacunarity: toFunction: #fbmValueNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedValueNoiseOctaves:lacunarity: toFunction: #fbmSignedValueNoiseOctaves returnType: #float;
		mapMessage: #fbmValueNoiseOctaves:lacunarity:tiledWith: toFunction: #fbmTiledValueNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedValueNoiseOctaves:lacunarity:tiledWith: toFunction: #fbmTiledSignedValueNoiseOctaves returnType: #float;

		mapMessage: #fbmGradientNoiseOctaves:lacunarity: toFunction: #fbmGradientNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedGradientNoiseOctaves:lacunarity: toFunction: #fbmSignedGradientNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedGradientNoiseAbsOctaves:lacunarity: toFunction: #fbmSignedGradientNoiseAbsOctaves returnType: #float;
		mapMessage: #fbmGradientNoiseOctaves:lacunarity:tiledWith: toFunction: #fbmTiledGradientNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedGradientNoiseOctaves:lacunarity:tiledWith: toFunction: #fbmTiledSignedGradientNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedGradientNoiseAbsOctaves:lacunarity:tiledWith: toFunction: #fbmTiledSignedGradientNoiseAbsOctaves returnType: #float;

		mapMessage: #fbmVoronoiNoiseOctaves:lacunarity: toFunction: #fbmVoronoiNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedVoronoiNoiseOctaves:lacunarity: toFunction: #fbmSignedVoronoiNoiseOctaves returnType: #float;
		mapMessage: #fbmVoronoiNoiseOctaves:lacunarity:tiledWith: toFunction: #fbmTiledVoronoiNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedVoronoiNoiseOctaves:lacunarity:tiledWith: toFunction: #fbmTiledSignedVoronoiNoiseOctaves returnType: #float;

		mapMessage: #fbmWorleyNoiseOctaves:lacunarity: toFunction: #fbmWorleyNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedWorleyNoiseOctaves:lacunarity: toFunction: #fbmSignedWorleyNoiseOctaves returnType: #float;
		mapMessage: #fbmWorleyNoiseOctaves:lacunarity:tiledWith: toFunction: #fbmTiledWorleyNoiseOctaves returnType: #float;
		mapMessage: #fbmSignedWorleyNoiseOctaves:lacunarity:tiledWith: toFunction: #fbmTiledSignedWorleyNoiseOctaves returnType: #float;

		mapMessage: #turbulence toFunction: #turbulence returnType: #float;
		mapMessage: #turbulenceScales: toFunction: #turbulenceScales returnType: #float;

		yourself

]
