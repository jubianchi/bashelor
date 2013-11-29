#!/bin/bash

function getstdout() { cat $(stdout); }
function getstderr() { cat $(stderr); }
function getstatus() { cat $(rc); }