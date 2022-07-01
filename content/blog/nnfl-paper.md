+++
title = "Morphosyntactic Tagging with BiLSTM Model"
author = ["Bernd Bohnet", "et al"]
date = 2021-03-21T03:00:00+05:30
lastmod = 2022-07-02T02:52:42+05:30
draft = false
creator = "Emacs 28.1 (Org mode 9.6 + ox-hugo)"
+++

> "I had shingles, which is a painful disease."

{{< figure src="/ox-hugo/machine_learning.png" link="/ox-hugo/machine_learning.png" >}}

This post contains a complete overview of the titled paper and provides a basic outline of related concepts. This paper aims to investigate to what extent having initial sub-word and word context insensitive representations affect performance.


## Abstract {#abstract}

1.  RNN leads to advances in speech tagging accuracy [Zeman et al](https://www.aclweb.org/anthology/K18-2001.pdf)
2.  Common thing among models, _rich initial word encodings_.
3.  Encodings are composed of recurrent character-based representation with learned and pre-trained word embeddings[^fn:1].
4.  Problem with the encodings, context restriced to a single word hence only via subsequent recurrent layers the word information is processed.
5.  The paper deals with models that use RNN with sentence-level context.
6.  This provides results via synchronized training with a meta-model that learns to combine their states.
7.  Results are provided on part-of-speech and morphological tagging[^fn:2] with great performance on a number of languages.


## Terms {#terms}

1.  Morphosyntactic = Morphology + Syntax and Morphology is study of words, how they are formed, and their relationship to other words in the same language.
2.  [RNN](https://medium.datadriveninvestor.com/how-do-lstm-networks-solve-the-problem-of-vanishing-gradients-a6784971a577): [On difficulty of training RNNs](https://arxiv.org/pdf/1211.5063.pdf)
3.  [LSTM](http://colah.github.io/posts/2015-08-Understanding-LSTMs/): Long Short-Term Memory is a type of RNN that addresses the vanishing gradient problem through additional cells, input and output gates.
4.  BiLSTM: It is a sequence processing model that consists of two LSTMs. They effectively increase the amount of information available to the network, improving the context available to the algorithm (e.g. knowing what words immediately follow and precede a word in a sentence).


## [Basics of NLP](https://www.kdnuggets.com/2018/06/getting-started-natural-language-processing.html) {#basics-of-nlp}


### Key Terms {#key-terms}

1.  **NLP**: Natural Language Processing concerns itself with interaction of technology with human languages.
2.  **Tokenization**: An early step in the NLP process which splits longer strings of text into smaller pieces, or _tokens_.
3.  **Normalization**: A series of tasks meant to put all text on a level playing field i.e. converting it to lowercase, removing punctuation, expanding contractions, converting numbers to their word equivalents, stripping white space, removing stop words and so on.
    -   **Stemming**: Process of eliminating affixes (suffixes, prefixes, infixes, circumfixes) from a word to obtain its stem. For example, _running_ becomes _run_.
    -   **Lemmatization**: It's related to stemming but is able to capture canonical forms based on the word's lemma (root form). For example, _better_ would turn into _good_.
4.  **Corpus**: The latin word for _body_ refers to a collection of texts which may be formed of a single language of texts, or multiple. They are generally used for statistical linguistic analysis and hypothesis testing.
5.  **Stop words**: Filter words which contribute little to the overall meaning of text since they are the very common words of the language. For example: _the_, _a_ etc.
6.  **Parts-of-speech (POS) Tagging**: It consists of assigning a category tag to the tokenized parts of a sentence such as nouns, verbs, adjectives etc. The category of words is distinguished since they share similar grammatical properties.
7.  **Statistical Language Modeling**: It's the process of building a model which takes _words_ as input and assign probabilities to the various sequences that can be formed using them.
8.  **Bag of words**: It's a representation model used to simplify the contents of a selection of text by just reducing the words to their frequency.
9.  **n-gram**: It focuses on preserving contagious sequences of N items from the text selection.


### A framework for NLP {#a-framework-for-nlp}

1.  **Data Collection or Assembly**: Building the corpus
2.  **Data Preprocessing**: Perform operations on the collected corpus which consists of tokenization, normalization, substitution (noise removal).
3.  **Data Exploration &amp; Visualization**: Includes visualizing word counts and distributions, generating wordclouds, performing distance measures.
4.  **Model Building**: Choosing the language models (FSM, MM), classifiers and sequence models (RNNs, LSTMs).
5.  **Model Evaluation**


### Data Representation {#data-representation}

1.  We need to encode text in a way that can be controlled by us using a statistical classifier.
2.  We go from a set of categorical features in text: words, letters, POS tags, word arrangement, order etc to a series of _vectors_.
3.  **One-hot Encoding** (Sparse Vectors) :
    -   Each word, or token corresponds to a vector element.
    -   Result of one-hot encoding is a sparse matrix, that is, for a corpus containing a lot of tokens, representing a small subset of them would lead to a lot of zero vectors which would consume a large amount of memory.
    -   One more drawback is that while it contains the information regarding the presence of a certain word, it lacks positional information so making sense of the tokens is not an option. For example, _Kate hates Alex_ is the same as _Alex hates Kate_.
    -   Variants of one-hot encoding are _bag-of-words_, _n-gram_ and _TF-IDF_ representations.
4.  **Dense Embedding Vectors**:
    -   The information of the semantic relationship between tokens can be conveyed using manual or learned POS tagging that determines which tokens in a text perform what type of function. (noun, verb, adverb, etc)
    -   This is useful for _named entity recognition_, i.e. our search is restricted to just the nouns.
    -   But if one represents _features_[^fn:3] as dense vectors i.e. with core features embedded into an embedding space of size _d_ dimensions, we can compress the number of dimensions used to represent a large corpus into a manageable amount.
    -   Here, each feature no longer has its own dimension but is rather mapped to a vector.


### [Word Representation](http://www.iro.umontreal.ca/~lisa/pointeurs/turian-wordrepresentations-acl10.pdf) {#word-representation}


### [Subword models](https://medium.com/analytics-vidhya/information-from-parts-of-words-subword-models-e5353d1dbc79#:~:text=Subword%2Dmodels%3A%20Byte%20Pair%20Encodings%20and%20friends,-2.1%20Byte%20pair&text=Byte%20pair%20encoding%20(BPE)%20is,pairs%20into%20a%20new%20byte.&text=BPE%20is%20a%20word%20segmentation,(Unicode)%20characters%20in%20data.) {#subword-models-20is-pairs-20into-20a-20new-20byte-dot-and-text-bpe-20is-20a-20word-20segmentation--unicode--20characters-20in-20data-dot}

1.  **Purely Character-level models**: In character-level modes, word embeddings[^fn:4] can be composed of character embeddings which have several advantages. _Character-level_ models are needed because:
    -   Languages like Chinese don't have _word segmentations_.
    -   For languages that do have, they segment in different ways.
    -   To handle large, open, informal vocabulary.
    -   Character level model can generate embeddings for _unknown_ words.
    -   Similar spellings share similar embeddings
2.  **Subword-models**: TBD???


## Morphology {#morphology}

It is a section of grammar whose main objects are **words** of languages, their _significant parts_ and _morphological signs_. Morphology studies:

-   Inflection
-   Derivation
-   POS
-   Grammatical values


### Grammatical Value {#grammatical-value}


## Introduction {#introduction}

Morphosyntactic tagging accuracy has improved due to using BiLSTMs to create _sentence-level context sensitive encodings_[^fn:5] of words which is done by creating an initial context insensitive word representation[^fn:6] having three parts:

1.  A dynamically trained word embedding
2.  A fixed pre-trained word-embedding, induced from a large corpus
3.  A sub-word character model, which is the final state of a RNN model that ingests one character at a time.

In such a model, sub-word character-based representations only interact via subsequent recurrent layers. To elaborate, context insensitive representations would normalize words that shouldn't be, but due to the subsequent BiLSTM layer, this would be overridden. This behaviour differs from traditional linear models.[^fn:7]

This paper aims to investigate to what extent having initial subword and word context insensitive representations affect performance. It proposes a hybrid model based on three models- context sensitive initial character and word models and a meta-BiLSTM model which are all trained synchronously.

On testing this system on 2017 CoNLL data sets, largest gains were found for morphologically rich languages, such as in the Slavic family group. It was also benchmarked on English PTB(?) data, where it performed extremely well compared to the previous best system.


## Related Work {#related-work}

1.  An excellent example of an accurate linear model that uses both word and sub-word features.[^fn:7] It uses context sensitive n-gram affix features.
2.  First Modern NN for tagging which initially used only word embeddings[^fn:8], was later extended to include suffix embeddings.[^fn:9]
3.  TBD TBD
4.  This is the jumping point for current architectures for tagging models with RNNs.[^fn:6]
5.  Then&nbsp;[^fn:5] showed that subword/word combination representation leads to state-of-the-art morphosyntactic tagging accuracy.


## Models {#models}


### Sentence-based Character Model {#sentence-based-character-model}

In this model, a BiLSTM is applied to all characters of a sentence to induce fully context sensitive initial word encodings. It uses sentences split into UTF8 characters as input, the spaces between the tokens are included and each character is mapped to a dynamically learned embedding. A forward LSTM reads the characters from left to right and a backward LSTM reads sentences from right to left.

{{< figure src="/ox-hugo/nnfl1a.png" caption="<span class=\"figure-number\">Figure 1: </span>Sentence-based Character Model: The representation for the token _shingles_ is the concatenation of the four shaded boxes." link="/ox-hugo/nnfl1a.png" >}}

For an _n_-character sentence, for each character embedding \\((e\_{1}^{char},...,e\_{n}^{char})\\), a BiLSTM is applied:
\\[
f\_{c,i}^{0},b\_{c,i}^{0} = BiLSTM(r\_{0},(e\_{1}^{char},...,e\_{n}^{char}))\_{i}
\\]
For multiple layers(_l_) that feed into each other through the concatenation of previous layer encodings, the last layer has both forward \\((f\_{c,l}^{l},...,f\_{c,n}^{l})\\) and backward \\((b\_{c,l}^{l},...,b\_{c,n}^{l})\\) output vectors for each character.

To create word encodings, relevant subsets of these context sensitive character encodings are combined which can then be used in a model that assigns morphosyntactic tags to each word directly or via subsequent layers. To accomplish this, the model concatenates upto four character output vectors: the {_forward, backward_} output of the {_first, last_} character in the token _T_ = \\((F\_{1st}(w), F\_{last}(w), B\_{1st}(w), B\_{last}(w))\\) which are represented by the four shaded box in _Fig. 1_.

Thus, the proposed model concatenates all four of these and passes it as input to an multilayer perceptron (MLP):
\\[
g\_{i} = concat(T)
\\]
\\[
m\_{i}^{chars} = MLP(g\_{i})
\\]
A tag can then be predicted with a _linear classifier_ that takes as input \\(m\_{i}^{chars}\\), applies a _softmax_ function and chooses for each word the tag with highest probability.


### Word-based Character Model {#word-based-character-model}

To investigate whether a sentence sensitive character model (_Fig.1_) is better than a model where the context is restricted to the characters of a word, (_Fig.2_) which uses the final state of a unidirectional LSTM, combined with the attention mechanism of (ADD REF: cao rei) over all characters.

{{< figure src="/ox-hugo/nnfl1b.png" caption="<span class=\"figure-number\">Figure 2: </span>Word-based Character Model: The token is represented by concatenation of attention over the lightly shaded boxes with the final cell (dark box)." link="/ox-hugo/nnfl1b.png" >}}

{{< figure src="/ox-hugo/nnfl1.png" caption="<span class=\"figure-number\">Figure 3: </span>BiLSTM variant of Character-level word representation" link="/ox-hugo/nnfl1.png" >}}


### Sentence-based Word Model {#sentence-based-word-model}

The inputs are the words of the sentence and for each of the words, we use pre-trained word embeddings \\((p\_{1}^{word},...,p\_{n}^{word})\\) summed with a dynamically learned word embedding for each word in the corpus \\((e\_{1}^{word},...,e\_{n}^{word})\\):
\\[
in\_{i}^{word} = e\_{i}^{word}+p\_{i}^{word}
\\]
The summed embeddings \\(in\_{i}\\) are passed as input to one or more BiLSTM layers whose output \\(f\_{w,i}^{l}, b\_{w,i}^{l}\\) is concatenated and used as the final encoding, which is then passed to an MLP:
\\[
o\_{i}^{word} = concat(f\_{w,i}^{l}, b\_{w,i}^{l})
\\]
\\[
m\_{i}^{word} = MLP(o\_{i}^{word})
\\]
The output of this BiLSTM is essentially the Word-based Character Model before tag prediction, with the exception that the word-based character encodings are excluded.

{{< figure src="/ox-hugo/nnfl2a.png" caption="<span class=\"figure-number\">Figure 4: </span>Tagging Architecture of Word-based Character Model and Sentence-based Word Model" link="/ox-hugo/nnfl2a.png" >}}


### Meta-BiLSTM: Model Combination {#meta-bilstm-model-combination}

If each of the character or word-based encodings are trained with their own loss and are combined using an additional meta-BiLSTM model, optimal performance is obtained. The meta-biLSTM model concatenates the output of context sensitive character and word-based encoding for each word and puts this through another BiLSTM to create an _additional_ combined context sensitive encoding. This is followed by a final MLP whose output is passed to a linear layer for tag prediction.
\\[
cw\_{i} = concat(m\_{i}^{char}, m\_{i}^{word})
\\]
\\[
f\_{m,i}^{l}, b\_{m,i}^{l} = BiLSTM(r\_{0},(cw\_{0},...,cw\_{n}))\_{i}
\\]
\\[
m\_{i}^{comb} = MLP(concat(f\_{m,i}^{l}, b\_{m,i}^{l}))
\\]

{{< figure src="/ox-hugo/nnfl2b.png" caption="<span class=\"figure-number\">Figure 5: </span>Tagging Architecture of Meta-BiLSTM. Data flows along the arrows and the optimizers minimize the loss of the classifiers independently and backpropogate along the bold arrows." link="/ox-hugo/nnfl2b.png" >}}


### Training Schema {#training-schema}

Loss of each model is minimized independently by separate optimizers with their own hyperparameters which makes this a multi-task learning model and hence a schedule must be defined in which individual models are updated. In the proposed algorithm, during each epoch, each of the models are updated in sequence using the entire training data.

{{< figure src="/ox-hugo/nnflAlg.png" link="/ox-hugo/nnflAlg.png" >}}

In terms of model selection, after each epoch, the algorithm evaluates the tagging accuracy of the development set and keeps the parameters of the best model. Accuracy is measured using the meta-BiLSTM tagging layer, which requires a forward pass through all three models. Only the meta-BiLSTM layer is used for model selection and test-time prediction.

The training is synchronous as the meta-BiLSTM model is trained in tandem with the two encoding models, and not after they have converged. When the meta-BiLSTM was allowed to back-propagate through the whole network, performance degraded regardless of the number of loss functions used. Each language could in theory used separate hyperparameters but identical settings for each language works well for large corpora.


## Experiments and Results {#experiments-and-results}


### Experimental Setup {#experimental-setup}

The word embeddings are initialized with zero values and the pre-trained embeddings are not updated during training. The dropout[^fn:10] used on the embeddings is achieved by a single dropout mask and dropout is used on the input and the states of the LSTM.

<a id="table--Architecture"></a>

| Model | Parameter                     | Value |
|-------|-------------------------------|-------|
| C,W   | BiLSTM Layers                 | 3     |
| M     | BiLSTM Layers                 | 1     |
| CWM   | BiLSTM size                   | 400   |
| CWM   | Dropout LSTM                  | 0.33  |
| CWM   | Dropout MLP                   | 0.33  |
| W     | Dropout Embeddings            | 0.33  |
| C     | Dropout Embedding             | 0.5   |
| CWM   | Nonlinear Activation Fn (MLP) | ELU   |

TODO Add two remaining tables


### Data Sets {#data-sets}


### POS Tagging Results {#pos-tagging-results}


### POS Tagging on WSJ {#pos-tagging-on-wsj}


### Morphological Tagging Results {#morphological-tagging-results}


## Ablation Study (Takeaways) {#ablation-study--takeaways}

-   **Impact of the training schema**: Separate optimization better than Joint optimization
-   **Impact of the Sentence-based Character Model**: Higher accuracy than word-based character context
-   **Impact of the Meta-BiLSTM Model Combination**: Combined model has significantly higher accuracy than individual models
-   **Concatenation Strategies for the Context-Sensitive Character Encodings**: Model bases a token encoding on both forward and backward character representations of both first and last character in token. (_Fig. 1_) ....
-   **Sensitivity to Hyperparameter Search**: With larger network sizes, capacity of the network increases, but it becomes prone to overfitting. Future variants of this model might benefit from higer regularization.
-   **Discussion**: TODO Proposed modifications


## Conclusions {#conclusions}


## Readings and Resources {#readings-and-resources}

1.  Pytorch: [Beginner Guide](https://pytorch.org/tutorials/beginner/nn_tutorial.html), [Detailed Guides](https://deeplizard.com/learn/playlist/PLZbbT5o_s2xrfNyHZsM6ufI0iZENK9xgG), [Notebook form](https://www.cs.toronto.edu//~lczhang/360/)
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
    -   [Python &amp; OpenGL for Scientific Visualization](https://www.labri.fr/perso/nrougier/python-opengl/), [Scientific Visualization](https://github.com/rougier/scientific-visualization-book)
6.  NLP: [Best Practices](https://github.com/microsoft/nlp-recipes), [DL Techniques for NLP](https://nlpoverview.com/)
7.  BiLSTM: [Improving POS tagging](https://arxiv.org/pdf/1807.00818v1.pdf)
8.  [Implementation](https://github.com/google/meta_tagger) of the paper


## Specific to Paper {#specific-to-paper}

1.  [Universal Dependencies](https://universaldependencies.org/guidelines.html)
2.  [Great Tutorial for NLP](https://lena-voita.github.io/nlp_course.html)
3.  [Morphology](https://github.com/Sdernal/Morphology/blob/master/README.md)

[^fn:1]: [Everything about Embeddings](https://medium.com/@b.terryjack/nlp-everything-about-word-embeddings-9ea21f51ccfe) Embedding converts symbolic representations into meaningful
[^fn:2]: Morphological tagging is the task of assigning labels to a sequence of tokens that describe them morphologically. As compared to Part-of-speech tagging, morphological tagging also considers morphological features, such as case, gender or the tense of verbs.
[^fn:3]: They are the different categorical characteristic of the given data. For example, it could be _grammatical_ classes or some _physical_ features. It is context and result dependent. Then for each token, a weight is assigned to it with respect to each feature.
[^fn:4]: A word embedding is a learned representation for text where words that have the same meaning have a similar representation.
[^fn:5]: [Graph based Neural Dependency Parser](https://www.aclweb.org/anthology/K17-3002.pdf)
[^fn:6]: [POS Tagging with BiLSTM](https://arxiv.org/pdf/1604.05529.pdf)
[^fn:7]: [\*Fast POS Tagging: SVM Approach](http://citeseerx.ist.psu.edu/viewdoc/download;jsessionid=40AFFD632AC50016FE3B435B5C3FD50F?doi=10.1.1.4.7273&rep=rep1&type=pdf)
[^fn:8]: [Unified architecture for NLP](http://machinelearning.org/archive/icml2008/papers/391.pdf)
[^fn:9]: [NLP(almost) from Scratch](https://www.jmlr.org/papers/volume12/collobert11a/collobert11a.pdf)
[^fn:10]: Dropping out units (hidden and visible) in a neural network, helps prevent the network from overfitting.
