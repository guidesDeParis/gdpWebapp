xquery version "3.0" ;
module namespace gdp.models.tei = 'gdp.models.tei' ;

(:~
 : This module is a TEI models library for paris' guidebooks edition
 :
 : @version 1.0
 : @date 2019-05
 : @since 2014-11-10 
 : @author emchateau (Cluster Pasts in the Present)
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
 :)

import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module namespace gdp.globals = 'gdp.globals' at '../globals.xqm' ;

declare namespace tei = 'http://www.tei-c.org/ns/1.0' ;

declare default function namespace 'gdp.models.tei' ;

(:~
 : ~:~:~:~:~:~:~:~:~
 : tei builders
 : ~:~:~:~:~:~:~:~:~
 :)

(:~
 : this function get abstract
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a tei abstract
 :)
declare function getAbstract($content as element()*, $lang as xs:string) {
  $content//tei:div[@type='abstract']
};

(:~
 : this function get authors
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a distinct-values comma separated list
 :)
declare function getAuthors($content as element()*, $lang as xs:string) as xs:string {
  fn:string-join(
      for $name in $content/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author | $content/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt[tei:resp[@key='aut']]
      return getName($name, $lang),
    ', ')
};

(:~
 : this function get the licence url
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return the @target url of licence
 :
 : @rmq if a sequence get the first one
 : @todo make it better !
 :)
declare function getCopyright($content as element()*, $lang as xs:string) as xs:string {  fn:string-join(
    $content//tei:licence[1]/@target,
    ', '
  )
};

