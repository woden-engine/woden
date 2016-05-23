baseline
baseline: spec
    <baseline>
    spec for: #'common' do: [
			spec blessing: #baseline.
			spec 
				project: 'NeoJSON' with: [
				spec
					className: #ConfigurationOfNeoJSON;
					versionString: #'stable';
					repository: 'http://mc.stfx.eu/Neo' ].
			spec 
				project: 'AbstractGPU' with: [
				spec
					className: #ConfigurationOfAbstractGPU;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/ronsaldo/AbstractGPU/main' ].
		spec package: #'Woden2-Core' with: [
				spec requires: #('NeoJSON' 'AbstractGPU')].
		spec group: 'default' with: #('Woden2-Core')
	]
