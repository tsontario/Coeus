![Build](https://github.com/tsontario/coeus/workflows/Ruby/badge.svg)

# Coeus

Coeus is a Computation Tree Logic (CTL) model checker. In particular, it supports workflows to:

- Define state machine models
- Parse CTL expression strings
- Evaluate CTL expressions against a model

# Architecture

Coeus is comprised of 3 key components, the Model, CTL expression parser, and the Labelling algorithm

## Model

Strictly speaking, a CTL Model is defined as a set of states, transitions between those states, and a labelling function L. In Coeus, only the states and transitions are contained in the Model class: labelling is implemented in isolation. Models can be loaded into Coeus via YAML documents. You can find examples of the schema in `spec/fixtures`.

## CTL Expression Parser

The goal of the CTL Expression Parser is to convert string input of CTL expressions into a parse tree to be used subsequently by the labelling algorithm. It consists of 2 main parts: A lexer/tokenizer and parser, which are implemented with the [Rly](https://github.com/farcaller/rly) gem. The parser supports all CTL operators, though internally these are converted into a smaller adequate set.
