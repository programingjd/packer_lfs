#!/bin/bash

strip --strip-debug /tools/lib/*
rm -rf /tools/{,share}/{info,man,doc}
