xquery version "3.0" ;
module namespace gdp.edition = 'gdp.edition' ;

(:~
 : This module is a rest for Paris' guidebooks electronic edition
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

import module namespace rest = 'http://exquery.org/ns/restxq';

import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module namespace gdp.models.tei = "gdp.models.tei" at '../models/tei.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;

declare default function namespace 'gdp.edition' ;

(:~
 : this resource function redirect to /home
 :)
declare 
  %rest:path('/gdp')
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
  %rest:path('/gdp/home')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function editionHome() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getHome'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'home.xhtml',
    'pattern' : 'incBullet.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
}; 

(:~
 : resource function for corpus list
 :
 : @return an html representation of the corpus resource
 :)
declare 
  %rest:path('/gdp/corpus')
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
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incCorpusItem.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $result, $outputParams)
};

(:~
 : resource function for a corpus ID
 :
 : @param $corpusId the corpus ID
 : @return an html representation of the corpus resource
 :)
declare 
  %rest:path('/gdp/corpus/{$corpusId}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function corpusItem($corpusId as xs:string) {
  let $queryParams := map {
    'corpusId' : $corpusId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getCorpusById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incCorpusCard.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $result, $outputParams)
};

(:~
 : resource function for a corpus ID
 :
 : @param $corpusId the corpus ID
 : @return an html representation of the corpus resource
 :)
(: declare 
  %rest:path('/gdp/texts')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function texts($corpusId as xs:string) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getTextsList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incCorpusCard.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $result, $outputParams)
}; :)

(:~
 : resource function for a corpus ID
 :
 : @param $corpusId the corpus ID
 : @return an html representation of the corpus resource
 :)
declare 
  %rest:path('/gdp/texts/{$textId}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function textItem($textId as xs:string) {
  let $queryParams := map {
    'textId' : $textId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getTextById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incCorpusCard.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for a text item by ID
 :
 : @param $corpusId the text item ID
 : @return an html representation of the text item
 :)
declare 
  %rest:path('/gdp/texts/{$textId}/{$itemId}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function textItem($textId as xs:string, $itemId as xs:string) {
  let $queryParams := map {
    'textId' : $textId,
    'itemId' : $itemId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getItemById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incItem.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : this resource function is a bibliographical list for testing
 : @return an html representation of the bibliographical list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %rest:path("/gdp/resp/list/html")
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
  %rest:query-param("pattern", "{$pattern}")
function biblioListHtml($pattern as xs:string?) {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getRespList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'incBlogList.xhtml',
    'pattern' : 'incBlogArticle.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : this resource function is a documentation
 : @return an html representation of the bibliographical list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %rest:path("/gdp/model")
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function model() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'path' : '/schema/gdpSchemaTEI.odd.xml',
    'model' : 'tei',
    'function' : 'getModel'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'about.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : this resource function is a about page
 : @return an html representation of the bibliographical list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %rest:path("/about")
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function about() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'blog',
    'model' : 'tei',
    'function' : 'getAbout',
    'entryId' : 'gdpPresentation2014'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'about.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $result, $outputParams)
};

(:~
 : this resource function is a about page
 : @return an html representation of the bibliographical list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %rest:path("/documentation")
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function documentation() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'path' : '/schema/gdpSchemaTEI.odd.xml',
    'model' : 'tei',
    'function' : 'getModel'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'about.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

declare 
  %rest:path("/gdp/html/header")
function getHtmlHeader() {
  fn:doc($G:WORKSPACE||'gdp/templates/header.xhtml')
};

declare 
  %rest:path("/gdp/html/footer")
function getHtmlFooter() {
  fn:doc($G:WORKSPACE||'gdp/templates/footer.xhtml')
};

(:~
 : sommaire d‘un texte
 :)

(:~
 : index topo
 :)
 
(:~
 : index prosopo
 :)
 
(:~
 : index œuvres
 :)
 
(:~
 : entrées d’index d’un texte ???
 :)
 
(:~
 : cartes et accès complexes 
 :)
 

declare %rest:path("gdp/test/{$param}")
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function test($param){
  <h1>My first page {$param} !</h1>
};
