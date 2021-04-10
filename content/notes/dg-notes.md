+++
title = "Differential Geometry"
author = ["Prashant Tak"]
draft = false
creator = "Emacs 28.0.50 (Org mode 9.5 + ox-hugo)"
+++

## Theory of Space Curves {#theory-of-space-curves}


### Representation of space curves {#representation-of-space-curves}

-   Level Curve: f(x,y,z) = C
-   From level curves to parametrized curves:
    \\(y=x^{2} <-----> \gamma(t)=(\gamma\_{1}(t),\gamma\_{2}(t))\\) Taking \\(\gamma\_{1}(t)=t\\), we get \\(\gamma\_{2}(t)=t^{2}\\) hence the parametrization is \\(\gamma(t)=(t,t^{2})\\)
-   **NOTE:** Check if domain of _x_ satisfies domain of _t_ or not. That is, the same parametrisation can be represented as \\((t^{2}.t^{4})\\) or \\((t^{3},t^{6})\\) but only the latter is a correct representation.
-   From parametrized curves to level curves:
    \\(\gamma(t)=(cos^{3}t,sin^{3}t)\\) <------> F(x,y)=C; Using \\(sin^{2}t+cos^{2}t=1\\) we get, \\(x^{2/3}+y^{2/3}=1\\) as the level curve.


### Unique Parametric representation {#unique-parametric-representation}

-   Class 'm' &rarr; _f_ is m-differentiable
-   A curve is _smooth_ if \\(\frac{d^{n}f}{dt^{n}}\\) exists for all n &ge; 1 and t &isin; (&alpha;,&beta;)
-   A function _f_ is _analytic_ if it is single valued and of class &infin;
-   A function is _regular_ if it is differentiable and derivative is non-zero (f dot &ne; 0)
-   A _regular f_ of class _m_ can also be called a _**path**_ of class _m_.
-   **NOTE:** A point of a parametrized curve can have multiple tangents.


### Arc-length {#arc-length}

-   Arc-length of a curve &gamma; is given by the function \\(s(t)=\int\_{t\_{0}}^{t}|| \dot{\gamma}(u)|| du\\)
-   Speed: \\(|| \dot{\gamma}(t) ||\_{t}\\) and a curve is unit-speed curve if its magnitude is 1 for all _t_.
-   For &gamma; being a unit speed curve, \\(\ddot{\gamma}\\) is zero or perpendicular to \\(\dot{\gamma}\\) i.e. \\(\ddot{\gamma}.\dot{\gamma}=0\\)
-   If &gamma; is a regular curve, then its arclength S at any point of &gamma; is a smooth function of t.
-   Reparametrization: \\(\overline{\gamma}:(\overline{\alpha},\overline{\beta}) \rightarrow R^{n}\\) <=> \\(\gamma: (\alpha,\beta) \rightarrow R^{n}\\)  exists iff &exist; a smooth function &phi;: \\((\overline{\alpha},\overline{\beta}) \rightarrow (\alpha,\beta)\\) such that its inverse &phi;<sup>-1</sup> is also smooth.
-   A _unit speed reparametrization_ exists for a curve iff it is _regular_.


### Tangent and Osculating Plane {#tangent-and-osculating-plane}

-   Assuming &gamma; is a class &ge; 1 i.e. it has a power series expansion,

\\[ \gamma(u)=\gamma(u\_{0}+h)=\gamma(u\_{0})+\frac{h}{1!}\dot{\gamma}(u\_{0})+\frac{h^{2}}{2!}\ddot{\gamma}(u\_{0})+ ... + \frac{h^{n}}{n!}\gamma^{n}(u\_{0})+O(h^{n})
\\]
  where \\(h = u-u\_0\\)

