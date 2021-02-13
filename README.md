# Julia Client Binary in Nim

Julia is a great language, however is not easy to use it for scripts because due
to its JIT compiler it takes time to run it. The main percentage of that time is
invested to the fact that any used package is compiled every time it is run,
this is called the time-to-first-plot, making in practice scripts in Julia
slower than in other language like Python.

This problem is solved with my
[DaemonMode.jl](https://github.com/dmolina/DaemonMode.jl) package, inspired in
the daemon mode of other software, like Emacs. Using this package you can run a
process running in Julia, juliaserver:

```sh
#!/usr/bin/env bash
julia -e 'using DaemonMode; serve()' &
```

and another one `jclient_client` that send the filename to be run to the previous
file:

```sh
#!/usr/bin/env bash
julia -e 'using DaemonMode; runargs()' $*
```

For instance, with a script that load packages CSV and DataFrame:

```sh
$ time jclient_julia test.jl 7days.csv 
...
real	0m1.389s
user	0m0.489s
sys	    0m0.333s
```

While using jclient_julia it takes only (with juliaserver loaded):

```sh
$ time jclient_julia test.jl 7days.csv 
...
real	0m0.443s
user	0m0.511s
sys	    0m0.292s
```

The half of second is due to running the julia interpreter. 

This software compile to a binary-version of julia client, using [Nim
language](https://nim-lang.org/). In that way, the time is greatly reduced:

```sh
$ time jclient test.jl 7days.csv
...
real	0m0.019s
user	0m0.004s
sys	    0m0.007s
```

