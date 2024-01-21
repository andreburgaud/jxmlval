package com.burgaud.xmlval;

import org.xml.sax.SAXException;

import java.io.File;
import java.io.IOException;
import javax.xml.XMLConstants;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

public class Validation {
    private Validator validator;
    public Validation(File xsd) throws ValidationException {
        SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
        try {
            Schema schema = factory.newSchema(xsd);
            validator = schema.newValidator();
        } catch (SAXException e) {
            throw new ValidationException(e.getMessage());
        }
    }

    public void validate(File xml) throws ValidationException {
        try {
            validator.validate(new StreamSource(xml));
        } catch (IOException | SAXException e) {
            throw new ValidationException(e.getMessage());
        }
    }
}
