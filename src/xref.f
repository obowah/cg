\ $Id: xref.f,v 1.1 2011/03/19 23:26:09 rdack Exp $

\ XREF.F -- Fast cross reference lister, searches
\ lists and code in application and system dictionaries
\ Version 1.01  =  Entered in the library  August 2nd, 2003
\ This is by Rainbow sally circa December 2002 by John Peters' request
\ Optimized xref_inhileveldef? gah Thursday, June 24 2004 - 0:22
\ gah Monday, July 04 2005 added test to suppress treating the cfaptr as a reference
\     which caused the last word in system space to be printed. Improved output format

internal

\ checks for additional input
: ?in-empty     ( -- tf )
    \ Returns TRUE flag if line being interpreted
    \ or compiled contains no more text
    >in @ bl word c@ 0= swap >in ! ;

\ Returns TRUE flag if key is <esc> or Q (case insensitive)
: ?quitkey
        key upc 'Q' over = swap 27 = or
        if sp0 @ sp! cr ." Quitting.." cr quit then ;

\ Is addr the cfaptr of a word
: ?cfaptr         { addr \ flag -- f }
                false to flag
                voc-link
                begin   @ ?dup
                while   dup vlink>voc
                        dup voc#threads 0
                        do      dup i cells +
                                begin   @ ?dup
                                while   dup l>name n>cfaptr addr =
                                        if      true to flag
                                        then
                                repeat
                        loop    drop
                repeat  flag ;

external

TRUE value xref_Aligned

internal

: xref_InHiLevelDef?  ( addr -- cfa f )
\ *p cfa is the named definition with the highest cfa below addr
\ ** f is true if the definition is either a colon definition or a deferred word
\in-system-ok	?name
		dup @ dup docol = swap dodefer = or ;

: xref_FindLoop ( end start find-cfa -- found=T )
    0 \ to FoundFlg
    { FoundFlg \ StartAddr FindAddr -- FoundFlg }
    to FindAddr
    do
        i @ FindAddr =
        if
        i ?cfaptr 0= if
            TRUE to FoundFlg
            i
            xref_InHiLevelDef? 
            0= tuck
            if ." [ ??? " then
            >name .id
            if ."  ]" then
            20 #tab 20 ?cr
            key?
            if cr ." Current Search Address: " i .
                ." (" i StartAddr - 100 here StartAddr - */ (.) type
                ." % of search area)"
                key drop ?quitkey cr
            then
        then then
        xref_Aligned    \ check if only looking in lists (TRUE to xref_Aligned)
        if      4
        else    1
        then
    +loop
    FoundFlg ;

: (xref)  ( |name <StartAddress> -- ) \ aka ref
    \ find def in non-code words starts search at self unless
    \ start address specified.  Start address can be any
    \ executable text or number

    ' cr ." --------Application Space" horizontal-line

    0 ( StartAddr )
    { FindAddr StartAddr -- }
    ?in-empty
    if
        FindAddr align 4 + \ start above cfa to find
    else
        interpret
    then
    depth 1 <> abort" Param Stack Error!"

    app-origin umax
    to StartAddr
    StartAddr App-here u>
    if
        App-origin to StartAddr
    then
    App-here StartAddr FindAddr
    xref_FindLoop
    0= if ." No Cross References found in Application Space" then
    cr ." -------------System Space" horizontal-line

    sys-here sys-origin FindAddr
    xref_FindLoop
    0= if ." No Cross References found in System Space" then
    cr horizontal-line 
;

external

\in-system-ok ' (xref) is xref
' (xref) alias ref  \ August 2nd, 2003 - 18:01 JAP

module

cr .( 'Cross reference lister' loaded )
cr
cr .( Usage:" XREF <name> <Start address> )
cr
cr .( Find def <Name> in non-code words starts search at )
cr .( app-origin unless <Start address> is specified. )
cr .( The entire system space is also searched. )
cr .( Start address can be any executable text or number )
cr .( which results in an address in app space. )

\s --------------------------------- XREF.F


Notes from the uers: Saturday, June 05 2004 - 9:42
The CFA search is a little lacking in finesse. It also (oddly) is the
only piece of case sensitive code in W32F, barring DLL calls. - Alex

It's a useful tool, though with some limitations. I think the case
sensitivity was to hide the internal words (though IMO the Module
wordset should be used for this). It needs better documentation of
what the information means and perhaps extending to handle methods
etc. Like most tools it needs refining/extending so it evolves into
something better (A lot of the best tools in W32F like SEE and DEBUG
were originally ported from F-PC (and possibly earlier Forths of
Tom Zimmer) and so have had decades of evolution. - George

Many thanks to Rainbow Sally for pioneering this excellent tool



 