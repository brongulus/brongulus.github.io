+++
title = "IUSACO"
author = ["Prashant Tak"]
date = 2022-06-05T00:00:00+05:30
lastmod = 2022-06-28T11:54:57+05:30
draft = false
creator = "Emacs 28.1 (Org mode 9.6 + ox-hugo)"
+++

## Input and Output {#input-and-output}

```cpp
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

-   Elementary mathematical calculation: O(1)
-   Unordered set/map: O(1) per operation
-   Binary Search: O(log n)
-   Ordered set/map or Priority Queue: O(log n) per operation
-   Prime factorization or primality check for int: \\(O(\sqrt{n})\\)
-   Reading n inputs: O(n)
-   Iterating through n element array: O(n)
-   Sorting: Usually O(n log n) for `std::sort()`
-   Iterating through all subsets of size k of input elements: O(\\(n^{k}\\) ), for triplets O(\\(n^{3}\\))
-   Iterating through all subsets: O(\\(2^{n}\\))
-   Iterating through all permutations: O(n!)


## Built-in Data Structures {#built-in-data-structures}

Data Structure determines how data is stored, each supports some operations efficiently. In following discussion, desired data type is put between `<>`. Most std structures support `size()` and `empty()` methods.


### Iterators {#iterators}

Allows for traversal of a container with the help of a pointer.

```cpp
  for (vector<int>::iterator it = myvector.begin(); it != myvector.end(); ++it) {
    cout << *it; //prints the values in the vector using the pointer
  }
```

Alternate way to achieve the same with a for-each loop and `auto`.

```cpp
  for(auto element : v){
    cout << element; // prints values in vector
  }
```


### Dynamic Arrays {#dynamic-arrays}

Addition and deletion at the end in O(1) time and in the middle in O(n) time.

```cpp
  vector<int> v;
  for(int i = 1; i <= 10; i++){
    v.push_back(i); // stores 1 to 10 in a dynamic array
  }
```

Vectors can be made static sized by initializing it with a size, `vector<int> v(30);`. They also support an `v.erase()` operation. A dynamic array can be sorted (default ascending) by `sort(v.begin(), v.end())`.


### Stacks and Queues {#stacks-and-queues}

**Stacks**: LIFO with operations `push` (add at end), `pop` (remove at end) and `top` (show end) all of which are O(1). Declared as `stack<int> s`.

**Queues**: FIFO with operations `push` (add in front), `pop` (remove at end) and `front` (show end) in O(1).

**Deques**: Combination of a stack and a queue supporting insertion and deletion from both front and end. Operations are aptly named as `push_back`, `push_font`, `pop_back` and `pop_front`.

**Priority Queues**: Supports insertion of elements and deletion and retrieval of element _with highest priority_ in O(log n) where priority is based on a comparator function (highest element in front). Has `push` (add at end), `pop` (remove at end) and `top` (show end) operations and is declared as `priority_queue<int> pq;`.


### Sets {#sets}

A _set_ is a collection of objects having no duplicates.

**Unordered Sets**: Work by hashing that is, assigning a unique code to every object allowing for `insert`, `erase` and `count` (set contains element then 1 else 0) in O(1). Traversal is pointless. Declared as `unordered_set<int> s`.

```cpp
  for(int element : s){
    cout << element << " "; // iterating through a set, arbitrary order
  }
```

**Ordered Sets**: Insertion, deletion and search needs O(log n) time. Has additional operations `begin()` (iterator to lowest element), `end()`, `lower_bound()` (iterator to least element &ge; some k) and `upper_bound()`.

**Multisets**: A sorted set allowing multiple copies of same element, whose `count` operation returns the number of times an element is present in set. Time complexity of this operation is O(log n + f) where _log n_ factor searches for element and _f_ factor iterates through sorted set to get count. Declared as `multiset<int> ms`.


### Maps {#maps}

A _map_ is a set of _ordered pairs_ called key and value where keys must be unique but values can be repeated. Supported operations are addition and removal of key-value pair and _retrieval_ of values for a given key. Unordered maps perform aforementioned methods in O(1) whereas for ordered maps it's O(log n), sorted in order of key.

**Unordered Maps**: In map `m`, `m[key] = value` operator assigns value to a key and places the pair on the map, `m[key]` returns value associated with the key, `count(key)` checks for existence of key in the map and `erase(it)` removes pair associated with a key or iterator. Declared as `unordered_map<int, int> m`.

**Ordered Maps**: Supports additional operations `lower_bound` and `upper_bound` which return iterators pointing to lowest entry not less than/ strictly greater than a specified key.

```cpp
  map<int, int> m; // [(3,5); (11,4)]
  m[10] = 491; // [(3,5); (10,491); (11,4)]
  cout << m.lower_bound(10)->first << " " << m.lower_bound(10)->second << "\n";
  // 10 491
  cout << m.upper_bound(10)->first << " " << m.upper_bound(10)->second << "\n";
  // 11 4
  m.erase(11); // [(3,5); (10,491)]
```


## Simulation {#simulation}
