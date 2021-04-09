+++
title = "Differential Geometry"
author = ["Prashant Tak"]
draft = false
creator = "Emacs 28.0.50 (Org mode 9.5 + ox-hugo)"
+++

## First Fundamental Form and Local Intrinsic Properties of a Surface {#first-fundamental-form-and-local-intrinsic-properties-of-a-surface}


### Introduction {#introduction}

-   The surfaces are defined similar to curves by an equation of the type F(_x,y,z_) = 0 or parametrically by expressing _x,y,z_ in terms of two parameters _u,v_ varying over a domain.
-   After defining the surface locally, its points are classified as ordinary or singular.
-   Then using tangent plane at a point and the surface normal at it, a coordinate system **\\((r\_1, r\_2, N)\\)** at every point of the surface is introduced.
-   After that, a certain quadratic differential form known as _first fundamental form_ on a surface and direction coefficients are introduced.


### Definition of a Surface {#definition-of-a-surface}

**Definition 1:** Locus of a point P(_x,y,z_) in \\(E\_{3}\\) satisfying some restrictions on _x,y,z_ which is expressed by a relation of the type F(_x,y,z_) = 0.

This equation is called the _implicit_ or the _constraint_ equation of the surface which allows for a global study of the surface.

**Definition 2:** For parameters _u, v_ taking real values and varying over a domain D, a surface is defined _parametrically_ as
  \\[
      x = f(u,v), y = g(u,v), z = h(u,v)
  \\]
  where _f, g_ and _h_ are single valued continuous functions possessing continuous derivatives of _r_-th order. Such surfaces are called surfaces of class _r_.

Parametric representation is useful for local study of surfaces i.e. in the neighbourhood of a point which is a small region **but** it is not unique for a surface. Also, the parameters _u_ and _v_ are called _curvilinear coordinates_.

**Definition 3:** For two parametric representations _u, v_ and _u', v'_ of the same surface, any transformation of the form \\(u'=\phi(u,v)\\) and \\(v'=\psi(u,v)\\) relating the two representations is called a _parametric transformation_.

**Definition 4:** A parametric transformation is _proper_ if:

1.  &phi; and &psi; are single valued functions.
2.  The Jacobian \\(\frac{\delta (\phi,\psi)}{\delta (u,v)}\neq0\\) in some domain D.

These conditions are necessary and sufficient for existence of inverse in the neighbourhood of any point in D' which is the domain of _u', v'_ corresponding to the domain D of the _u, v_ plane.


### Nature of Points on a Surface {#nature-of-points-on-a-surface}

**Notation:** For **r** being the position vector of a point on the surface, **r** = (x,y,z), we can take r = r(u,v) as the parametric form of the surface and use \\(r\_1 = \frac{\delta r}{\delta u} = (x\_{1},y\_{1},z\_{1})\\) and \\(r\_2 = \frac{\delta r}{\delta v} = (x\_{2},y\_{2},z\_{2})\\), similarly we can denote second order derivatives using \\(r\_{11}, r\_{21}\\) etc.

**Definition 1:** If \\(r\_{1}\times r\_{2}\neq0\\) at a point on a surface, then the point is called an _ordinary_ point. A point which is not an ordinary point is called a _singularity_.

Remarks:

-   Considering M = \\(\begin{bmatrix} x\_{1} & y\_{1} & z\_{1}\\\\\\
        x\_{2} & y\_{2} & z\_{2}\end{bmatrix}\\)
    For \\(r\_{1} \times r\_{2} \neq 0\\) at an ordinary point, i.e. rank of M is two at that point.
-   If the rank of M is either zero or one, the point on the surface is a singular point.
-   If \\(r\_{1} \times r\_{2}\neq0\\) or equivalently rank of M is two, then _x,y,z_ uniquely determine the parameters _u,v_ in the neighbourhood of an ordinary point.
-   When only one determinant minor of M is zero, one cannot conclude that the point is a singular point.
-   A _proper_ parametric transformation transforms an ordinary point into an ordinary point.
-   Due to geometrical nature of the surface, some singularities continue to be singularities, regardless of the parametric representations, these are called _essential singularities_.
-   There are other singularities depending on the choice of parametric representation which are called _artificial singularities_.

**Example:** Consider the circular cone represented by _x = u sin&alpha; cosv, y = u sin&alpha; sinv, z = u cos&alpha;_ where &alpha; is the semivertical angle of cone with O as origin and OP = _u_, where P is any point on the cone.
Computing M, then at _u_ = 0, the determinant of every second order minor is zero, hence it is an essential singularity.

**Example:** Taking any point 0 as origin in the plane, _x = u cosv, y = u sinv, z = 0_, we get \\(r\_{1} \times r\_{2} = u\textbf{k}\\). Hence it is zero only when _u_ = 0 i.e. it is an artificial singularity _since_ it arises due to the choice of the parametric coordinates and not due to the nature of the surface.


### Representation of a Surface {#representation-of-a-surface}

For our study of surfaces, we consider only ordinary points. And we consider the entire surface as a collection of parts, each part being given a particular parametrisation and the adjacent parts being related by a _proper_ parametric transformation.

