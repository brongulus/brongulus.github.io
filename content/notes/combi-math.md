+++
title = "Combinatorial Mathematics"
author = ["Prashant Tak"]
draft = false
creator = "Emacs 27.2 (Org mode 9.5 + ox-hugo)"
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
8.  Distributions of _distinct objects_ are equivalent to **arrangements** and Distributions of _identical objects_ are equivalent to **selections**.
9.  Ways to arrange, select, distribute _r_ objects from _n_ items or into _n_ boxes:

    | Repition   | Arrangement                                           | Combination |
    |------------|-------------------------------------------------------|-------------|
    | No         | P(n,r)                                                | C(n,r)      |
    | Unlimited  | n^r                                                   | C(n+r-1, r) |
    | Restricted | P(n; r<sub>1</sub>, r<sub>2</sub>, .., r<sub>m</sub>) | -           |
10. Equations with integer-valued variables are called _diophantine_ equations.
11. Equivalent forms of selection with repetition:
    -   Number of ways to select _r_ objects with repetition from _n_ different types of objects.
    -   Number of ways to distribute _r_ identical objects into _n_ distinct boxes.
    -   Number of non-negative integer solutions to \\(x\_1 + x\_2 + ... + x\_n = r\\)
12. **Binomial Theorem**:
    \\[
                (1+x)^n = C(n,0) + C(n,1)x + C(n,2)x^2 + ... + C(n,k)x^k + C(n,n)x^n
             \\]
13. Committee Selection Model: Represent C(n,k) committees of _k_ people chosen from a set of _n_ people.
14. Block Walking Model: Using Pascal's triangle, label each street corner in the network with the pair (n,k) where _n_ is the number of blocks traversed from (0,0) and _k_ is the number of times the person chose the right branch at intersections.


## Generating Functions {#generating-functions}

1.  Assuming _a<sub>r</sub>_ denotes the _number of ways to select r objects_ in a certain procedure, g(x) is a generating function for a<sub>r</sub> if g(x) has the polynomial expansion:
    \\[
               g(x) = a\_0 + a\_1 x + a\_2 x^2 + ... + a\_r x^r + a\_n x^n
          \\]
2.  \\[
               \frac{1-x^{m+1}}{1-x} = 1+x+x^{2}+...+x^{m}
          \\]
3.  \\[
               \frac{1}{1-x} = 1+x+x^{2}+...
          \\]
4.  \\[
               (1+x)^n = 1 + {n \choose 1} x + {n \choose 2} x^2 + ... + {n \choose r} x^r + ... + {n \choose n} x^n
          \\]
5.  \\[
               (1-x^{m})^n = 1 - {n \choose 1} x^m + {n \choose 2} x^{2m} + ... + (-1)^k {n \choose k} x^{km} + ... + (-1)^r {n \choose n} x^{nm}
          \\]
6.  \\[
               \frac{1}{(1-x)^n} = 1 + {1+n-1 \choose 1} x + {2+n-1 \choose 2} x^2 + ... + {r+n-1 \choose r} x^r + ...
          \\]
7.  If h(x) = f(x)g(x) where \\(f(x) = a\_0 + a\_1 x + a\_2 x^2 + ...\\) and \\(g(x) = b\_0 + b\_1 x + b\_2 x^2 + ...\\) then:
    \\[
               h(x) = a\_{0}b\_{0}+(a\_{1}b\_{0}+a\_{0}b\_{1})x + ... + (a\_{r}b\_{0}+a\_{r-1}b\_{1}+a\_{r-2}b\_{2}+ ... +a\_{0}b\_{r}) x^r + ...
          \\]
8.  Partition
9.  Exp Gen Fn
10. Summation Method
