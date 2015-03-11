xquery version "3.0" ;
module namespace gdp.edition = 'gdp.edition' ;

(:~
 : This module is a RESTXQ for Paris' guidebooks electronic edition
 :
 : @author emchateau (Cluster Pasts in the Present)
 : @since 2015-02-05 
 : @version 0.5
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
 : @qst give webpath by dates and pages ?
 :)

import module namespace restxq = 'http://exquery.org/ns/restxq';

import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../../../lib/commons.xqm' ;

import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../../../models/tei.xqm' ;
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;

declare default function namespace 'gdp.edition' ;

(:~
 : this resource function redirect to /home
 :)
declare 
  %restxq:path('/gdp')
function index() {
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/gdp/home"/>
    </http:response>
  </rest:response>
};

(:~
 : resource function for the home
 :
 : @return a home page for the edition
 :)
declare 
  %restxq:path('/gdp/home')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function editionHome() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getTextsList'
    }
  let $function := xs:QName(synopsx.lib.commons:getModelFunction($queryParams))
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsArticleSerif.xhtml',
    'xquery' : 'tei2html'
    (: specify an xslt mode and other kind of output options :)
    }
    return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $data, $outputParams)
}; 

(:~
 : resource function for corpus list
 :
 : @return an html representation of the corpus resource
 :)
declare 
  %restxq:path('/gdp/corpus')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function corpus() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getCorpusList'
    }
  let $function := xs:QName(synopsx.lib.commons:getModelFunction($queryParams))
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.html',
    'pattern' : 'article.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};

(:~
 : this resource function is a corpus list for testing
 :
 : @return an html representation of the corpus list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %restxq:path("/gdp/texts")
  (: %restxq:query-param("pattern", "{$pattern}") :)
function texts() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getTextsList'
    }
  let $function := xs:QName(synopsx.lib.commons:getModelFunction($queryParams))
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'inc_blogListSerif.xhtml',
    'pattern' : 'inc_blogArticleSerif.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};

(:~
 : this resource function is a bibliographical list for testing
 : @return an html representation of the bibliographical list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %restxq:path("/gdp/resp/list/html")
  %restxq:query-param("pattern", "{$pattern}")
function biblioListHtml($pattern as xs:string?) {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getRespList'
    }
  let $function := xs:QName(synopsx.lib.commons:getModelFunction($queryParams))
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'inc_blogListSerif.xhtml',
    'pattern' : 'inc_blogArticleSerif.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};

declare 
  %restxq:path("/gdp/html/header")
function getHtmlHeader() {
  fn:doc($G:WORKSPACE||'gdp/templates/inc_header.xhtml')
};

declare 
  %restxq:path("/gdp/html/footer")
function getHtmlFooter() {
  fn:doc($G:WORKSPACE||'gdp/templates/inc_footer.xhtml')
};