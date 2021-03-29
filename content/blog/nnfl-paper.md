+++
title = "Morphosyntactic Tagging with a Meta-BiLSTM Model over Context Sensitive Token Encodings - An Overview"
author = ["Prashant Tak"]
draft = true
creator = "Emacs 28.0.50 (Org mode 9.5 + ox-hugo)"
+++

## Abstract {#abstract}

1.  RNN leads to advances in speech tagging accuracy [Zeman et al](https://www.aclweb.org/anthology/K18-2001.pdf)
2.  Common thing among models, _rich initial word encodings_. (What does encoding, maybe related to RNN)
3.  Encodings are composed of recurrent character-based representation with learned and pre-trained word embeddings. (What are embeddings here)
4.  Problem with the encodings, context restriced to a single word hence only via subsequent recurrent layers the word information is processed.
5.  The paper deals with models that use RNN with sentence-level context.
6.  This provides results via synchronized training with a meta-model that learns to combine their states.
7.  Results are provided on part-of-speech and morphological tagging[^fn:1] with great performance on a number of languages.


## Terms {#terms}

1.  Morphosyntactic = Morphology + Syntax and Morphology is study of words, how they are formed, and their relationship to other words in the same language.
2.  [RNN](https://medium.datadriveninvestor.com/how-do-lstm-networks-solve-the-problem-of-vanishing-gradients-a6784971a577): [On difficulty of training RNNs](https://arxiv.org/pdf/1211.5063.pdf)
3.  [LSTM](http://colah.github.io/posts/2015-08-Understanding-LSTMs/): Long Short-Term Memory is a type of RNN that addresses the vanishing gradient problem through additional cells, input and output gates.
4.  BiLSTM: It is a sequence processing model that consists of two LSTMs. They effectively increase the amount of information available to the network, improving the context available to the algorithm (e.g. knowing what words immediately follow and precede a word in a sentence).


## Readings and Resources {#readings-and-resources}

1.  Pytorch: [Beginner Guide](https://pytorch.org/tutorials/beginner/nn%5Ftutorial.html), [Detailed Guides](https://deeplizard.com/learn/playlist/PLZbbT5o%5Fs2xrfNyHZsM6ufI0iZENK9xgG), [Notebook form](https://www.cs.toronto.edu//~lczhang/360/)
2.  Math: [Matrix Calculus](https://explained.ai/matrix-calculus/index.html), [Book](https://mml-book.com/)
3.  Basics:
    -   [Python](https://www.kaggle.com/learn/python)
    -   [Jupyter](https://realpython.com/jupyter-notebook-introduction/#getting-up-and-running-with-jupyter-notebook)
    -   [Numpy](http://cs231n.github.io/python-numpy-tutorial/#numpy), [Numpy 2](https://nbviewer.jupyter.org/github/jrjohansson/scientific-python-lectures/blob/master/Lecture-2-Numpy.ipynb)
    -   [Pandas](https://mlcourse.ai/articles/topic1-exploratory-data-analysis-with-pandas/), [Pandas 2](https://www.kaggle.com/learn/pandas)
    -   [Matplotlib](https://mlcourse.ai/articles/topic2-visual-data-analysis-in-python/), [Matplotlib 2](https://matplotlib.org/matplotblog/posts/an-inquiry-into-matplotlib-figures/)
    -   [Seaborn](https://mlcourse.ai/articles/topic2-part2-seaborn-plotly/)
    -   [Overview](http://scipy-lectures.org/)
4.  Interactive Tutorials on [Weight Initialization](https://www.deeplearning.ai/ai-notes/initialization/), [Different Optimizers](https://www.deeplearning.ai/ai-notes/optimization/)
5.  Rougier's Bits
    -   [Matplotlib Tutorial](https://github.com/rougier/matplotlib-tutorial), [Matplotlib Cheatsheets](https://github.com/matplotlib/cheatsheets)
    -   [Numpy Tutorial](https://github.com/rougier/numpy-tutorial), [From Python to Numpy](https://www.labri.fr/perso/nrougier/from-python-to-numpy/), [100 Numpy Exercises](https://github.com/rougier/numpy-100)
    -   [Python & OpenGL for Scientific Visualization](https://www.labri.fr/perso/nrougier/python-opengl/), [Scientific Visualization](https://github.com/rougier/scientific-visualization-book)

[^fn:1]: Morphological tagging is the task of assigning labels to a sequence of tokens that describe them morphologically. As compared to Part-of-speech tagging, morphological tagging also considers morphological features, such as case, gender or the tense of verbs.
