<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output indent="yes" encoding="ISO-8859-1" method="xml" omit-xml-declaration="yes"/>

<xsl:include href="./vulnerabilitiesdates.xsl"/>

<xsl:key name="unique-date" match="@public" use="substring(.,1,4)"/>
<xsl:key name="unique-base" match="@base" use="."/>

<xsl:template match="security">
  <xsl:text>## Do not edit this file, instead edit vulnerabilities.xml
## then create it using
## xsltproc vulnerabilities.xsl vulnerabilities.xml 
##

</xsl:text>
  <xsl:text>#use wml::openssl area=news page=vulnerabilities

</xsl:text>
<title>OpenSSL vulnerabilities</title>

<h1>OpenSSL vulnerabilities</h1>

<p>This page lists all security vulnerabilities fixed in released
versions of OpenSSL since 0.9.6a was released on 5th April 2001.
</p>

<xsl:for-each select="issue/@public[generate-id()=generate-id(key('unique-date',substring(.,1,4)))]">
  		  <xsl:sort select="." order="descending"/>
<xsl:variable name="year" select="substring(.,1,4)"/>
<h2><xsl:value-of select="$year"/></h2>
             <dl>
                <xsl:apply-templates select="../../issue[substring(@public,1,4)=$year]">
                  <xsl:sort select="cve/@name" order="descending"/>
	        </xsl:apply-templates>
             </dl>
        </xsl:for-each>
</xsl:template>

<xsl:template match="issue">
  <dt>
  <b><a name="{cve/@name}">
  <xsl:apply-templates select="cve"/>
</a></b>
<xsl:call-template name="dateformat">
  <xsl:with-param name="date" select="@public"/>
</xsl:call-template>
<p/>
</dt><dd>
  <xsl:copy-of select="description"/>
  <xsl:if test="advisory/@url">
    <a href="{advisory/@url}">(original advisory)</a><xsl:text>. </xsl:text>
        </xsl:if>
  <xsl:if test="reported/@source">
    Reported by <xsl:value-of select="reported/@source"/>.
  </xsl:if>
  </dd>
  <p/>
    <xsl:for-each select="fixed">
      <dd>Fixed in OpenSSL  
      <xsl:value-of select="@version"/>
      <xsl:variable name="mybase" select="@base"/>
      <xsl:for-each select="../affects[@base=$mybase]|../maybeaffects[@base=$mybase]">
        <xsl:sort select="@version" order="descending"/>
            <xsl:if test="position() =1">
              <xsl:text> (Affected </xsl:text>
            </xsl:if>
            <xsl:value-of select="@version"/>
            <xsl:if test="name() = 'maybeaffects'">
              <xsl:text>?</xsl:text>
            </xsl:if>
            <xsl:if test="position() != last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="position() = last()">
              <xsl:text>) </xsl:text>
            </xsl:if>
      </xsl:for-each>
      </dd>
    </xsl:for-each>
  <p/>
</xsl:template>

<xsl:template match="cve">
<xsl:if test="@description = 'full'">
The Common Vulnerabilities and Exposures project
has assigned the name 
</xsl:if>
<a href="http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-{@name}">CVE-<xsl:value-of select="@name"/>: </a>
<xsl:if test="@description = 'full'">
 to this issue.
</xsl:if>
</xsl:template>

</xsl:stylesheet>


