package com.burgaud.xmlval;

import picocli.CommandLine;

class Main {
    public static void main(String... args) {
        int exitCode = new CommandLine(new Command()).execute(args);
        System.exit(exitCode);
    }
}
