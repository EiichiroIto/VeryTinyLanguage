Class {
	#name : #CVTLDummyUI,
	#superclass : #Object,
	#instVars : [
		'output',
		'input'
	],
	#category : #'CVTL-Tests'
}

{ #category : #accessing }
CVTLDummyUI >> addInput: aString [

	input add: aString
]

{ #category : #'input/output' }
CVTLDummyUI >> getLine [

	| line |
	input isEmpty ifTrue: [ ^ nil ].
	line := input removeFirst.
	^ line
]

{ #category : #initialization }
CVTLDummyUI >> initialize [

	output := OrderedCollection new.
	input := OrderedCollection new
]

{ #category : #accessing }
CVTLDummyUI >> input [

	^ input
]

{ #category : #accessing }
CVTLDummyUI >> input: anObject [

	input := anObject
]

{ #category : #accessing }
CVTLDummyUI >> output [

	^ output
]

{ #category : #accessing }
CVTLDummyUI >> output: anObject [

	output := anObject
]

{ #category : #accessing }
CVTLDummyUI >> outputString [

	^ String fromByteArray:
		  (output reject: [ :each | each = 10 ]) asByteArray
]

{ #category : #'input/output' }
CVTLDummyUI >> putAsciiValue: anInteger [

	output add: anInteger
]