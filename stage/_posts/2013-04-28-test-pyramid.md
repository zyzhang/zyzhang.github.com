---
layout: post
title: "测试金字塔（Test Pyramid）"
description: "本文翻译自Martin Fowler的著名文章‘Test Pyramid’，详细论述了敏捷测试中的金字塔结构"
category: 翻译
tags: [Agile,Testing]
---
{% include JB/setup %}

本文翻译自Martin Fowler的著名文章‘Test Pyramid’，详细论述了敏捷测试中的金字塔结构。

* 原文： [Test Pyramid](http://martinfowler.com/bliki/TestPyramid.html) 
* 作者： [Martin Fowler](http://martinfowler.com/) 

----------------

测试金字塔概念由[Mike Cohn](http://www.mountaingoatsoftware.com/)提出，并在其著作[《Succeeding with Agile》](http://www.amazon.com/gp/product/0321579364?ie=UTF8&tag=martinfowlerc-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=0321579364)[<sup>译注1</sup>](#MyAnnotation1)中做了详细论述。其核心观点是底层单元测试应多于依赖GUI的高层端到端测试。

![Test Pyramid](/assets/image/posts/TestPyramid.jpeg)

在我职业生涯的大部分时间中，测试自动化就是使用自动化测试工具在用户界面上操控应用程序。这些工具一般都提供录制和回放的功能，并验证应用程序返回了同样的结果。开始时，这种方式工作得很好。测试也很容易录制，即使没有程序设计经验，也可以轻松完成。

但是，这种方法很快就陷入了困境，演变成所谓的[蛋卷冰淇淋](http://watirmelon.com/2012/01/31/introducing-the-software-testing-ice-cream-cone/)。主要问题包括：基于UI的测试运行缓慢，增加了构建时间；测试自动化工具往往还需安装授权许可，这意味着这些软件只能在特定的机器上运行；通常这些测试还很难以“傻瓜”模式运行，即通过脚本执行并置入合适的部署流水线（deployment pipeline）。

更重要的是，这些测试非常脆弱。对系统功能的增强（enhancement）很容易就会破坏大量的测试，导致我们不得不重新录制。当然，可以摒弃录制-回放工具以减少此类问题的发生，但这样又增加了测试编写的难度[<sup>注1</sup>](#Annotation1)。即便应用一些优秀实践，端到端测试依然会存在[不确定性问题（non-determinism problems）](http://martinfowler.com/articles/nonDeterminism.html)，这会破坏测试的可信性。简言之，基于UI的端到端测试具有这样的缺点：脆弱、编写成本高，而且运行耗时。因此，金字塔理论认为，相对于传统的基于GUI的测试，应采用更多的自动化单元测试。

金字塔理论还认为，应该引入面向应用程序服务层的中间层测试，我把它称为[皮下测试（Subcutaneous Tests）](http://martinfowler.com/bliki/SubcutaneousTest.html)。这些测试既保持了端到端测试的诸多优势，又避免了许多与UI框架相关的复杂性。在Web应用程序中，皮下测试相当于API层测试，而位于金字塔顶层的UI测试则相当于[Selenium](http://seleniumhq.org/)或者Sahi测试。

测试金字塔引申出敏捷测试生命周期的很多核心概念，它更强调建立一个合理的测试组合。现实中的一个常见的问题是：团队将端到端测试、单元测试和面向客户的测试混为一谈，但它们其实是正交的。例如，对于富javascript用户界面来说，应该通过[Jasmine](http://pivotal.github.com/jasmine/)之类的工具对绝大多数UI行为进行单元测试；对于复杂的业务规则集合，则应通过面向客户的表单进行测试，而且应像单元测试一样仅涉及相关模块。

特别地，我始终认为高层测试只是测试防护体系的第二防线。如果一个高层测试失败了，不仅仅表明功能代码中存在bug，还意味着单元测试的欠缺。因此，无论何时修复失败的端到端测试，都应该同时添加相应的单元测试。

----------

* 注1: 对任何类型的自动化来说，录制-回放工具几乎都是个糟糕的主意，因为它们会降低易变性并且阻碍我们进行有用的抽象。它们仅值得作为生成脚本片段的工具，以便我们随后使用合适的编程语言进行改写，就像[Twist](http://www.thoughtworks-studios.com/twist-agile-testing)和[Emacs](http://www.gnu.org/software/emacs/manual/html_node/emacs/Save-Keyboard-Macro.html)那样 [<sup>译注2</sup>](#MyAnnotation2) 。 <a id="Annotation1"> </a> 
* 译注1： 全名《Succeeding with Agile: Software Development Using Scrum》，中文版《Scrum敏捷软件开发》<a id="MyAnnotation1"> </a>
* 译注2：Twist是ThoughtWorks出品的敏捷测试工具，提供录制功能；Emacs是极富盛名的文本编辑器，可以录制宏。<a id="MyAnnotation2"> </a>
