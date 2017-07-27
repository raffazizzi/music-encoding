<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This script separates into multiple modules an ODD schemaSpec with declarations belonging to multiple modules -->
    <!-- NB: to avoid adding default attributes to the output, disable "Expand attribute defaults" -->
    <!-- Author: Raff Viglianti -->
    <!-- License: Public domain -->
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>
    
    <xsl:param name="outputPath" select="'../../source/specs/modules/'">
        <!-- The path to the directory where the module files will be created -->
    </xsl:param>
    <xsl:param name="modulesPath" select="'modules/'">
        <!-- The path to the output directory relative to the MEI source file -->
    </xsl:param>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>    
    
    <xsl:template match="tei:schemaSpec">
        <schemaSpec xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:sequence select="@*"/>
            <xsl:for-each-group select="*" group-by="@module">
                <xsl:element name="xi:include" namespace="http://www.w3.org/2001/XInclude">
                    <xsl:attribute name="href" select="concat($modulesPath, current-grouping-key(), '.xml')"/>
                    <xsl:attribute name="xpointer" select="concat('module.', current-grouping-key())"/>
                </xsl:element>
                <specGrpRef target="#module.{current-grouping-key()}"/>
                <xsl:result-document method="xml" indent="yes" encoding="UTF-8" href="{concat($outputPath, current-grouping-key())}.xml">
                    <xsl:processing-instruction name="xml-model">href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_odds.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>                    
                    <xsl:processing-instruction name="xml-model">href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_odds.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
                    <div xmlns="http://www.tei-c.org/ns/1.0">
                       <specGrp xml:id="module.{current-grouping-key()}">
                           <xsl:apply-templates select="//tei:moduleSpec[@ident=current-grouping-key()]"/>
                           <xsl:apply-templates select="current-group()"/>
                       </specGrp>
                    </div>
                </xsl:result-document>
            </xsl:for-each-group>
            <!-- Orphan comments are placed after all the specGrpRefs -->
            <xsl:apply-templates select="comment()"/>
        </schemaSpec>
    </xsl:template>
    
</xsl:stylesheet>