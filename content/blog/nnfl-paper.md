+++
title = "Morphosyntactic Tagging with a Meta-BiLSTM Model over Context Sensitive Token Encodings - An Overview"
author = ["Prashant Tak"]
draft = false
creator = "Emacs 28.0.50 (Org mode 9.5 + ox-hugo)"
+++

## Abstract {#abstract}

1.  RNN leads to advances in speech tagging accuracy [Zeman et al](https://www.aclweb.org/anthology/K18-2001.pdf)
2.  Common thing among models, _rich initial word encodings_. (What does encoding, maybe related to RNN)
3.  Encodings are composed of recurrent character-based representation with learned and pre-trained word embeddings. (What are embeddings here)
4.  Problem with the encodings, context restriced to a single word hence only via subsequent recurrent layers the word information is processed.
5.  The paper deals with models that use RNN with sentence-level context.
6.  This provides results via synchronized training with a meta-model that learns to combine their states.
7.  Results are provided on part-of-speech and morphological tagging \footnote{Morphological tagging is the task of assigning labels to a sequence of tokens that describe them morphologically. As compared to Part-of-speech tagging, morphological tagging also considers morphological features, such as case, gender or the tense of verbs.} with great performance on a number of languages.


## Terms {#terms}

1.  Morphosyntactic = Morphology + Syntax and Morphology is study of words, how they are formed, and their relationship to other words in the same language.
2.  [RNN](https://medium.datadriveninvestor.com/how-do-lstm-networks-solve-the-problem-of-vanishing-gradients-a6784971a577): [On difficulty of training RNNs](https://arxiv.org/pdf/1211.5063.pdf)
3.  [LSTM](http://colah.github.io/posts/2015-08-Understanding-LSTMs/): Long Short-Term Memory is a type of RNN that addresses the vanishing gradient problem through additional cells, input and output gates.
4.  BiLSTM: It is a sequence processing model that consists of two LSTMs. They effectively increase the amount of information available to the network, improving the context available to the algorithm (e.g. knowing what words immediately follow and precede a word in a sentence).
