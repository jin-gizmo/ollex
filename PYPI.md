# Ollex (Open LLM Experimental Workbench)

> **Ollex** was developed at [Origin Energy](https://www.originenergy.com.au) as part of the
> *Jindabyne* initiative. While not part of our core IP, it proved valuable
> internally, and we're sharing it in the hope it's useful to others.
> 
> Kudos to Origin for fostering a culture that empowers its people
> to build complex technology solutions in-house.
>
> See more tools at [Jin Gizmo on GitHub](https://jin-gizmo.github.io).

## Overview

**Ollex** is a little desktop experiment built to get a bit of hands-on
experience fiddling with this AI caper. It's a very basic, naive implementation
but I knew nothing at the time. The uncharitable amongst you will suggest that
situation hasn't changed. So it goes.

Anyhow, the use case was simple ...

> Given a reasonable sized source document, load it up so we can ask
> questions about its contents. 

Turned out to be more fiddly than expected. The final result was a couple of
simple CLI tools:

*   **olx-db**:  This creates / extends a ChromaDB vector database with
    embeddings from one or more Markdown formatted documents.

*   **olx-query**: A simple tool to run queries using one or more LLM models against
    a ChromaDB database that has been created using **olx-db**. This can be run,
    either in batch mode, or as an iterative REPL.

The intent behind the **olx-query** tool is this ... given:

*   `n` different embeddings of a given source document
*   `m` LLM models
*   `p` system prompts

... process queries against the `n * m * p` possible combinations of these to
see how each performs.

> TL;DR Every one of them is a lottery.

## Installation and Usage

See [Ollex on GitHub](https://github.com/jin-gizmo/ollex).
