Useful functions:

As a "math" person, I am particularly fond of eigen(),
because finding eigenvalues and eigenvectors by hand is 
horribly tedious.

The function x11() opens up a new window for a plot,
which can be nice for viewing images that aren't quite
so crammed into the little viewing window on R studio.

sample() is useful for selecting data, especially if you are doing training/testing or want a simulation.

Is this what you meant, or did you mean something related to data wrangling?

If that's the case, then I'd have to say something like filter() is nice because you can select (or by extension, remove) entries. mutate was useful in this week's case study because the join needed the column names to match (I couldn't make it work otherwise). select() is nice because you can get rid of columns you don't need.

The directions could be more specific.