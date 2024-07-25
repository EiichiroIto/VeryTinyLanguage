Class {
	#name : #VTLSamples,
	#superclass : #Object,
	#category : #'VTL-Tests'
}

{ #category : #samples }
VTLSamples >> sample1 [

	^ '100 A=123
200 ?=A*2'
]

{ #category : #samples }
VTLSamples >> sample2 [

'00010 ) Factorial
00100 X=?
00200 Z=0
00300 #=1000
00400 ?=Y
00500 #=9999
01000 :Z)=!
01100 #=0<X*1400
01200 Y=1
01300 #=:Z)
01400 X=X-1
01500 Z=Z+1
01600 #=1000
01700 X=X+1
01800 Z=Z-1
01900 Y=Y*X
02000 #=:Z)'
]
