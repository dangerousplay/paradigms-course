#!/bin/bash

X=0

function fie() {
    echo "$X"
}

function bar() {
    X=2
}

function foo() {
    X=1

    fie
    bar
    fie
}

foo
