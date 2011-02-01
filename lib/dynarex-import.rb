#!/usr/bin/ruby

# file: dynarex-import.rb

require 'nokogiri'

class DynarexImport

  attr_reader :to_xml

  def initialize(options={})
    o = {xml: '', foreign_schema: '', schema: ''}.merge(options)
    @xsl = build_xsl(o[:foreign_schema], o[:schema])    
    @to_xml = transform(xsl, o[:xml])
  end

  private

  def build_xsl(foreign_schema, native_schema)

    a1 = capture_fields(native_schema)
    a2 = capture_fields(foreign_schema)

    h = {
      summary: [
        a1[0][0], a2[0][0], # root name, and xpath
        Hash[a1[0][-1].zip(a2[0][-1])] # summary fields
      ], 
      records: [
        a1[-1][0].to_sym, a2[-1][0], # record name, and relative record name
        Hash[a1[-1][-1].zip(a2[-1][-1])] # record fields
      ]
    }

    xsl = "<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>
<xsl:output method='xml' indent='yes' />

"
    xsl << "
  <xsl:template match='#{h[:summary][1]}'>
    <xsl:element name='#{h[:summary][0]}'>
      <xsl:element name='summary'>
    "

    h[:summary][-1].each do |key,value|
      xsl << "
        <xsl:element name='#{key}'>
          <xsl:value-of select='#{value}'/>
        </xsl:element>
      "
    end

    xsl << "
        <recordx_type>dynarex</recordx_type>
        <schema>#{native_schema}</schema>
      </xsl:element>

      <xsl:element name='records'>
        <xsl:apply-templates select='#{h[:records][0]}'/>  
      </xsl:element>

    </xsl:element>

  </xsl:template>

  <xsl:template match='#{h[:records][1]}'>
    <xsl:element name='#{h[:records][0]}'>
    "

    h[:records][-1].values.each do |value|
      xsl << "
      <xsl:apply-templates select='#{value}'/>"
    end

    xsl << "

    </xsl:element>
     <xsl:text>
    </xsl:text>
    "

    xsl << "
  </xsl:template>        
    "

    h[:records][-1].each do |key,value|
      xsl << "
  <xsl:template match='#{value}'>
    <xsl:element name='#{key}'>
      <xsl:value-of select='.'/>
    </xsl:element>
  </xsl:template>
      "
    end

    xsl << "
</xsl:stylesheet>        
    "
    xsl

  end

  def capture_fields(schema)
    rec_name, raw_rec_fields = schema.match(/(\w+)\(([^\)]+)\)$/).captures
    rec_fields = raw_rec_fields.split(',').map(&:strip)

    summary_name, raw_summary_fields = ($`).match(/([^\[]+)(\[([^\]]+)\]\/)?$/)\
      .captures.values_at(0, -1)
    summary_fields = raw_summary_fields.split(',').map(&:strip)

    [[summary_name, summary_fields], [rec_name, rec_fields]]
  end

  def transform(xsl, xml)
    doc = Nokogiri::XML(xml)
    xslt  = Nokogiri::XSLT(xsl)
    xslt.transform(doc).to_xml
  end

end


