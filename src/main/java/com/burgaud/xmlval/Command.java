package com.burgaud.xmlval;

import java.io.File;
import java.util.concurrent.Callable;

import picocli.CommandLine;
import static picocli.CommandLine.*;

@CommandLine.Command(name = "jxmlval",
        mixinStandardHelpOptions = true,
        version = "@|green,bold jxmlval version 0.1.0|@",
        header = {
                "@|green,bold      ___  ____  __ _ __     __    _      |@",
                "@|green,bold     | \\ \\/ /  \\/  | |\\ \\   / /_ _| |     |@",
                "@|green,bold  _  | |\\  /| |\\/| | | \\ \\ / / _` | |     |@",
                "@|green,bold | |_| |/  \\| |  | | |__\\ V / (_| | |     |@",
                "@|green,bold  \\___//_/\\_\\_|  |_|_____\\_/ \\__,_|_|     |@",
                ""},
        description = "Validate XML files against XML Schema (XSD Validation).")
public class Command implements Callable<Integer> {
    @Parameters(arity = "0..", description = "XML Files")
    private File[] xmlFiles;

    @Option(names = {"--xsd"}, description = "XSD File")
    private File xsdFile;

    @Option(names = {"--java-version"}, description = "Show Java Version.")
    private boolean javaVersion;

    @Override public Integer call() {
        if (javaVersion) {
            Cli.printSuccess(String.format("Java version %s", System.getProperty("java.version")));
            return 0;
        }

        if (xsdFile != null) {
            Validation val;

            try {
                val = new Validation(xsdFile);
                Cli.printInfo(String.format("%s %s (XML Schema)", "✅", xsdFile.getAbsolutePath()));
            } catch (ValidationException e) {
                Cli.printError(String.format("%s %s: %s", "❌", xsdFile.getAbsolutePath(), e.getMessage()));
                return 1;
            }

            if (xmlFiles == null) {
                return 0;
            }
            for (File file : xmlFiles) {
                try {
                    val.validate(file);
                    Cli.printSuccess(String.format("%s %s", "✅", file.getAbsolutePath()));
                } catch (ValidationException e) {
                    Cli.printError(String.format("%s %s: %s", "❌", file.getAbsolutePath(), e.getMessage()));
                }
            }
        }

        return 0;
    }
}
