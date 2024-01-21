package com.burgaud.xmlval

import spock.lang.Shared
import spock.lang.Specification

class ValidationSpec extends Specification {
    @Shared val = new Validation(new File("xml_files/books.xsd"))

    def "validate valid XML file"() {
        when:
        val.validate(new File("xml_files/books.xml"))
        then:
        notThrown(ValidationException)
    }

    def "validate non-valid XML file"() {
        when:
        val.validate(new File("xml_files/books_error.xml"))
        then:
        thrown(ValidationException)
    }

    def "error when initializing schema"() {
        when:
        new Validation(new File("xml_files/books_error.xsd"))
        then:
        thrown(ValidationException)
    }
}

