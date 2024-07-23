"
A CVTLNonInteractiveUITest is a test class for testing the behavior of CVTLNonInteractiveUI
"
Class {
	#name : #CVTLNonInteractiveUITest,
	#superclass : #TestCase,
	#category : #'CVTL-Tests'
}

{ #category : #'instance creation' }
CVTLNonInteractiveUITest >> newObj [

	^ CVTLNonInteractiveUI new
]

{ #category : #tests }
CVTLNonInteractiveUITest >> testAddInput [

	| obj |
	obj := self newObj.
	self assert: obj input isCollection.
	self assert: obj input isEmpty.
	obj addInput: 'abc'.
	obj addInput: 'def'.
	self assert: obj input size equals: 2.
	self assert: obj input first equals: 'abc'.
	self assert: obj input second equals: 'def'
]

{ #category : #tests }
CVTLNonInteractiveUITest >> testGetAsciiValue [

	| obj r |
	obj := self newObj.
	obj addInput: 'ab'.
	obj addInput: 'cd'.
	r := obj getAsciiValue.
	self assert: r equals: $a asciiValue.
	r := obj getAsciiValue.
	self assert: r equals: $b asciiValue.
	r := obj getAsciiValue.
	self assert: r equals: Character cr asciiValue.
	r := obj getAsciiValue.
	self assert: r equals: $c asciiValue.
	r := obj getAsciiValue.
	self assert: r equals: $d asciiValue
]

{ #category : #tests }
CVTLNonInteractiveUITest >> testInitialize [

	| obj |
	obj := self newObj.
	self assert: obj output isCollection.
	self assert: obj output isEmpty.
	self assert: obj input isCollection.
	self assert: obj input isEmpty
]

{ #category : #tests }
CVTLNonInteractiveUITest >> testInput [

	| obj arr |
	obj := self newObj.
	self assert: obj input isCollection.
	self assert: obj input isEmpty.
	arr := #( 1 2 3 ) asOrderedCollection.
	obj input: arr.
	self assert: obj input identicalTo: arr
]

{ #category : #tests }
CVTLNonInteractiveUITest >> testOutput [

	| obj arr |
	obj := self newObj.
	self assert: obj output isCollection.
	self assert: obj output isEmpty.
	arr := #( 1 2 3 ) asOrderedCollection.
	obj output: arr.
	self assert: obj output identicalTo: arr
]

{ #category : #tests }
CVTLNonInteractiveUITest >> testOutputString [

	| obj |
	obj := self newObj.
	self assert: obj outputString isEmpty.
	obj putAsciiValue: $A asciiValue.
	obj putAsciiValue: $B asciiValue.
	obj putAsciiValue: $C asciiValue.
	obj putAsciiValue: Character cr asciiValue.
	obj putAsciiValue: Character lf asciiValue.
	obj putAsciiValue: $D asciiValue.
	obj putAsciiValue: $E asciiValue.
	obj putAsciiValue: $F asciiValue.
	self assert: obj outputString equals: 'ABC
DEF'
]

{ #category : #tests }
CVTLNonInteractiveUITest >> testPutAsciiValue [

	| obj |
	obj := self newObj.
	self assert: obj output isCollection.
	self assert: obj output isEmpty.
	obj putAsciiValue: $A asciiValue.
	obj putAsciiValue: $B asciiValue.
	obj putAsciiValue: $C asciiValue.
	self assert: obj output size equals: 3.
	self assert: obj output first equals: $A asciiValue.
	self assert: obj output second equals: $B asciiValue.
	self assert: obj output third equals: $C asciiValue
]
