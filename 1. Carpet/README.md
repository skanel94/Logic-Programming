For facts:
rewrite('X', [['X','X','X'],['X',' ','X'],['X','X','X']]).
rewrite(' ', [[' ',' ',' '],[' ',' ',' '],[' ',' ',' ']]).

Some running examples are:

?- carpet(1).
XXX
X X
XXX

?- carpet(2).
XXXXXXXXX
X XX XX X
XXXXXXXXX
XXX   XXX
X X   X X
XXX   XXX
XXXXXXXXX
X XX XX X
XXXXXXXXX

?- carpet(3).
XXXXXXXXXXXXXXXXXXXXXXXXXXX
X XX XX XX XX XX XX XX XX X
XXXXXXXXXXXXXXXXXXXXXXXXXXX
XXX   XXXXXX   XXXXXX   XXX
X X   X XX X   X XX X   X X
XXX   XXXXXX   XXXXXX   XXX
XXXXXXXXXXXXXXXXXXXXXXXXXXX
X XX XX XX XX XX XX XX XX X
XXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXX         XXXXXXXXX
X XX XX X         X XX XX X
XXXXXXXXX         XXXXXXXXX
XXX   XXX         XXX   XXX
X X   X X         X X   X X
XXX   XXX         XXX   XXX
XXXXXXXXX         XXXXXXXXX
X XX XX X         X XX XX X
XXXXXXXXX         XXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXX
X XX XX XX XX XX XX XX XX X
XXXXXXXXXXXXXXXXXXXXXXXXXXX
XXX   XXXXXX   XXXXXX   XXX
X X   X XX X   X XX X   X X
XXX   XXXXXX   XXXXXX   XXX
XXXXXXXXXXXXXXXXXXXXXXXXXXX
X XX XX XX XX XX XX XX XX X
XXXXXXXXXXXXXXXXXXXXXXXXXXX

For facts:
rewrite('J', [['J','J','J','J','J'],[' ',' ','J',' ',' '],
[' ',' ','J',' ',' '],['J',' ','J',' ',' '],
['J','J','J',' ',' ']]).
rewrite(' ', [[' ',' ',' ',' ',' '],[' ',' ',' ',' ',' '],
[' ',' ',' ',' ',' '],[' ',' ',' ',' ',' '],
[' ',' ',' ',' ',' ']]).

Some running examples are:

?- carpet(2).
JJJJJJJJJJJJJJJJJJJJJJJJJ
  J    J    J    J    J
  J    J    J    J    J
J J  J J  J J  J J  J J
JJJ  JJJ  JJJ  JJJ  JJJ
          JJJJJ
            J
            J
          J J
          JJJ
          JJJJJ
            J
            J
          J J
          JJJ
    JJJJJ JJJJJ
      J     J
      J     J
    J J   J J
    JJJ   JJJ
JJJJJJJJJJJJJJJ
  J    J    J
  J    J    J
J J  J J  J J
JJJ  JJJ  JJJ
