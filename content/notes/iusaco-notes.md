+++
title = "IUSACO"
author = ["Prashant Tak"]
draft = false
creator = "Emacs 28.1 (Org mode 9.6 + ox-hugo)"
+++

## Elementary techniques - Input and Output {#elementary-techniques-input-and-output}

```c++
#include <cstdio>
using namespace std;
int main() {
    freopen("template.in", "r", stdin);
    freopen("template.out", "w", stdout);
}
```

-   When using C++, arrays should be declared globally, or initialized to zeros if declared locally to avoid garbage values.
-   32bit int: \\(\pm 2\times10^{9}\\) v/s 64bit int: \\(\pm 9\times10^{18}\\)


## Complexity and algorithm analysis {#complexity-and-algorithm-analysis}