(:~
 : this function get date
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getDate($content as element()*, $dateFormat as xs:string) {
  fn:normalize-space(
    ($content//tei:publicationStmt/tei:date)[1]
  )
};

(:~
 : this function get date
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getEditionDates($content as element()*, $dateFormat as xs:string) {
  let $dates := for $date in ($content//*:date/fn:substring(@when, 1, 4), $content//*:date/fn:substring(@from, 1, 4), $content//*:date/fn:substring(@to, 1, 4))
    where $date != '' 
    return xs:double($date)
  return fn:min($dates) || '-' || fn:max($dates)
};

(:~
 : this function get bibliographical authors
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of names separated by &
 :)
declare function getBiblAuthors($content as element()*, $lang as xs:string) as xs:string {
  fn:string-join(
    for $author in $content//tei:author
    return fn:string-join(
      for $namePart in $author/tei:persName/tei:* 
      return $namePart, ' '), ' &amp; '
    )
};

(:~
 : this function get date
 :
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getBiblDates($content as element()*, $dateFormat as xs:string) {
  fn:string-join(
    $content//tei:imprint/tei:date, ', '
  )
};

(:~
 : this function get bibliographical expressions
 :
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getBiblExpressions($content as element(), $dateFormat as xs:string) {
  let $id := $content/@xml:id
  return fn:distinct-values(
      db:open('gdp')//tei:biblStruct[tei:listRelation/tei:relation[@type = 'work'][@corresp = '#' || $content/@xml:id]]
    )
};

(:~
 : this function get bibliographical manifestations
 :
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getBiblManifestations($content as element(), $dateFormat as xs:string) {
  for $refId in db:open('gdp')//tei:biblStruct[tei:listRelation/tei:relation[@type = 'work'][@corresp = '#' || $content/@xml:id]]/@xml:id
  return fn:distinct-values(db:open('gdp')//tei:biblStruct[tei:listRelation/tei:relation[@type = 'expression'][@corresp = '#' || $refId]])
};

(:~
 : this function get bibliographical titles
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getBiblTitle($content as element()*, $lang as xs:string) as element()* {
  $content//tei:title[@level='m']
};

(:~
 : this function get bibliographical title
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string
 :)
declare function getBiblTitles($content as element()*, $lang as xs:string){
  fn:string-join(
    for $title in $content//tei:title
      return fn:normalize-space($title),
    ', ')
};

(:~
 : this function get description
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a comma separated list of 90 first caracters of div[@type='abstract']
 :)
declare function getDescription($content as element()*, $lang as xs:string) {
  fn:string-join(
    for $abstract in $content//tei:div[parent::tei:div[fn:starts-with(@xml:lang, $lang)]][@type='abstract']/tei:p 
      return fn:substring(fn:normalize-space($abstract), 0, 90),
    ', ')
};

(:~
 : this function get the number of editions
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a comma separated list of 90 first caracters of div[@type='abstract']
 :)
declare function getOtherEditions($ref as node()? ) as element()* {
  let $corresp := $ref//tei:relation[@type]/@corresp
  return 
    if ($ref/@type = 'expression') 
    then <tei:listBibl>{db:open('gdp')//tei:biblStruct[tei:listRelation/tei:relation[@type = 'expression'][fn:substring-after(@corresp, '#') = $ref/@xml:id]]}
      </tei:listBibl>
    else <tei:listBibl>{db:open('gdp')//tei:biblStruct[tei:listRelation/tei:relation[@type = 'expression'][@corresp = $corresp ]]}</tei:listBibl>
};

(:~
 : this function get keywords from textClass
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a sequence of keywords
 :)
declare function getKeywords($content as element()*, $lang as xs:string) {
    for $terms in fn:distinct-values($content//tei:keywords[fn:starts-with(@xml:lang, $lang)]/tei:term) 
    return fn:normalize-space($terms)
};

(:~
 : this function get the numbers of texts
 :
 : @param $corpus a corpus item
 : @return a number of texts
 :)
declare function getTextsQuantity($corpus as element(), $lang) {
  fn:count($corpus//tei:TEI)
};

(:~
 : this function serialize persName
 :
 : @param $named named content to process
 : @param $lang iso langcode starts
 : @return concatenate forename and surname
 :)
declare function getName($named as element()*, $lang as xs:string) as xs:string {
  fn:normalize-space(
    for $person in $named/tei:persName[1] 
      return ($person/tei:forename || ' ' || $person/tei:surname)
    )
};

(:~
 : this function get post before
 :
 : @param $queryParams the query parameters
 : @text the TEI document to process
 : @param $lang iso langcode starts
 : @return a blog post
 :)
declare function getBlogItemBefore($queryParams as map(*), $text as element(), $lang as xs:string) as element()? {
  let $entryId := map:get($queryParams, 'entryId')
  let $sequence := 
    for $text in synopsx.models.synopsx:getDb($queryParams)/tei:teiCorpus/tei:TEI
    order by $text/tei:teiHeader/tei:publicationStmt/tei:date/@when 
    return $text
  let $position := fn:index-of($sequence, $sequence[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id = $entryId]])
  return $sequence[fn:position() = $position - 1]
};

(:~
 : this function get post after
 :
 : @param 
 : @text the TEI document to process
 : @param $lang iso langcode starts
 : @return a blog post
 :)
declare function getBlogItemAfter($queryParams as map(*), $text as element(), $lang as xs:string) as element()? {
  let $entryId := map:get($queryParams, 'entryId')
  let $sequence := 
    for $text in synopsx.models.synopsx:getDb($queryParams)/tei:teiCorpus/tei:TEI
    order by $text/tei:teiHeader/tei:publicationStmt/tei:date/@when 
    return $text
  let $position := fn:index-of($sequence, $sequence[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id = $entryId]])
  return $sequence[fn:position() = $position + 1]
};

(:~
 : this function get the bibliographical reference of a text or a corpus
 :
 : @param $content a tei or teiCorpus document
 : @return a bibliographical tei element
 : @bug why does the request brings back two results ?
 : @todo suppress the explicit DB selection
 :)
declare function getRef($content as element()) {
  let $refId := fn:substring-after($content/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/@copyOf, '#')
  return (db:open('gdp')//tei:biblStruct[@xml:id = $refId] | db:open('gdp')//tei:bibl[@xml:id = $refId])[1]
};


(:~
 : this function get titles
 :
 : @param $content tei content to treat
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getTitles($content as element()*, $lang as xs:string){
  fn:string-join(
    for $title in $content/tei:teiHeader/tei:fileDesc/tei:titleStmt//tei:title
      return fn:normalize-space($title[fn:starts-with(@xml:lang, $lang)]),
    ', ')
};

(:~
 : this function get title
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getMainTitle($content as element()*, $lang as xs:string){
  ($content/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'main'])[1]
};

(:~
 : this function get subtitle
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getSubtitle($content as element()*, $lang as xs:string){
  ($content/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub'])[1]
};

(:~
 : this function get item after
 :
 : @param 
 : @param $lang iso langcode starts
 : @return a div
 :)
declare function getItemAfter($item as element(), $lang as xs:string) as element()? {
  $item/following-sibling::tei:div[@type = 'section' or @type = 'item' or @type = 'chapter' or @type = 'part' ][1]
};

(:~
 : this function get item before
 :
 : @param 
 : @param $lang iso langcode starts
 : @return a div
 :)
declare function getItemBefore($item as element(), $lang as xs:string) as element()? {
  $item/preceding-sibling::tei:div[@type = 'section' or @type = 'item' or @type = 'chapter' or @type = 'part' ][1]
};

(:~
 : this function built a quantity message
 :
 : @param $content texts to process
 : @param $unit a single unit label
 : @param $units a plural unit label
 : @return concatenate quantity and a message
 : @todo to internationalize
 :)
declare function getQuantity($content as element()*, $unit as xs:string, $units as xs:string){
  fn:normalize-space(
    if (fn:count($content) > 1) 
      then fn:count($content) || ' ' || $units
      else fn:count($content) || ' ' || $unit
    )
};

(:~
 : this function get tei doc by id
 :
 : @param $id documents id to retrieve
 : @return a plain xml-tei document
 :)
declare function getXmlTeiById($queryParams){
  db:open(map:get($queryParams, 'dbName'))//tei:TEI[//tei:sourceDesc[@xml-id = map:get($queryParams, 'value')]]
}; 

(:
 : this function get url
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 : @todo print the real uri
 :)
declare function getUrl($content, $path as xs:string, $lang as xs:string){
  $gdp.globals:root || $path || $content
};


(:~
 : this function get string length
 :
 : @param $content texts to process
 : @return string length
 :)
declare function getStringLength($content as element()*){
  fn:sum(
    for $text in $content//tei:body
    return fn:string-length($text)
  )
};

