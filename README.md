# Introducing the dynarex-import gem

The dynarex-import gem is primarily designed to transform an rss document to a dynarex document.

    require 'dynarex-import'

    buffer = File.open('bbc_news.rss','r').read

    schema = 'rss[title, link, last_modified]/item(title,link,pub_date)'
    rss_schema = 'rss/channel[title, link, lastBuildDate]/item(title,link,pubDate)'

    xml = DynarexImport.new(xml:buffer, foreign_schema: rss_schema, schema: schema).to_xml
    puts xml

    output:
    <?xml version="1.0"?> 
    <rss>
      <summary>
        <title>BBC News - World</title>
        <link>http://www.bbc.co.uk/go/rss/int/news/-/news/world/</link>
        <last_modified>Sat, 29 Jan 2011 22:13:17 GMT</last_modified>
        <recordx_type>dynarex</recordx_type>
        <schema>rss[title, link, last_modified]/item(title,link,pub_date)</schema>
      </summary>
      <records>
        <item><title>Embattled Mubarak appoints deputy</title><link>http://www.bbc.co.uk/go/rss/int/news/-/news/world-middle-east-12316465</link><pub_date>Sat, 29 Jan 2011 21:18:39 GMT</pub_date></item>
        <item><title>Dutch cut Iran links over hanging</title><link>http://www.bbc.co.uk/go/rss/int/news/-/news/world-middle-east-12317138</link><pub_date>Sat, 29 Jan 2011 21:44:18 GMT</pub_date></item>
      </records>
    </rss>


## Resources
* [jrobertson/dynarex-import - GitHub](https://github.com/jrobertson/dynarex-import)

