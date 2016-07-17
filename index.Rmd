---
title       : Next Word Prediction Demo
subtitle    : Introduction to the product and access to beta version
author      : Francesca Iannuzzi
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [shiny]            # {mathjax, quiz, bootstrap}
mode        : selfcontained  # {selfcontained, draft}
knit        : slidify::knit2slides
---

## Next-Word Prediction

The idea is to guess the next word of a sentence (as in smartphones' messaging apps)

The starting point is a **Language Model** - typically a set of words and expressions with associated probabilities based on the number of their occurrence in an input corpus.

These expressions are called **n-grams**: for example, *Alice-saw-the* and *saw-the-rabbit* are the two 3-grams that can be extracted from the sentence "Alice saw the rabbit"

The higher *n*, the more sophisticated the language model (if it is based on enough data)

Such an n-gram model predicts what word is likely to follow n-1 words given in input. Following the example above, a 3-gram model is likely to predict *the* to be the word following "Alice saw"

In what follows I will show a self-made prototype of a next-word predictor

--- .class #id 

## My Model

The current version employs a **3-gram** model 

The input corpus consists of **75 000** English text units, evenly divided into tweets, blog posts and news articles

This results into: **1,6 M trigrams**, **820 k bigrams**, **76 k unigrams** (after removing units consisting of less than 2 words and n-grams containing non-English or repeated characters)

Building the model took **105 s** and **1.6 Gb** of memory on an *c4.4xlarge* AWS instance running Ubuntu

The result is a set of 3-grams and 2-grams Maximum Likelihood Estimates (say "probabilities") 

The 2-grams are useful in case a prediction based on the 3-grams is not possible - typically when the n-1 (2, in this case) words given as input by the user are unknown to the model; in these cases I consider the last typed word only and look for a prediction in the 2-gram model. This way of dealing with unseen combinations of words is referred to as **stupid backoff**

--- 

## My Model: how good is it?

A first approach at evaluating the quality of the language model is to compute its *Perplexity*

This is a measure of the probability of an unseen test set, normalised by the number of words this consists of. Ideally you would want a model that assigns a high probability to the n-grams extracted from the test set, or in other words a model with a *low perplexity*

On an unseen test set of *20 000* units the 3-gram model shows a **perplexity of 25** on the known 3-grams (70% of the total)

The result is encouraging, given the reference value of 247 for the 3-gram model evaluated on the Brown Corpus (1992)

However, it does not take into account 30% of the test-set 3-grams (those which are unknown to the model)

--- 

## My Model: how can I improve it?

Given the little wallclock time needed for training this model, the use of considerably **larger corpora** is feasible immediately (I kept the model small to avoid overcharging the Shiny Demo). Some actions to limit the **memory use** may be desirable

As the corpus increases in size, I may consider to incorporate **4-grams** and so on

A **smoothing method** needs to be introduced to account for unseen n-grams when evaluating the model (as in perplexity calculations). A Good-Turing method is currently in the test phase; it needs to be coupled to a **finer backoff** approach (e.g. Katz) before the results can be seen at the prediction phase

Perplexity does not tell how good the model is in practice and some **task-based evaluation** is needed to compare the performance of different models

Finally, **access to the model** at the prediction phase needs to be optimised before more sophisticated / larger models can be deployed in practice in a web application or similar

--- 

## Recap

* I have set up a Shiny app that performs next-word prediction on user-provided input (you can find it [here](https://fiannuzzi.shinyapps.io/Shiny/))

* The app currently runs a reduced language model intended as a demo / prototype

* Building considerably more extended models is feasible computationally

* An upgrade of the smoothing and backoff algorithms is to be prioritized over the size of the training corpus


<style>
em {
  font-style: italic
}
</style>

<style>
strong {
  font-weight: bold;
}
</style>

