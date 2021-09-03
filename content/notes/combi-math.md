+++
title = "Combinatorial Mathematics"
author = ["Prashant Tak"]
draft = false
creator = "Emacs 27.1 (Org mode 9.5 + ox-hugo)"
+++

## General Counting Methods for Selection and Arrangement {#general-counting-methods-for-selection-and-arrangement}

1.  Addition Principle:
    If there are \\(r\_1\\) different objects in the first set, \\(r\_2\\) different objects in the second set, . . . , and \\(r\_m\\) different objects in the m^th set, and if the different sets are disjoint, then the number of ways to select an object from one of the m sets is \\(r\_1 +r\_2 + · · · +r\_m\\).
2.  Multiplication Principle:
    Suppose a procedure can be broken into m successive (ordered) stages, with \\(r\_1\\) different outcomes in the first stage, \\(r\_2\\) different outcomes in the second stage,. . . ,and \\(r\_m\\) different outcomes in the mth stage. If the number of outcomes at each stage is independent of the choices in previous stages and if the composite outcomes are all distinct, then the total procedure has \\(r\_{1} ×r\_{2} × · · · ×r\_{m}\\) different composite outcomes.
3.  Remember that the addition principle requires disjoint sets of objects and the multiplication principle requires that the procedure break into ordered stages and that the composite outcomes be distinct.
4.  A permutation of n distinct objects is an arrangement, or ordering, of the n objects. An r-permutation of n distinct objects is an arrangement using r of the n objects.
5.  An r-combination of n distinct objects is an unordered selection, or subset, of r out of the n objects.
6.  **Theorem 1:** If there are n objects, with \\(r\_1\\) of type 1, \\(r\_2\\) of type 2, . . . , and \\(r\_m\\) of type m, where \\(r\_1 +r\_2 + · · · +r\_m = n\\), then the number of arrangements of these n objects, denoted \\(P(n; r\_{1}, r\_{2}, . . . , r\_{m})\\), is
    \\[
               P(n;r\_{1},r\_{2}, . . . ,r\_{m}) = \frac{n!}{r\_{1}!r\_{2}! . . .r\_{m}!}
          \\]
7.  **Theorem 2:** The number of selections with repetition of r objects chosen from n types of objects is C(r + n − 1,r).
