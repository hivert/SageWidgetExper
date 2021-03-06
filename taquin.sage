Tableaux.options.display="array"
Tableaux.options.convention="French"

class JeuDeTaquin(SageObject):
    def __init__(self, tab):
        r"""
        sage: t = SkewTableau([[None,2,3],[None,4],[5]])
        sage: jdt = JeuDeTaquin(t); jdt
          5
          .  4
          .  2  3
        sage: jdt.done(), jdt.has_hole()
        (False, False)

        sage: jdt.create_hole((0,0))
        Traceback (most recent call last):
        ...
        ValueError: corner must be an inner corner

        sage: jdt.create_hole((1,0))
        sage: jdt
          5
          *  4
          .  2  3
        sage: jdt.done(), jdt.has_hole()
        (False, True)
        sage: jdt.slide(); jdt
          5
          4
          .  2  3
        sage: jdt.done(), jdt.has_hole()
        (False, False)

        sage: jdt.slide()
        Traceback (most recent call last):
        ...
        ValueError: There is no hole

        sage: jdt.create_hole((0,0)); jdt
          5
          4
          *  2  3
        sage: jdt.done(), jdt.has_hole()
        (False, True)
        sage: jdt.slide(); jdt
          5
          4
          2  *  3
        sage: jdt.done(), jdt.has_hole()
        (False, True)

        sage: jdt.create_hole((0,1))
        Traceback (most recent call last):
        ...
        ValueError: There is already a hole at (0, 1)

        sage: jdt.slide(); jdt
          5
          4
          2  3
        sage: jdt.done(), jdt.has_hole()
        (True, False)

        sage: t = SkewTableau([[None,None,None,None,2,3,7,8],[None,None,4,9],[None,5,6],[10]])
        sage: jdt = JeuDeTaquin(t); jdt
         10
          .  5  6
          .  .  4  9
          .  .  .  .  2  3  7  8
        sage: jdt.create_hole((0, 3)); jdt
         10
          .  5  6
          .  .  4  9
          .  .  .  *  2  3  7  8
        sage: jdt.slide(); jdt
         10
          .  5  6
          .  .  4  9
          .  .  .  2  *  3  7  8
        sage: jdt.slide(); jdt
         10
          .  5  6
          .  .  4  9
          .  .  .  2  3  *  7  8
        sage: jdt.slide(); jdt
         10
          .  5  6
          .  .  4  9
          .  .  .  2  3  7  *  8
        sage: jdt.slide(); jdt
         10
          .  5  6
          .  .  4  9
          .  .  .  2  3  7  8
        sage: jdt.create_hole((1, 1)); jdt
         10
          .  5  6
          .  *  4  9
          .  .  .  2  3  7  8
        sage: jdt.slide(); jdt
         10
          .  5  6
          .  4  *  9
          .  .  .  2  3  7  8
        sage: jdt.slide(); jdt
         10
          .  5
          .  4  6  9
          .  .  .  2  3  7  8

        sage: jdt.create_hole((2, 0)); jdt
         10
          *  5
          .  4  6  9
          .  .  .  2  3  7  8
        sage: jdt.slide(); jdt
         10
          5
          .  4  6  9
          .  .  .  2  3  7  8

        sage: jdt.create_hole((0, 2)); jdt
         10
          5
          .  4  6  9
          .  .  *  2  3  7  8
        sage: jdt.slide(); jdt
         10
          5
          .  4  6  9
          .  .  2  *  3  7  8
        sage: jdt.slide(); jdt
         10
          5
          .  4  6  9
          .  .  2  3  *  7  8
        sage: jdt.slide(); jdt
         10
          5
          .  4  6  9
          .  .  2  3  7  *  8
        sage: jdt.slide(); jdt
         10
          5
          .  4  6  9
          .  .  2  3  7  8

        sage: jdt.create_hole((0, 1)); jdt
         10
          5
          .  4  6  9
          .  *  2  3  7  8
        sage: jdt.slide(); jdt
         10
          5
          .  4  6  9
          .  2  *  3  7  8
        sage: jdt.slide(); jdt
         10
          5
          .  4  6  9
          .  2  3  *  7  8
        sage: jdt.slide(); jdt
         10
          5
          .  4  6  9
          .  2  3  7  *  8
        sage: jdt.slide(); jdt
         10
          5
          .  4  6  9
          .  2  3  7  8

        sage: jdt.create_hole((1, 0)); jdt
         10
          5
          *  4  6  9
          .  2  3  7  8
        sage: jdt.slide(); jdt
         10
          5
          4  *  6  9
          .  2  3  7  8
        sage: jdt.slide(); jdt
         10
          5
          4  6  *  9
          .  2  3  7  8
        sage: jdt.slide(); jdt
         10
          5
          4  6  9
          .  2  3  7  8

        sage: jdt.create_hole((0, 0)); jdt
         10
          5
          4  6  9
          *  2  3  7  8
        sage: jdt.slide(); jdt
         10
          5
          4  6  9
          2  *  3  7  8
        sage: jdt.slide(); jdt
         10
          5
          4  6  9
          2  3  *  7  8
        sage: jdt.slide(); jdt
         10
          5
          4  6  9
          2  3  7  *  8
        sage: jdt.slide(); jdt
         10
          5
          4  6  9
          2  3  7  8
        """
        assert isinstance(tab, SkewTableau)
        self._tab = tab
        self._hole = None
        self._new_st = None

    def _repr_(self):
        if self._hole is None:
            lst = self._tab.to_list()
        else:
            lst = self._new_st
        none_str = lambda x: "  ." if x is None else "%3s"%str(x)
        if self._tab.parent().options('convention') == "French":
            new_rows = ["".join(map(none_str, row)) for row in reversed(lst)]
        else:
            new_rows = ["".join(map(none_str, row)) for row in lst]
        return '\n'.join(new_rows)

    def done(self):
        return self._hole is None and not self._tab.inner_shape()

    def has_hole(self):
        return self._hole is not None

    def create_hole(self, corner):
        if self._hole is not None:
            raise ValueError, "There is already a hole at %s"%(self._hole,)
        inner_corners = self._tab.inner_shape().corners()
        if tuple(corner) not in inner_corners:
            raise ValueError("corner must be an inner corner")
        self._hole = corner
        self._new_st = self._tab.to_list()
        spotl, spotc = self._hole
        self._new_st[spotl][spotc] = "*"

    def slide(self):
        if self._hole is None:
            raise ValueError, "There is no hole"
        spotl, spotc = self._hole
        #Check to see if there is nothing to the right
        if spotc == len(self._new_st[spotl]) - 1:
            #Swap the hole with the cell below
            self._new_st[spotl][spotc] = self._new_st[spotl+1][spotc]
            self._new_st[spotl+1][spotc] = "*"
            spotl += 1

        #Check to see if there is nothing below
        elif (spotl == len(self._new_st) - 1 or
              len(self._new_st[spotl+1]) <= spotc):
            #Swap the hole with the cell to the right
            self._new_st[spotl][spotc] = self._new_st[spotl][spotc+1]
            self._new_st[spotl][spotc+1] = "*"
            spotc += 1

        else:
        #If we get to this stage, we need to compare
            below = self._new_st[spotl+1][spotc]
            right = self._new_st[spotl][spotc+1]
            if below <= right:
                #Swap with the cell below
                self._new_st[spotl][spotc] = self._new_st[spotl+1][spotc]
                self._new_st[spotl+1][spotc] = "*"
                spotl += 1
            else:
                #Otherwise swap with the cell to the right
                self._new_st[spotl][spotc] = self._new_st[spotl][spotc+1]
                self._new_st[spotl][spotc+1] = "*"
                spotc += 1
        if (spotl, spotc) in self._tab.outer_shape().corners():
            self._new_st[spotl].pop()
            if not self._new_st[spotl]:
                self._new_st.pop()
            self._tab = SkewTableau(self._new_st)
            self._hole = None
            self._new_st = None
        else:
            self._hole = (spotl, spotc)


