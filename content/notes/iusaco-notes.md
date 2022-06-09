+++
title = "IUSACO"
author = ["Prashant Tak"]
date = 2022-06-05T00:00:00+05:30
lastmod = 2022-06-09T13:52:18+05:30
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
-   32bit int: \\(\pm 2\times10^{9}\\) v/s 64bit int: \\(\pm 9\times 10^{18}\\)


## Complexity and algorithm analysis {#complexity-and-algorithm-analysis}