**Definition 1:** A representation R of a surface S of class _r_ in \\(E\_{3}\\) is a collection of points in \\(E\_{3}\\) covered by a system of overlapping parts \\({S\_{j}}\\) where each part \\(S\_{j}\\) is given by a parametric equation of class _r_. Each point lying in the common portion of two parts \\(S\_{i}, S\_{j}\\) is such that the change of parameters from one part to is adjacent is given by a _proper_ parametric transformation of class _r_.

**_Note:_** Since one cannot parameterise the whole surface without introducing artificial singularities, one has to resort to a surface composed of many overlapping parts.

It is possible to have many representations of the same surface by considering different systems of overlapping parts (\\(S\_{j}\\)), each part is given by a parametric equation of class _r_.

**Definition 2:** For R and R' being two representations of class _r_ of the surface S, they are _equivalent_ if the composite family of parts {\\(S\_{j},S'\_{j}\\)} satisfies the condition that for each point P lying in the place of overlap, the change of parameter from \\(S\_{j}\\)  to \\(S'\_{j}\\) at P is given by a proper parametric transformation of class r.

**Theorem:** The notion of _r_-equivalence of representations of a surface is an equivalence relation.

This equivalence relation introduces a partition into the family of surfaces of class _r_ splitting them into mutually disjoint equivalence classes, each class containing the surface equivalent to one another in the above equivalence relation.

**Definition 3:** A surface S of class _r_ in \\(E\_{3}\\) is an _r_-equivalence class of representations.

Thus a surface consists of different overlapping portions related to one another by proper parametric transformations and all other surfaces related to the given one by the equivalence relation of class _r_.


### Curves on Surfaces {#curves-on-surfaces}

For a surface **r** = r(_u,v_), let _u = u(t)_ and _v = v(t)_ be a curve of class _s_ lying in the domain D of the _uv_-plane. Considering **r** = r[u(t), v(t)] which gives the position vector of a point in terms of a single parameter _t_ such that it is a curve lying on a surface with class equal to the smaller of _r_ and _s_. The equation _u = u(t)_ and _v = v(t)_ are called _curvilinear equations_ of the curve on the surface.

**Definition 1:** For **r**, a given surface of class _r_, let _v = c_, then position vector **r** = r(u,c) is a function of a single parameter _t_ and hence **r** = r(u,c) represents a curve lying on the surface **r** = r(u,v). This curve is called the _parametric curve_ v = constant.

By varying the values of _c_, a system of parametric curves _v_ = constant is generated and similarly another system is generated by keeping _u_ constant and varying _v_.

Properties that are a consequence of assuming only ordinary points on the surface:

1.  Through every point of the surface, there passes one and only one parametric curve of each system.
2.  No two curves of the same system intersect.
3.  The curves of the system \\(u=u\_{o}\\) and \\(v=v\_{o}\\) intersect once but not more than once if \\((u\_{o},v\_{o}) \in D\\).
4.  The parametric curves of the system u = \\(c\_{1}\\) and v = \\(c\_{2}\\) cannot touch each other.

**Definition 2:** Let u = \\(c\_{1}\\) and v = \\(c\_{2}\\), when the constants vary, the whole surface is covered with a net of parametric curves, two of which pass through each point.

**Definition 3:** Two parametric curves through a point P are _othogonal_ if \\(\textbf{r}\_{1}.\textbf{r}\_{2}= 0\\) at P.


### Tangent Plane and Surface Normal {#tangent-plane-and-surface-normal}

Let **r** = r[u(t), v(t)] be a general curve lying on the surface passing through [u(t), v(t)], then the tangent to the curve at any point P on the surface is
\\[
\frac{dr}{dt} = r\_{1}\frac{du}{dt}+r\_{2}\frac{dv}{dt}
\\]
**Definition 1:** Tagnent to any curve drawn on a surface is called a tangent line to the surface. The tangents to different curves through P on a surface lie in a plane containing two independent vectors \\(r\_{1}\\) and \\(r\_{2}\\) at P called the _tangent plane_ at P.

**Theorem 1:** The equation of a tangent plane at P on a surface with position vector **r** = r(u,v) is either \\(R = r+ar\_{1}+br\_{2}\\) or \\((R-r).(r\_{1}\times r\_{2}) = 0\\) where a and b are parameters.

**Definition 2:** The normal to the surface P is a line through P and perpendicular to the tangent plane at P.

**Theorem 2:** The equation of the normal **N** at a point P on the surface r = r(u,v) is \\(R=r+a(r\_{1}\times r\_{2})\\).

**Theorem 3:** A proper parametric transformation either leaves every normal unchanged or reverses the direction of the normal.


### General Surface of Revolution {#general-surface-of-revolution}

**Definiton 1:** A surface generated by the rotation of a plane curve about an axis in its plane is called a _surface of revolution_.

**Theorem 1:** The position vector of any point on the surface of revolution generated by the curve [g(u),o,f(u)] in the XOZ plane is
\\[
\textbf{r} = [g(u)cosv, g(u)sinv, f(u)]
\\]
where _v_ is the angle of roatation about the _z_-axis.
