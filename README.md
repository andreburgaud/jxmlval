# JXML Validator (jxmlval)

CLI tool to validate an XML file against an XML Schema Definition (XSD).

## Usage

The simplest way to use `jxmlval` on any system is via [Docker](https://hub.docker.com/r/andreburgaud/jxmlval).
For example, to display `jxmlval`'s help:

```
docker run --rm -it andreburgaud/jxmlval --help
```

```
     ___  ____  __ _ __     __    _      
    | \ \/ /  \/  | |\ \   / /_ _| |     
 _  | |\  /| |\/| | | \ \ / / _` | |     
| |_| |/  \| |  | | |__\ V / (_| | |     
 \___//_/\_\_|  |_|_____\_/ \__,_|_|     

Usage: jxmlval [-hV] [--java-version] [--xsd=<xsdFile>] [<xmlFiles>...]
Validate XML files against XML Schema (XSD Validation).
      [<xmlFiles>...]   XML Files
  -h, --help            Show this help message and exit.
      --java-version    Show Java Version.
  -V, --version         Print version information and exit.
      --xsd=<xsdFile>   XSD File
```

To validate an XML file `books.xml` against an XML schema definition file `books.xsd`, you can use the following command:

```
docker run --rm -it -v $PWD/xml_files:/files andreburgaud/jxmlval --xsd /files/books.xsd /files/books.xml
```

```
✅ /files/books.xsd (XML Schema)
✅ /files/books.xml
```

The XML and XSD files are in the git repository, folder `xml_files`. The example above assumes you run the command from the root of the project.

## Java Compilation

To execute a local non-native version, first, create a distribution:

```
./gradlew installDist
```

Then you can execute `jxmlval` by invoking the generated bootstrap script:

```
build/install/jxmlval/bin/jxmlval --help
```

## Native Compilation

* You can see the `justfile` task `native-linux` to perform a Linux native build.
* Linux x86_64 native executables are available in the [GitHub releases section](https://github.com/andreburgaud/jssl/releases)
* Static executable images are not supported on Mac Os (Darwin)


### Native Image via Docker

If you are on Linux x86-64, you can build the Docker image and then extract the files needed to execute `jxmlval` locally without the need to install Java on your machine (Docker is still required):

```
docker create --name jxmlval-build andreburgaud/jxmlval
docker cp jxmlval-build:/jxmlval .
docker rm -f jxmlval-build
```

To run the application:

```
./jxmlval --help
```

### Native Image

To build a native image on your machine - not via Docker - you need to [install GraalVM](https://www.graalvm.org/latest/docs/getting-started/).
You can also use [SDKMAN](https://sdkman.io/) to manage different JVMs, including GraalVM.

You can build a local native image, executing the following command (requires `just` https://github.com/casey/just):

```
just native-image
```

To test and execute the application:

```
native/bin/jxmlval --help
```

You can also manually run the individual commands from the task `native-image` in the `justfile`.

# License

[MIT License](./LICENSE)
