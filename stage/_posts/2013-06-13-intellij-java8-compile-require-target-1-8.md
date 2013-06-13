---
layout: post
title: "IntelliJ中ava8编译错误-‘source release 8 requires target release 1.8’"
description: "在IntelliJ的Java8项目中，尽管已经将Project SDK和Project Launguage Level设置为Java 8，编译测试时仍然会出现编译错误： \n>java: javacTask: source release 8 requires target release 1.8 \n这里列出了两种解决方案..."
category: Tech
tags: [Java, Java8, IntelliJ]
---
{% include JB/setup %}

在IntelliJ的Java8项目中，尽管已经将Project SDK和Project Launguage Level设置为Java 8，编译测试时仍然会出现编译错误：
>java: javacTask: source release 8 requires target release 1.8
这里列出了两种解决方案...

### 环境：

* JDK Version: 1.8.0-ea
* IDE: IntelliJ Idea 12.1.4 
* IntelliJ SDK Setting: ![IntelliJJava8Setting](/assets/image/posts/idea-java8-setting.png)
* Maven Compiler Setting:
{% highlight xml %}
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.1</version>
    <configuration>
        <source>1.8</source>
        <target>1.8</target>
    </configuration>
</plugin>
{% endhighlight %}

### 问题描述

* IntelliJ中无编译错误，运行测试时报错：`java: javacTask: source release 8 requires target release 1.8`
* 命令行运行`mvn test`无错误

### 解决方案：将*Target Bytecode Version*设为1.8。

* 方法1：在IntelliJ的【Preferences】->【Compiler】->【Java Compiler】中修改：![IntelliJJavaCompiler8](/assets/image/posts/intellij-java-compiler-1-8.png)
* 方法2：修改.idea/compiler.xml
{% highlight xml %}
<bytecodeTargetLevel>
  <module name="Java8Preview" target="1.8" />
</bytecodeTargetLevel>
{% endhighlight %}