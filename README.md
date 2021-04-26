![Build](https://github.com/tsontario/coeus/workflows/Ruby/badge.svg)

# Coeus

Coeus is a Computation Tree Logic (CTL) model checker. In particular, it supports workflows to:

- Define state machine models
- Parse CTL expression strings
- Evaluate CTL expressions against a model

# Quickstart

Note: you need to have Ruby installed for this application. Run `bundle install` in the application directory to load all dependencies.

Coeus provides a small commandline utility that can be invoked by `bin/coeus` (use `-h` flag for help).
Example:

```bash
bin/coeus -f input/model.yaml -o output_graph_path "a OR E[TRUE U (NOT b OR c)]"
```

There are a number of model YAML files in `example` as well as `spec/fixtures` if you want to play around with them.

## Expression Syntax

The CTL expression passed into Coeus is defined in `lib/coeus/language/lex.rb`. Atomic predicates can be any lowercase alphanumeric string (must begin with a letter). Some example expressions are:

- `a OR b`
- `EU [TRUE U NOT c1] AND (c -> d)`
- `NOT FALSE and EX (a AND b AND c)`

# Architecture

Coeus is comprised of 3 key components, the Model, CTL expression parser, and the Labelling algorithm

## Model

Strictly speaking, a CTL Model is defined as a set of states, transitions between those states, and a labelling function L. In Coeus, only the states and transitions are contained in the Model class: labelling is implemented in isolation. Models can be loaded into Coeus via YAML documents. You can find examples of the schema in `spec/fixtures`.

## CTL Expression Parser

The goal of the CTL Expression Parser is to convert string input of CTL expressions into a parse tree to be used subsequently by the labelling algorithm. It consists of 2 main parts: A lexer/tokenizer and parser, which are implemented with the [Rly](https://github.com/farcaller/rly) gem. The parser supports all CTL operators, though internally these are converted into a smaller adequate set.
