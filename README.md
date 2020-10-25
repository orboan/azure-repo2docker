# Simple azure deployment of an Ubuntu VM with training tools for programming in python and java

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Forboan%2Fazure-repo2docker%2Fmaster%2Fazuredeploy.json)


This template allows you to deploy an Ubuntu 20.04 LTS VM with docker, docker-compose, repo2docker, anaconda, git and jdk11 (including jshell).

Three conda environments are configured:

* [scijava](https://scijava.org/). SciJava aims to provide an overview of available Java libraries for scientific computing. From this environment you can use the [scijava jupyter kernel](https://github.com/scijava/scijava-jupyter-kernel). It uses the [Scijava scripting languages](https://imagej.net/Scripting#Supported_languages) to execute the code in Jupyter client and it's possible to use different languages in the same notebook.
* [java11](https://github.com/SpencerPark/IJava). From this environment you can use a jupyter kernel for executing java code, based on the jshell.
* [bio](https://anaconda.org/anaconda/biopython). Biopython is a collection of freely available Python tools for computational molecular biology.

You can connect to the virtual machine with SSH (port 22 is accessible).

This is meant only for development / training purposes.

For connecting to the notebooks in your local browser, you should use an SSH tunnel.
