! Copyright (C) 2019 Atena Swoja.
! See http://factorcode.org/license.txt for BSD license.
USING: tools.test 2048-game 2048-game.private fry sequence-utils assocs macros quotations math grouping memoize arrays sets io formatting continuations ; 
EXCLUDE: kernel => build ;
EXCLUDE: sequences => move ;
FROM: accessors => tiles>> >>tiles  width>> height>> change-tiles level>> ;
FROM: sequence-utils => build ;
IN: 2048.tests


! [[ tiles match

MEMO: all-pairs ( n -- seq ) 
    1 + <iota> dup cartesian-product concat
;

MEMO: matching-pairs ( n -- seq )
    1 + <iota> dup zip
;

MEMO: mismatching-pairs ( n -- seq )
    all-pairs [ all-eq? not ] filter
;

{ t } [ 255    matching-pairs [ [ <tile> ] map all-equal? ] all? ] unit-test
{ f } [ 255 mismatching-pairs [ [ <tile> ] map all-equal? ] any? ] unit-test

{ f } [ f        1 <tile> = ] unit-test
{ f } [ 1 <tile> f        = ] unit-test
{ t } [ f        f        = ] unit-test
{ t } [ 1 <tile> 1 <tile> = ] unit-test

{ f             T{ tile f 1 } } [ f        1 <tile> combine-tiles ] unit-test
{ T{ tile f 1 } f             } [ 1 <tile> f        combine-tiles ] unit-test
{ f             f             } [ f        f        combine-tiles ] unit-test
{ f             T{ tile f 2 } } [ 1 <tile> 1 <tile> combine-tiles ] unit-test
{ T{ tile f 1 } T{ tile f 2 } } [ 1 <tile> 2 <tile> combine-tiles ] unit-test
{ T{ tile f 2 } T{ tile f 1 } } [ 2 <tile> 1 <tile> combine-tiles ] unit-test

{ { f } }                   [ { f } collapse ] unit-test
{ { f f } }                 [ { f f } collapse ] unit-test
{ { f f f } }               [ { f f f } collapse ] unit-test
{ { f f f f } }             [ { f f f f } collapse ] unit-test
{ { T{ tile f 1 } f f f } } [ { f T{ tile f 1 } f f } collapse ] unit-test
{ { T{ tile f 2 } f f f } } [ { T{ tile f 1 } T{ tile f 1 } f f } collapse ] unit-test
{ { T{ tile f 2 } f f f } } [ { f f T{ tile f 1 } T{ tile f 1 } } collapse ] unit-test
{ { T{ tile f 2 } f f f } } [ { f T{ tile f 1 } f T{ tile f 1 } } collapse ] unit-test
{ { T{ tile f 2 } f f f } } [ { T{ tile f 1 } f f T{ tile f 1 } } collapse ] unit-test
{ { T{ tile f 2 } T{ tile f 1 } f f } } [ { T{ tile f 1 } f T{ tile f 1 } T{ tile f 1 } } collapse ] unit-test
{ { T{ tile f 2 } T{ tile f 2 } f f } } [ { T{ tile f 1 } T{ tile f 1 } T{ tile f 1 } T{ tile f 1 } } collapse ] unit-test
{ { T{ tile f 2 } T{ tile f 2 } f f } } [ { T{ tile f 2 } f T{ tile f 1 } T{ tile f 1 } } collapse ] unit-test
{ { T{ tile f 2 } T{ tile f 2 } f f } } [ { T{ tile f 1 } T{ tile f 1 } f T{ tile f 2 } } collapse ] unit-test

{ f } [ { T{ tile f 1 } } can-move-left? ] unit-test
{ f } [ { T{ tile f 1 } f } can-move-left? ] unit-test
{ t } [ { T{ tile f 1 } f } reverse can-move-left? ] unit-test
{ t } [ { T{ tile f 1 } T{ tile f 1 } } can-move-left? ] unit-test
{ f } [ { T{ tile f 2 } T{ tile f 1 } } can-move-left? ] unit-test
{ f } [ { T{ tile f 2 } T{ tile f 1 } } reverse can-move-left? ] unit-test
{ f } [ { } can-move-left? ] unit-test
{ f } [ { f } can-move-left? ] unit-test
{ f } [ { f f } can-move-left? ] unit-test
{ f } [ { T{ tile f 1 } f f f } can-move-left? ] unit-test
{ t } [ { T{ tile f 1 } f f f } reverse can-move-left? ] unit-test
{ t } [ { f T{ tile f 1 } f f } can-move-left? ] unit-test
{ t } [ { f T{ tile f 1 } f f } reverse can-move-left? ] unit-test

! ]]

