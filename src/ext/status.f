\ status.f      - x4 displays status in top line
\ ------------------------------------------------------------------------

  .( loading status.f ) [cr]

\ ------------------------------------------------------------------------

  forth definitions

\ ------------------------------------------------------------------------

  <headers

  false var status          \ status is off/on ?

\ ------------------------------------------------------------------------
\ turn status line on - set scroll region below status line

  headers>

: staton        ( --- )
  on> status                \ we are displaying status info now
  sc 1 rows 1- csr          \ set scroll region
  rc ;

\ ------------------------------------------------------------------------
\ turn status line off - scroll through status line is ok now

: statoff       ( --- )
  off> status               \ status not being displayed
  sc 0 rows 1- csr          \ set scroll region
  rc ;

\ ------------------------------------------------------------------------
\ display free list space, display free head space

: .lfree        ( --- )  head0 here  - ?' base >r hex 7 .r r> radix ;
: .hfree        ( --- )  thead hhere - ?' base >r hex 7 .r r> radix ;

\ ------------------------------------------------------------------------

  <headers

  create statline
   ,"  List        Head        Depth      Base   "

\ ------------------------------------------------------------------------
\ vanity plates

: ?.mimiv
  cols #out -
  dup 7 >
  if
    7 - spaces
    cyan >fg ." MIMIV "
  else
    1- spaces
  then ;

\ ------------------------------------------------------------------------
\ display status line in row 1

: (.status)
  status 0=                 \ do not show status bar if status is disabled
  floads 0<> or ?exit       \ or if we are floading

  sc #out >r #line >r
  attrib  >r base >r

  0 >pref
  ltwhite gray >color >attrib
  0 0 at

  decimal curoff
  statline count type

  ltgreen >fg >bold

  5  hpa .lfree             \ free code space
  17 hpa .hfree             \ free head space

  31 hpa depth 4 .r         \ current parameter stack depth

  41 hpa r@ 2 .r space      \ base

  yellow >fg .date          \ show date time

  ?.mimiv                   \ credits

  curon
  r> radix
  r> dup $ff and >attrib
  8 >> >pref
  r> !> #line
  r> !> #out
  rc ;

\ ------------------------------------------------------------------------


 ' (.status)
 is .status

\ ------------------------------------------------------------------------

 <headers

: instat        ( --- ) defers default in-tty not ?exit staton ;
: outstat       ( --- ) defers atexit status 0= ?exit statoff ;

\ ------------------------------------------------------------------------

  behead

\ ========================================================================
