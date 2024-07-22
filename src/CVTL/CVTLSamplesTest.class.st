"
A CVTLSamplesTest is a test class for testing the behavior of CVTLSamples
"
Class {
	#name : #CVTLSamplesTest,
	#superclass : #TestCase,
	#category : #'CVTL-Tests'
}

{ #category : #constants }
CVTLSamplesTest >> defaultRandomSeed [

	^ 12345
]

{ #category : #private }
CVTLSamplesTest >> execute: aString [

	| obj ui |
	obj := self newObj.
	self setupFor: obj.
	ui := self newUI.
	aString linesDo: [ :str | ui addInput: str ].
	ui addInput: '#=1'.
	obj ui: ui.
	[ 
	obj doOneCycle.
	obj status isStepping or: [ ui input notEmpty ] ] whileTrue.
	^ ui
]

{ #category : #constants }
CVTLSamplesTest >> memorySize [

	^ 1024 * 32
]

{ #category : #'instance creation' }
CVTLSamplesTest >> newObj [

	^ CVTL new
]

{ #category : #'instance creation' }
CVTLSamplesTest >> newSamples [

	^ CVTLSamples new
]

{ #category : #'instance creation' }
CVTLSamplesTest >> newUI [

	^ CVTLDummyUI new
]

{ #category : #private }
CVTLSamplesTest >> setupFor: aCVTL [

	| memory |
	memory := CVTLMemory new.
	aCVTL memory: memory.
	memory allocate: self memorySize.
	aCVTL memoryLimit: self memorySize.
	aCVTL boundary: aCVTL programAddress.
	memory wordAt: aCVTL randomAddress put: self defaultRandomSeed.
	aCVTL status: CVTLStatus new
]

{ #category : #tests }
CVTLSamplesTest >> testSample1 [

	| samples ui |
	samples := self newSamples.
	ui := self execute: samples sample1.
	self assert: ui outputString equals: '100 A=123
200 ?=A*2
#=1
246
OK
'
]
