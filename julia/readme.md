<h1 align="center">
Scripts for Julia
</h1>


## Description
In my degree, we use [R](https://www.wikiwand.com/en/R_(programming_language)) a lot.  I have heard of [Julia](https://www.wikiwand.com/en/Julia_(programming_language)) since beginning with R and [Python](https://www.wikiwand.com/en/Python_(programming_language)), and think it is a good idea to play around with, considering a [course](https://www.victoria.ac.nz/courses/math/245/2020/offering?crn=7528) I am doing next year, and a [course I am just completing](https://www.victoria.ac.nz/courses/math/251/2019/offering?crn=18325) (22.10.2019).  Julia and Python alike have actually helped me in [a](https://www.wgtn.ac.nz/courses/math/353/2020) [few](https://www.wgtn.ac.nz/courses/math/244/2020) [other](https://www.wgtn.ac.nz/courses/math/324/2020) [courses](https://www.wgtn.ac.nz/courses/math/335/2020) as well.

I started using Julia in late September, 2019.

## Setting up Virtual Environment

The following is the method used to set up a virtual environment:

```
$ mkdir 'myvenv-directory'
$ cd 'myvenv-directory'
$ julia
julia> ]
(@v1.4) pkg> activate .
(myvenv-directory) pkg> add <all the packages you need in your virtual environment>
```

## Telling Julia Scripts to use their Virtual Environment

At the beginning of each Julia script, I have the following "shebang" to tell the script to

 a) use bash to execute Julia to execute the script; and
 b) to stop the script at user input (i.e., ^C)

```
#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/<dirname>/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
```

It should be noted that, due to this shebang, `github-linguist` believes this script is a shell script.  You can ensure that this is avoided by adding the following line to a `.gitattributes` file:

```
*.jl linguist-language=Julia
```

## Using PkgTemplates.jl to generate a project with `master` branch

Since GitHub has changed their preference of the primary branch to be called `main`, so too has PkgTemplates.jl.  For those old souls such as myself, I wanted it to be called `master`.  It took some digging, but it appears you can generate a template with git specifications:
```julia
julia> using PkgTemplates
julia> t = Template(; plugins = [Git(; branch = "master")]);
julia> t("PackageName")
```