-   Let &gamma; be class m &ge; 2 and (P,Q) be points limiting position of a plane that contains tangential line at P and passes through Q as Q &rarr; P is defined as the _osculating plane_.
-   **Tangent line:** \\(\vec{R}(t)=\vec{r}(u\_{0})+t \vec{r'}(u\_{0})\\) at \\(u\_{0}\\)
-   **Osculating Plane:** \\([\vec{R}-\vec{r(0)}, \vec{r'(0)}, \vec{r''(0)}]=0\\) where \\(\vec{R}=(X,Y,Z)\\) gives the equation of the OP. The product inside the box is _scalar triple product_. Also, the OP passes through the unit vector of the curve and is perpendicular to the unit binormal vector.
-   Note that for smallest k &ge; 2 such that \\(\vec{r^{(k)}}=0\\), the last term in the box is replaced by \\(\vec{r^{(k)}(0)}\\)


### Principal normal and binormal {#principal-normal-and-binormal}

-   **Normal Plane:** \\(\vec{t}(0) \dot (\vec{R}-\vec{r}(0)) = 0\\)
    It is perpendicular to the tangent line and is spanned by _n,b_
-   **Principal Normal Vector:** For m &ge; 1, \\(\vec{n}=\frac{\vec{r''}(0)}{||\vec{r''}(0)||}\\)
-   **Unit Binormal Vector:** \\(\vec{b}=\vec{t}\times\vec{n}\\)


### Curvature and Torsion {#curvature-and-torsion}

-   For a _unit speed curve_ or _arc length parametrized_ curve &gamma;(t), the curvature &kappa;(t) is defined as \\(||\ddot{\gamma}(t)||\\) (1)
-   For a _regular_ curve &gamma;(t) **in** \\(R^{3}\\), \\(\kappa = \frac{||\ddot{\gamma}\times\dot{\gamma}||}{||\dot{\gamma}^{3}||}\\)
-   For a unit speed curve &gamma;, _unit tangent vector_ \\(\hat{t}=\dot{\gamma}\\) and for &kappa; &ne; 0, _unit normal vector_ is given by  \\(\hat{n}(s)=\frac{\dot{\hat{\gamma}}(s)}{\kappa(s)}\\) since (1). And _unit binormal vector_ can be given by \\(\hat{b}=\hat{t}\times\hat{n}\\)
-   **Orthonormal Basis** of a curve is given by {\\(\hat{t},\hat{n},\hat{b}\\)}
-   Now b is given by t &times; n , hence \\(\dot{b}=\dot{t}\times n+t\times\dot{n}\\) , since \\(\dot{b}\\) has to be perpendicular to t and b, \\(\implies \ddot{b}||n\\), therefore \\(\boxed{\dot{b}=-\tau n}\\) **iff** &kappa; &ne; 0.
-   For a regular curve &gamma; in \\(R^{3}\\) with &kappa; &ne; 0, the _torsion_ is given by
    \\[
        \tau = \frac{(\dot{\gamma}\times\ddot{\gamma}).\dddot{\gamma}}{||\dot{\gamma}\times\ddot{\gamma}||^{2}}
        \\]
-   Also, _radius of curvature_ &rho; is inverse of curvature.
-   Finally, tying it all together is the _Serret-Frenet formula_:
    \\(\begin{bmatrix} \dot{t} \\\\\\
         \dot{n} \\\\\\
         \dot{b}  \end{bmatrix} = \begin{bmatrix} 0 & \kappa & 0 \\\\\\
          -\kappa & 0 & \tau \\\\\\
          0 & -\tau & 0 \end{bmatrix} \begin{bmatrix} t \\\\\\
          n \\\\\\
          b \end{bmatrix}\\)


### Behaviour of a curve near one of its points {#behaviour-of-a-curve-near-one-of-its-points}


### Contact between curves and surface {#contact-between-curves-and-surface}


### Osculating circle and osculating sphere {#osculating-circle-and-osculating-sphere}


### Locus of centres of spherical curvature {#locus-of-centres-of-spherical-curvature}


### Tangent surfaces, involutes and evolutes {#tangent-surfaces-involutes-and-evolutes}


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