: test-boards ( -- seq )
    {
        [ 1 1 <board> ]
        [ 1 1 <board> { 1 } [ <tile> ] map >>tiles ]
        [ 1 1 <board> { 2 } [ <tile> ] map >>tiles ]
        [ 1 1 <board> { 3 } [ <tile> ] map >>tiles ]
        [ 1 1 <board> { 4 } [ <tile> ] map >>tiles ]
        [ 1 1 <board> { 5 } [ <tile> ] map >>tiles ]
        [ 1 1 <board> { 6 } [ <tile> ] map >>tiles ]
        [ 1 1 <board> { 7 } [ <tile> ] map >>tiles ]
        [ 1 1 <board> { 8 } [ <tile> ] map >>tiles ]
    } build
;

{ }
[ { "010100"
    "010101"
    "010102"
    "010103"
    "010104"
    "010105"
    "010106"
    "010107"
    "010108"
  }
  test-boards
  [ serialize ] map
  assert-sequence=
] unit-test

: assert-length ( seq length -- )
    [ length ] dip assert=
;

MEMO: all-boards ( n -- assoc )
    all-pairs [ dup [ '[ _ ] ] map concat call( -- w h ) <board> { } 2sequence ] map 
;

: all-valid-boards ( n -- assoc )
    all-pairs [ dup [ '[ _ ] ] map concat call( -- w h ) [ <board> { } 2sequence ] [ 4drop f ] recover ] map sift
;

: each-board ( ... n quot: ( ... key board -- ... ) -- ... )
    [ all-boards ] dip '[ _ [ 2drop "Error in %[%d, %]" printf nl rethrow ] recover ] assoc-each
; inline

: each-valid-board ( n -- assoc )
    [ all-valid-boards ] dip '[ _ [ [ drop "Error in %[%d, %]" printf nl ] dip rethrow ] recover ] assoc-each
; inline

{ } [ 100 all-valid-boards     clear ] unit-test
{ } [ 100 [ [ [ first ] [ second ] bi 2drop ] [ drop ] bi* ] each-valid-board clear ] unit-test
[ 100 all-boards ] must-fail
[ 100 [ 2drop ] each-board ] must-fail

{ } [
    4 all-pairs
    { { 0 0 } { 0 1 } { 0 2 } { 0 3 } { 0 4 }
      { 1 0 } { 1 1 } { 1 2 } { 1 3 } { 1 4 }
      { 2 0 } { 2 1 } { 2 2 } { 2 3 } { 2 4 }
      { 3 0 } { 3 1 } { 3 2 } { 3 3 } { 3 4 }
      { 4 0 } { 4 1 } { 4 2 } { 4 3 } { 4 4 }
    } set= t assert= ] unit-test

{ } [
    4 all-valid-boards 
    [ second serialize ] map
    { 
      "010100"       "01020000"             "0103000000"                   "010400000000"
      "02010000"     "020200000000"         "0203000000000000"             "02040000000000000000"
      "0301000000"   "0302000000000000"     "0303000000000000000000"       "0304000000000000000000000000"
      "040100000000" "04020000000000000000" "0403000000000000000000000000" "040400000000000000000000000000000000"
    } set= t assert= ] unit-test

! [[ dimensions

{ } [ 100 [ [ first   ] [ [   width>>                     ] [ columns>> length ] bi ] bi* [ assert= ] keep assert= ] each-valid-board ] unit-test
{ } [ 100 [ [ second  ] [ [               height>>        ] [ rows>>    length ] bi ] bi* [ assert= ] keep assert= ] each-valid-board ] unit-test
{ } [ 100 [ [ product ] [ [ [ width>> ] [ height>> ] bi * ] [ tiles>>   length ] bi ] bi* [ assert= ] keep assert= ] each-valid-board ] unit-test

! ]] 

! [[ logic

[ 0 0 <board> ] must-fail

{ } [ 4 4 <board> clear ] unit-test
{ } [ 4 4 <board> space-left? clear ] unit-test
{ } [ 4 4 <board> tiles>> empty-indices clear ] unit-test
{ } [ 4 4 <board> space-left? clear ] unit-test
{ { f } } [ 1 1 <board> tiles>> ] unit-test
{ { 0 } } [ { f } empty-indices ] unit-test
{ { } } [ { 1 } empty-indices ] unit-test
{ { 0 } } [ 1 1 <board> tiles>> empty-indices ] unit-test
{ } [ 4 4 <board> add-tile clear ] unit-test
{ } [ 4 [ [ product ] [ tiles>> empty-indices length ] bi* assert= ] each-valid-board ] unit-test
{ } [ 4 [ [ product ]     [ [ '[ _ add-tile ] times ] keep space-left? ] bi* f assert= ] each-valid-board ] unit-test
{ } [ 4 [ [ product 1 - ] [ [ '[ _ add-tile ] times ] keep space-left? ] bi* t assert= ] each-valid-board ] unit-test
! test if 1/10 of created tiles are a 4 instead of a 2

: about-equal ( value expected tolerance -- ? )
    [ / abs 1 - ] dip <=
;

{ t } [ 1000000 [ new-tile ] replicate [ [ level>> 2 = ] filter length ] [ length ] bi / 1/10 0.005 about-equal ] unit-test

{ {
    { T{ tile f 2 } T{ tile f 2 } }
    { T{ tile f 1 } T{ tile f 1 } }
  }
} [ "020202020101" deserialize rows>> ] unit-test
{ {
    { T{ tile f 2 } T{ tile f 1 } }
    { T{ tile f 2 } T{ tile f 1 } }
  }
} [ "020202020101" deserialize columns>> ] unit-test

{ } [ 2 2 <board> [ [ ] map ] change-rows clear ] unit-test
{ } [ 2 2 <board> [ [ ] map ] change-columns clear ] unit-test
{ } [ 2 2 <board> [ [ [ ] map ] map ] change-rows clear ] unit-test
{ } [ 2 2 <board> [ [ [ ] map ] map ] change-columns clear ] unit-test


{ "020201010101" } [ 2 2 <board> [ [ [ drop 1 <tile> ] map ] map ] change-rows serialize ] unit-test
{ "020202020202" } [ 2 2 <board> [ [ [ drop 2 <tile> ] map ] map ] change-columns serialize ] unit-test
{ "020201020102" } [ 2 2 <board> [ [ 0 [ drop 1 + ] accumulate* [ <tile> ] map ] map ] change-rows serialize ] unit-test
{ "020201010202" } [ 2 2 <board> [ [ 0 [ drop 1 + ] accumulate* [ <tile> ] map ] map ] change-columns serialize ] unit-test

{ "020202000200" } [ 2 2 <board> [ [ [ drop 1 <tile> ] map ] map ] change-rows [ left move ] keep serialize ] unit-test
{ "020203000300" } [ 2 2 <board> [ [ [ drop 2 <tile> ] map ] map ] change-columns [ left move ] keep serialize ] unit-test

{ "040102020000" } [ "040102000101" deserialize [ left move ] keep serialize ] unit-test
{ "040100000202" } [ "040102000101" deserialize [ right move ] keep serialize ] unit-test

{ f } [ "020201010101" deserialize lost? ] unit-test
{ t } [ "020201020201" deserialize lost? ] unit-test

{ } [ 11 <iota> [ '[ 1 1 <board> [ [ [ _ <tile> 0 ] dip set-nth ] keep ] change-tiles lost? ] call t assert= ] each ] unit-test
{ } [ 11 <iota> [ '[ 1 1 <board> [ [ [ _ <tile> 0 ] dip set-nth ] keep ] change-tiles won? ] call f assert= ] each ] unit-test
{ } [ 11 <iota> [ '[ 1 1 <board> [ [ [ _ 11 + <tile> 0 ] dip set-nth ] keep ] change-tiles lost? ] call f assert= ] each ] unit-test
{ } [ 11 <iota> [ '[ 1 1 <board> [ [ [ _ 11 + <tile> 0 ] dip set-nth ] keep ] change-tiles won? ] call t assert= ] each ] unit-test

! ]]
