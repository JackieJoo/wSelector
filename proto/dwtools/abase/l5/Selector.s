( function _Selector_s_() {

'use strict';


/**
 * Collection of routines to select a sub-structure from a complex data structure. Use the module to transform a data structure with the help of a short selector string.
  @module Tools/base/Selector
*/

/**
 * @file l5/Selector.s.
 */

/**
 * Collection of routines to select a sub-structure from a complex data structure.
  @namespace Tools( module::Selector )
  @memberof module:Tools/base/Selector
*/

/* Problems :

zzz qqq : optimize
qqq : cover select with glob using test routine filesFindGlob of test suite FilesFind.Extract.test.s. ask how

*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wLooker' );
  _.include( 'wReplicator' );
  _.include( 'wPathTools' );

}

let _global = _global_;
let _ = _global_.wTools;
let Parent = _.Looker;
_.selector = _.selector || Object.create( null );
_.selector.functor = _.selector.functor || Object.create( null );

_.assert( !!_realGlobal_ );

// --
// extend looker
// --

// function srcChanged()
// {
//
//   it.selector = it.selectorArray[ it.level ];
//
// }

// function srcChanged()
// {
//   let it = this;
//
//   _.assert( arguments.length === 0 );
//
//   if( _.arrayLike( it.src ) )
//   {
//     it.iterable = 'long-like';
//   }
//   else if( _.objectIs( it.src ) )
//   {
//     it.iterable = 'map-like';
//   }
//   else
//   {
//     it.iterable = false;
//   }
//
// }

// function look()
// {
//   let it = this;
//
//   if( !it.fast )
//   _.assert( it.level >= 0 );
//   _.assert( arguments.length === 0 );
//
//   it.visiting = it.canVisit();
//   if( !it.visiting )
//   return it;
//
//   it.visitUp();
//
//   it.ascending = it.canAscend();
//   if( it.ascending )
//   it.ascend();
//
//   it.visitDown();
//   return it;
// }

function reselectIt( o )
{
  let it = this;

  _.assert( arguments.length === 1 );

  // let it2 = it.iterationRemake();
  let it2 = it.iterationMake();

  _.selector.selectSingleIt( it2, o ); /* xxx */

  return it2;
}

//

function reselect( o )
{
  let it = this;

  _.assert( arguments.length === 1 );

  let it2 = it.reselectIt( o );

  return it2.dst;
}

//

function start()
{
  let it = this;

  _.assert( arguments.length === 0 );
  _.assert( Object.hasOwnProperty.call( it.iterator, 'selector' ) );
  _.assert( Object.hasOwnProperty.call( it, 'selector' ) );
  _.assert( _.intIs( it.iterator.selector ) || _.strIs( it.iterator.selector ) );
  _.assert( !!it.upToken );
  _.assert( it.iterationIs( it ) )

  if( _.intIs( it.iterator.selector ) )
  it.iterator.selectorArray = [ it.iterator.selector ];
  else
  it.iterator.selectorArray = split( it.iterator.selector );

  return it.look();

  /* */

  function split( selector )
  {
    let splits = _.strSplit
    ({
      src : selector,
      delimeter : it.upToken,
      preservingDelimeters : 0,
      preservingEmpty : 1,
      preservingQuoting : 0,
      stripping : 1,
    });

    if( _.strBegins( selector, it.upToken ) )
    splits.splice( 0, 1 );
    if( _.strEnds( selector, it.upToken ) )
    splits.pop();

    return splits;
  }

}

// //
//
// function iterationMake()
// {
//   let it = this;
//   let newIt = it.iterationMakeAct();
//
//   // if( !it.fast )
//   // newIt.logicalLevel = it.logicalLevel + 1; /* yyy : level and logicalLevel should have the same value if no reinit done */
//
//   // newIt.absoluteLevel += 1;
//
//   _.assert( arguments.length === 0 );
//
//   return newIt;
// }
//
// //
//
// function iterationRemake()
// {
//   let it = this;
//   let newIt = it.iterationMakeAct();
//
//   // if( !it.fast )
//   // newIt.logicalLevel = it.logicalLevel;
//
//   _.assert( arguments.length === 0 );
//
//   return newIt;
// }

//

function iterationReinit( selector )
{
  let it = this;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( selector ) );

  // _.assert( o.prevSelectIteration === null || o.prevSelectIteration === o.it );
  // _.assert( o.src === null );

  _.assert( Self.iterationIs( it ), () => 'Expects iteration of ' + Self.constructor.name + ' but got ' + _.toStrShort( it ) );
  _.assert( _.strIs( it.iterator.selector ) );
  if( it.iterator.selector === undefined )
  it.iterator.selector = '';
  _.assert( _.strIs( it.iterator.selector ) );
  // o.src = it.iterator.src;
  // o.selector = it.iterator.selector + _.strsShortest( it.iterator.upToken ) + o.selector;
  it.iterator.selector = it.iterator.selector + _.strsShortest( it.iterator.upToken ) + selector;
  // o.prevSelectIteration = it;

}

//

function iterableEval()
{
  let it = this;

  _.assert( arguments.length === 0 );
  _.assert( _.boolIs( it.isTerminal ) );

  // if( it.selector === undefined || it.selector === '' || it.selector === '/' )
  if( it.isTerminal )
  {
    // debugger;
    it.iterable = false;
    it.ascendAct = it._termianlAscend;
  }
  else if( it.isRelative )
  {
    debugger;
    it.iterable = 'relative';
    it.ascendAct = it._relativeAscend;
  }
  else if( it.isGlob )
  {
    // debugger;
    // it.iterable = 'glob';
    // it.ascendAct = it._globAscend;

    if( _.longLike( it.src ) )
    {
      it.iterable = 'long-like';
      it.ascendAct = it._longAscend;
    }
    else if( _.objectIs( it.src ) )
    {
      it.iterable = 'map-like';
      it.ascendAct = it._mapAscend;
    }
    else if( _.hashMapLike( it.src ) )
    {
      it.iterable = 'hash-map-like';
      it.ascendAct = it._hashMapAscend;
    }
    else if( _.setLike( it.src ) )
    {
      it.iterable = 'set-like';
      it.ascendAct = it._setAscend;
    }
    else
    {
      it.iterable = false;
      it.ascendAct = it._termianlAscend;
    }

  }
  else
  {
    it.iterable = 'single';
    it.ascendAct = it._singleAscend;
  }

/*

  function ascend()
  {
    let it = this;

    _.assert( arguments.length === 0 );

    if( it.selector === undefined )
    it._termianlAscend();
    // else if( it.selector === it.downToken )
    else if( it.isRelative )
    it._relativeAscend();
    else if( it.isGlob )
    it._globAscend();
    else
    it._singleAscend();

  }

*/
}

//

function choose( e, k )
{
  let it = this;

  let result = Parent.choose.call( it, ... arguments );

  if( !it.fast )
  {
    it.absoluteLevel = it.absoluteLevel+1;
  }

  return result;
}

//

function selectorChanged()
{
  let it = this;

  _.assert( arguments.length === 0 );

  if( it.selector !== undefined )
  if( it.onSelectorUndecorate )
  {
    it.onSelectorUndecorate();
  }

  it.isRelative = it.selector === it.downToken;
  it.isTerminal = it.selector === undefined || it.selector === '/';

  if( it.globing )
  {

    let isGlob;
    if( _.path && _.path.isGlob )
    isGlob = function( selector )
    {
      return _.path.isGlob( selector )
    }
    else
    isGlob = function isGlob( selector )
    {
      return _.strHas( selector, '*' );
    }

    it.isGlob = it.selector ? isGlob( it.selector ) : false;

  }

  it.indexedAccessToMap();

}

//

function indexedAccessToMap()
{
  let it = this;

  if( it.selector !== undefined && !it.isRelative && !it.isGlob )
  if( it.usingIndexedAccessToMap && !isNaN( _.numberFromStr( it.selector ) ) )
  if( _.objectLike( it.src ) || _.hashMapLike( it.src ) )
  {
    let q = _.numberFromStr( it.selector );
    it.selector = _.mapKeys( it.src )[ q ];
    // if( it.selector === undefined )
    // return it.errDoesNotExistThrow();
  }

}

//

function globParse()
{
  let it = this;

  _.assert( arguments.length === 0 );
  _.assert( it.globing );

  let regexp = /(.*){?\*=(\d*)}?(.*)/;
  let match = it.selector.match( regexp );
  it.parsedSelector = it.parsedSelector || Object.create( null );

  if( !match )
  {
    it.parsedSelector.glob = it.selector;
  }
  else
  {
    _.sure( _.strCount( it.selector, '=' ) <= 1, () => 'Does not support selector with several assertions, like ' + _.strQuote( it.selector ) );
    it.parsedSelector.glob = match[ 1 ] + '*' + match[ 3 ];
    if( match[ 2 ].length > 0 )
    {
      it.parsedSelector.limit = _.numberFromStr( match[ 2 ] );
      _.sure( !isNaN( it.parsedSelector.limit ) && it.parsedSelector.limit >= 0, () => 'Epects non-negative number after "=" in ' + _.strQuote( it.selector ) );
    }
  }

}

//

function errNoDown()
{
  let it = this;
  let err = _.ErrorLooking
  (
    'Cant go down', _.strQuote( it.selector ),
    '\nbecause', _.strQuote( it.selector ), 'does not exist',
    '\nat', _.strQuote( it.path ),
    '\nin container\n', _.toStrShort( it.src )
  );
  return err;
}

//

function errNoDownThrow()
{
  let it = this;
  it.continue = false;
  if( it.missingAction === 'undefine' || it.missingAction === 'ignore' )
  {
    it.dst = undefined;
  }
  else
  {
    let err = it.errNoDown();
    it.dst = undefined;
    it.iterator.error = err;
    if( it.missingAction === 'throw' )
    throw err;
  }
}

//

function errCantSet()
{
  let it = this;
  let err = _.err
  (
    'Cant set', _.strQuote( it.key )
  );
  return err;
}

//

function errCantSetThrow()
{
  let it = this;
  throw it.errCantSet();
}

//

function errDoesNotExist()
{
  let it = this;
  let err = _.ErrorLooking
  (
    'Cant select', _.strQuote( it.selector ),
    '\nbecause', _.strQuote( it.selector ), 'does not exist',
    'at', _.strQuote( it.path ),
    '\nin container', _.toStrShort( it.src )
  );
  return err;
}

//

function errDoesNotExistThrow()
{
  let it = this;
  it.continue = false;

  if( it.missingAction === 'undefine' || it.missingAction === 'ignore' )
  {
    it.dst = undefined;
  }
  else
  {
    debugger;
    let err = it.errDoesNotExist();
    it.dst = undefined;
    it.iterator.error = err;
    if( it.missingAction === 'throw' )
    {
      debugger;
      throw err;
    }
  }

}

//

function visitUp()
{
  let it = this;

  // it.selector = it.selectorArray[ it.level ];
  // it.selectorChanged();

  it.visitUpBegin();

  // // it.indexedAccessToMap(); // yyy
  //
  // // it.selector = it.selectorArray[ it.logicalLevel-1 ];
  // // it.selector = it.selectorArray[ it.level ];
  // // it.dst = it.src; /* yyy : remove */
  //
  // it.dstWriteDown = function dstWriteDown( eit )
  // {
  //   it.dst = eit.dst;
  // }

  if( it.onUpBegin )
  it.onUpBegin.call( it );

  if( it.dstWritingDown )
  {

    // it.selectorChanged();

    // if( it.selector === undefined )
    if( it.isTerminal )
    it.upTerminal();
    // else if( it.selector === it.downToken )
    else if( it.isRelative )
    it.upRelative();
    else if( it.isGlob )
    it.upGlob();
    else
    it.upSingle();

  }

  if( it.onUpEnd )
  it.onUpEnd.call( it );

  /* */

  _.assert( it.visiting );
  _.assert( _.routineIs( it.onUp ) );
  let r = it.onUp.call( it, it.src, it.key, it );
  _.assert( r === undefined );

  it.visitUpEnd()

}

//

function visitUpBegin()
{
  let it = this;

  it.ascending = true;

  _.assert( it.visiting );

  it.selector = it.selectorArray[ it.level ];
  it.selectorChanged();

  it.dstWriteDown = function dstWriteDown( eit )
  {
    it.dst = eit.dst;
  }

  return Parent.visitUpBegin.apply( it, ... arguments );

  // it.indexedAccessToMap(); //

  // it.selector = it.selectorArray[ it.logicalLevel-1 ];
  // it.selector = it.selectorArray[ it.level ];
  // it.dst = it.src; /* yyy : remove */

  // if( it.down && !it.fast )
  // it.down.childrenCounter += 1;
  //
  // if( it.continue )
  // it.srcChanged();

}

//

function upTerminal()
{
  let it = this;

  // it.continue = false;
  it.dst = it.src;

}

//

function upRelative()
{
  let it = this;

  _.assert( it.isRelative === true );

}

//

function upGlob()
{
  let it = this;

  _.assert( it.globing );

  /* !!! qqq : teach it to parse more than single "*=" */

  if( it.globing )
  it.globParse();

  if( it.globing )
  if( it.parsedSelector.glob !== '*' )
  {
    if( it.iterable )
    {
      it.src = _.path.globFilter
      ({
        src : it.src,
        selector : it.parsedSelector.glob,
        onEvaluate : ( e, k ) => k,
      });
      it.srcChanged();
    }
  }

  if( it.iterable === 'long-like' )
  {
    it.dst = [];
    it.dstWriteDown = function( eit )
    {
      if( it.missingAction === 'ignore' && eit.dst === undefined )
      return;
      if( it.preservingIteration ) /* qqq : cover the option. seems it does not work in some cases */
      it.dst.push( eit );
      else
      it.dst.push( eit.dst );
    }
  }
  else if( it.iterable === 'map-like' )
  {
    it.dst = Object.create( null );
    it.dstWriteDown = function( eit )
    {
      if( it.missingAction === 'ignore' && eit.dst === undefined )
      return;
      if( it.preservingIteration )
      it.dst[ eit.key ] = eit;
      else
      it.dst[ eit.key ] = eit.dst;
    }
  }
  else /* qqq : not implemented for other structures, please implement */
  {
    it.errDoesNotExistThrow();
  }

}

//

function upSingle()
{
  let it = this;
}

//

function visitDown()
{
  let it = this;

  it.visitDownBegin();

  if( it.onDownBegin )
  it.onDownBegin.call( it );

  // if( it.selector === undefined )
  if( it.isTerminal )
  it.downTerminal();
  // else if( it.selector === it.downToken )
  else if( it.isRelative )
  it.downRelative();
  else if( it.isGlob )
  it.downGlob();
  else
  it.downSingle();

  it.downSet();

  if( it.onDownEnd )
  it.onDownEnd.call( it );

  /* */

  _.assert( it.visiting );
  if( it.onDown )
  {
    let r = it.onDown.call( it, it.src, it.key, it );
    _.assert( r === undefined );
  }

  it.visitDownEnd();

  /* */

  if( it.down )
  {
    _.assert( _.routineIs( it.down.dstWriteDown ) );
    if( it.dstWritingDown )
    it.down.dstWriteDown( it );
  }

}

//

function downTerminal()
{
  let it = this;
}

//

function downRelative()
{
  let it = this;
}

//

function downGlob()
{
  let it = this;

  if( !it.dstWritingDown )
  return;

  if( it.parsedSelector.limit === undefined )
  return;

  _.assert( it.globing );

  let length = _.entityLength( it.dst );
  if( length !== it.parsedSelector.limit )
  {
    let currentSelector = it.selector;
    if( it.parsedSelector && it.parsedSelector.full )
    currentSelector = it.parsedSelector.full;
    debugger;
    let err = _.ErrorLooking
    (
      'Select constraint ' + _.strQuote( currentSelector ) + ' failed'
      + ', got ' + length + ' elements'
      + ' for selector ' + _.strQuote( it.selector )
      + '\nAt : ' + _.strQuote( it.path )
    );
    if( it.onQuantitativeFail )
    it.onQuantitativeFail.call( it, err );
    else
    throw err;
  }

}

//

function downSingle()
{
  let it = this;
}

//

function downSet()
{
  let it = this;

  if( it.setting && it.isTerminal )
  {
    /* qqq : implement and cover for all type of containers */
    if( it.down && !_.primitiveIs( it.down.src ) && it.key !== undefined )
    it.down.src[ it.key ] = it.set;
    else
    it.errCantSetThrow();
  }

}

//

// function ascend( onAscend )
// function ascend()
// {
//   let it = this;
//
//   _.assert( arguments.length === 0 );
//
//   if( it.selector === undefined )
//   it._termianlAscend();
//   // else if( it.selector === it.downToken )
//   else if( it.isRelative )
//   it._relativeAscend();
//   else if( it.isGlob )
//   it._globAscend();
//   else
//   it._singleAscend();
//
// }
//
// //
//
// function _termianlAscend()
// {
//   let it = this;
//
//   _.assert( arguments.length === 0 );
//   // _.assert( it.iterable === false );
//   // _.assert( it.ascendAct === it._termianlAscend );
//   // it.ascendAct( it.src );
//
//   it._termianlAscend( it.src );
// }

//

function _relativeAscend()
{
  let it = this;
  let counter = 0;
  let dit = it.down;

  _.assert( arguments.length === 1 );

  if( !dit )
  return it.errNoDownThrow();

  // while( dit.selector === it.downToken || dit.selector === undefined || counter > 0 )
  while( dit.isRelative || dit.isTerminal || counter > 0 )
  {
    if( dit.selector === it.downToken )
    counter += 1;
    else if( dit.selector !== undefined )
    counter -= 1;
    dit = dit.down;
    if( !dit )
    return it.errNoDownThrow();
  }

  // _.assert( _.lookIterationIs( dit ) );
  _.assert( it.iterationIs( dit ) );

  it.visitPop();
  dit.visitPop();

  /* */

  // debugger;
  let nit = it.iterationMake();
  nit.choose( undefined, it.selector );
  nit.src = dit.src;
  nit.dst = undefined;
  nit.absoluteLevel -= 2;

  nit.look();
  // onAscend.call( it, nit );

  return true;
}

//

// function _globAscend()
// {
//   let it = this;
//   _.assert( arguments.length === 0 );
//   Parent.ascend.call( it );
// }

//

function _singleAscend( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  // if( it.usingIndexedAccessToMap && !isNaN( _.numberFromStr( it.selector ) ) )
  // if( _.objectLike( it.src ) || _.hashMapLike( it.src ) )
  // {
  //   debugger;
  //   let q = _.numberFromStr( it.selector );
  //   it.selector = _.mapKeys( it.src )[ q ]; /* yyy : move? */
  //   if( it.selector === undefined )
  //   return it.errDoesNotExistThrow();
  // }

  // if( _.primitiveIs( it.src ) )
  // {
  //   it.errDoesNotExistThrow();
  // }
  //
  // // else if( it.selectOptions.usingIndexedAccessToMap && _.objectLike( it.src ) && !isNaN( _.numberFromStr( it.selector ) ) )
  // else if( it.usingIndexedAccessToMap && _.objectLike( it.src ) && !isNaN( _.numberFromStr( it.selector ) ) )
  // {
  //   debugger;
  //   let q = _.numberFromStr( it.selector );
  //   it.selector = _.mapKeys( it.src )[ q ];
  //   if( it.selector === undefined )
  //   return it.errDoesNotExistThrow();
  // }
  // else if( it.src[ it.selector ] === undefined )
  // {
  //   it.errDoesNotExistThrow();
  // }
  // else
  // {
  // }

  // debugger;

  // debugger;
  let eit = it.iterationMake().choose( undefined, it.selector );
  // debugger;

  if( eit.src === undefined )
  {
    // debugger;
    // if( eit.setting )
    // eit.errCantSetThrow();
    // else
    eit.errDoesNotExistThrow();
    // return;
  }

  eit.look();
  // onAscend.call( it, eit );

}

// --
// namespace
// --

function selectSingle_pre( routine, args )
{

  let o = args[ 0 ]
  if( args.length === 2 )
  {
    // if( _.lookIterationIs( args[ 0 ] ) )
    if( Self.iterationIs( args[ 0 ] ) )
    o = { it : args[ 0 ], selector : args[ 1 ] }
    else
    o = { src : args[ 0 ], selector : args[ 1 ] }
  }

  _.routineOptionsPreservingUndefines( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( o.onUpBegin === null || _.routineIs( o.onUpBegin ) );
  _.assert( o.onDownBegin === null || _.routineIs( o.onDownBegin ) );
  _.assert( _.strIs( o.selector ) );
  _.assert( _.strIs( o.downToken ) );
  _.assert( _.longHas( [ 'undefine', 'ignore', 'throw', 'error' ], o.missingAction ), 'Unknown missing action', o.missingAction );
  _.assert( o.selectorArray === undefined );

  if( o.it )
  {
    o.it.iterationReinit( o.selector );

    _.assert( o.prevSelectIteration === null || o.prevSelectIteration === o.it );
    _.assert( o.src === null );

    o.src = o.it.iterator.src;
    o.selector = o.it.iterator.selector;
    o.prevSelectIteration = o.it;

    // _.assert( o.prevSelectIteration === null || o.prevSelectIteration === o.it );
    // _.assert( o.src === null );
    // _.assert( Self.iterationIs( o.it ), () => 'Expects iteration of ' + Self.constructor.name + ' but got ' + _.toStrShort( o.it ) );
    // _.assert( _.strIs( o.it.iterator.selector ) );
    // if( o.it.iterator.selector === undefined )
    // o.it.iterator.selector = '';
    // _.assert( _.strIs( o.it.iterator.selector ) );
    // o.src = o.it.iterator.src;
    // o.selector = o.it.iterator.selector + _.strsShortest( o.it.iterator.upToken ) + o.selector;
    // o.it.iterator.selector = o.selector;
    // o.prevSelectIteration = o.it;
    // /* yyy : move out */

  }

  if( o.setting === null && o.set !== null )
  o.setting = 1;

  // let o2 = optionsFor( o );
  let o2 = o;
  if( o2.Looker === null )
  o2.Looker = Self;
  let it = _.look.pre( selectSingleIt_body, [ o2 ] );

  _.assert( Object.hasOwnProperty.call( it.iterator, 'selector' ) );
  _.assert( Object.hasOwnProperty.call( it, 'selector' ) );

  // if( _.numberIs( it.iterator.selector ) )
  // it.iterator.selectorArray = [ it.iterator.selector ];
  // else
  // it.iterator.selectorArray = split( it.iterator.selector );

  _.assert( o.it === it || o.it === null );

  return it;

  /* */

  // function split( selector )
  // {
  //   let splits = _.strSplit
  //   ({
  //     src : selector,
  //     delimeter : o.upToken,
  //     preservingDelimeters : 0,
  //     preservingEmpty : 1,
  //     preservingQuoting : 0,
  //     stripping : 1,
  //   });
  //
  //   if( _.strBegins( selector, o.upToken ) )
  //   splits.splice( 0, 1 );
  //   if( _.strEnds( selector, o.upToken ) )
  //   splits.pop();
  //
  //   return splits;
  // }

  /* */

  // function optionsFor( o )
  // {
  //
  //   let o2 = o;
  //   if( o2.Looker === null )
  //   o2.Looker = Self;
  //   return o2;
  // }

}

//

function selectSingleIt_body( it )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.lookerIs( it.Looker ) );
  _.assert( it.looker === undefined );
  // debugger;
  // let it2 = _.look.body( it );
  // _.assert( it === it2 );
  it.start();
  return it;
}

var defaults = selectSingleIt_body.defaults = _.mapExtend( null, _.look.defaults );

defaults.Looker = null;
defaults.it = null;
defaults.src = null;
defaults.selector = null;
defaults.missingAction = 'undefine';
// defaults.missingAction = 'throw';
defaults.preservingIteration = 0;
defaults.usingIndexedAccessToMap = 0;
defaults.globing = 1;
defaults.revisiting = 2;
defaults.absoluteLevel = 0;
defaults.upToken = '/';
defaults.downToken = '..';

defaults.replicateIteration = null;
defaults.prevSelectIteration = null;

defaults.visited = null;
defaults.selected = null;

defaults.set = null;
defaults.setting = null;

defaults.onUpBegin = null;
defaults.onUpEnd = null;
defaults.onDownBegin = null;
defaults.onDownEnd = null;
defaults.onQuantitativeFail = null;
defaults.onSelectorUndecorate = null;

//

/**
 * @summary Selects elements from source object( src ) using provided pattern( selector ).
 * @description Returns iterator with result of selection
 * @param {} src Source entity.
 * @param {String} selector Pattern that matches against elements in a entity.
 *
 * @example //select element with key 'a1'
 * let it = _.selectSingleIt( { a1 : 1, a2 : 2 }, 'a1' );
 * console.log( it.dst )//1
 *
 * @example //select any that starts with 'a'
 * let it = _.selectSingle( { a1 : 1, a2 : 2 }, 'a*' );
 * console.log( it.dst ) // { a1 : 1, a2 : 1 }
 *
 * @example //select with constraint, only one element should be selected
 * let it = _.selectSingle( { a1 : 1, a2 : 2 }, 'a*=1' );
 * console.log( it.error ) // error
 *
 * @example //select with constraint, two elements
 * let it = _.selectSingle( { a1 : 1, a2 : 2 }, 'a*=2' );
 * console.log( it.dst ) // { a1 : 1, a2 : 1 }
 *
 * @example //select inner element using path selector
 * let it = _.selectSingle( { a : { b : { c : 1 } } }, 'a/b' );
 * console.log( it.dst ) //{ c : 1 }
 *
 * @example //select value of each property with name 'x'
 * let it = _.selectSingle( { a : { x : 1 }, b : { x : 2 }, c : { x : 3 } }, '*\/x' );
 * console.log( it.dst ) //{a: 1, b: 2, c: 3}
 *
 * @example // select root
 * let it = _.selectSingle( { a : { b : { c : 1 } } }, '/' );
 * console.log( it.dst )
 *
 * @function selectSingleIt
 * @memberof module:Tools/base/Selector.Tools( module::Selector )
*/

let selectSingleIt = _.routineFromPreAndBody( selectSingle_pre, selectSingleIt_body );

//

function selectSingle_body( it )
{
  // let it2 = _.selectIt.body( it );
  // _.assert( it2 === it )
  it.start();
  _.assert( arguments.length === 1, 'Expects single argument' );
  // if( it.selectOptions.missingAction === 'error' && it.error )
  // return it.error;
  if( it.missingAction === 'error' && it.error )
  return it.error;
  _.assert( it.error === null );
  return it.dst;
}

_.routineExtend( selectSingle_body, selectSingleIt );

//

/**
 * @summary Selects elements from source object( src ) using provided pattern( selector ).
 * @description Short-cur for {@link module:Tools/base/Selector.Tools( module::Selector ).selectSingle _.selectSingleIt }. Returns found element(s) instead of iterator.
 * @param {} src Source entity.
 * @param {String} selector Pattern that matches against elements in a entity.
 *
 * @example //select element with key 'a1'
 * _.selectSingle( { a1 : 1, a2 : 2 }, 'a1' ); // 1
 *
 * @example //select any that starts with 'a'
 * _.selectSingle( { a1 : 1, a2 : 2 }, 'a*' ); // { a1 : 1, a2 : 1 }
 *
 * @example //select with constraint, only one element should be selected
 * _.selectSingle( { a1 : 1, a2 : 2 }, 'a*=1' ); // error
 *
 * @example //select with constraint, two elements
 * _.selectSingle( { a1 : 1, a2 : 2 }, 'a*=2' ); // { a1 : 1, a2 : 1 }
 *
 * @example //select inner element using path selector
 * _.selectSingle( { a : { b : { c : 1 } } }, 'a/b' ); //{ c : 1 }
 *
 * @example //select value of each property with name 'x'
 * _.selectSingle( { a : { x : 1 }, b : { x : 2 }, c : { x : 3 } }, '*\/x' ); //{a: 1, b: 2, c: 3}
 *
 * @example // select root
 * _.selectSingle( { a : { b : { c : 1 } } }, '/' );
 *
 * @function selectSingle
 * @memberof module:Tools/base/Selector.Tools( module::Selector )
*/

let selectSingle = _.routineFromPreAndBody( selectSingle_pre, selectSingle_body );

//

function select_pre( routine, args )
{

  let o = args[ 0 ]
  if( args.length === 2 )
  {
    if( Self.iterationIs( args[ 0 ] ) )
    o = { it : args[ 0 ], selector : args[ 1 ] }
    else
    o = { src : args[ 0 ], selector : args[ 1 ] }
  }

  _.routineOptionsPreservingUndefines( routine, o );

  if( o.root === null )
  o.root = o.src;

  if( o.compositeSelecting )
  {

    if( o.onSelectorReplicate === onSelectorReplicate || o.onSelectorReplicate === null )
    o.onSelectorReplicate = _.selector.functor.onSelectorComposite();
    if( o.onSelectorDown === null )
    o.onSelectorDown = _.selector.functor.onSelectorDownComposite();

    _.assert( _.routineIs( o.onSelectorReplicate ) );
    _.assert( _.routineIs( o.onSelectorDown ) );

  }

  return o;
}

//

function select_body( o )
{

  _.assert( !o.recursive || !!o.onSelectorReplicate, () => 'For recursive selection onSelectorReplicate should be defined' );
  _.assert( o.it === null || o.it.constructor === Self.constructor );

  return multipleSelect( o.selector );

  /* */

  function multipleSelect( selector )
  {
    let o2 =
    {
      src : selector,
      onUp,
      onDown,
    }

    o2.iterationPreserve = Object.create( null );
    o2.iterationPreserve.composite = false;
    o2.iterationPreserve.compositeRoot = null;

    o2.iteratorExtension = Object.create( null );
    o2.iteratorExtension.selectMultipleOptions = o;

    let it = _.replicateIt( o2 );

    return it.dst;
  }

  /* */

  function singleOptions()
  {
    let it = this;
    let single = _.mapExtend( null, o );
    single.replicateIteration = it;

    single.selector = null;
    single.visited = null;
    single.selected = false;

    delete single.onSelectorUp;
    delete single.onSelectorDown;
    delete single.onSelectorReplicate;
    // delete single.onSelectorUndecorate;
    delete single.recursive;
    delete single.dst;
    delete single.root;
    delete single.compositeSelecting;
    delete single.compositePrefix;
    delete single.compositePostfix;

    _.assert( !single.it || single.it.constructor === Self.constructor );

    return single;
  }

  // /* */
  //
  // function selectSingleFirst()
  // {
  //   let it = this;
  //   _.assert( _.strIs( it.src ) );
  //   let dst = selectSingle.call( it, [] );
  //   return dst;
  // }

  /* */

  function selectSingle( visited )
  {
    let it = this;
    // let r = Object.create( null );

    _.assert( _.strIs( it.src ) );
    _.assert( arguments.length === 1 );

    let op = singleOptions.call( it );
    // op.selector = o.onSelectorUndecorate.call( it );
    op.selector = it.src;
    op.visited = visited;
    op.selected = false;

    if( _.longHas( visited, op.selector ) )
    return op;

    _.assert( _.strIs( op.selector ) );
    _.assert( !_.longHas( visited, op.selector ), () => `Loop selecting ${op.selector}` );

    // visited.push( it.src );
    visited.push( op.selector );

    // r.op = singleOptions.call( it );
    // r.op.selector = it.src;
    // r.op.selector = selector;

    _.assert( _.strIs( op.selector ) );

    op.result = _.selectSingle( op );
    op.selected = true;

    // if( o.recursive && visited.length <= o.recursive )
    // {
    //   let selector2 = o.onSelectorReplicate.call( it, dst );
    //   if( selector2 !== undefined )
    //   {
    //     it.src = selector2;
    //     return selectSingle.call( it, visited );
    //   }
    // }

    return op;
  }

  /* */

  function onUp()
  {
    let it = this;
    let selector
    let visited = [];

    selector = o.onSelectorReplicate.call( it, it.src );

    do
    {

      if( _.strIs( selector ) )
      {
        // let visited = [];
        // do
        {
          it.src = selector;
          it.srcChanged();
          let single = selectSingle.call( it, visited );
          // if( single.selected )
          // it.dst = single.result;
          // it.continue = false;
          // it.dstSetting = false;
          selector = undefined;
          if( single.result !== undefined && o.recursive && visited.length <= o.recursive )
          {
            selector = o.onSelectorReplicate.call( it, single.result );
            if( selector === undefined )
            {
              if( single.selected )
              it.dst = single.result;
              it.continue = false;
              it.dstSetting = false;
            }
          }
          else
          {
            if( single.selected )
            it.dst = single.result;
            it.continue = false;
            it.dstSetting = false;
          }
        }
        // while( _.strIs( selector ) );
      }
      else if( selector !== undefined )
      {
        if( selector && selector.composite === _.select.composite )
        {
          if( !it.compositeRoot )
          it.compositeRoot = it;
          it.composite = true;
        }
        it.src = selector;
        it.srcChanged();
        selector = undefined;
      }

    }
    while( selector !== undefined );

    // if( selector && selector.composite === _.select.composite )
    // {
    //   if( !it.compositeRoot )
    //   it.compositeRoot = it;
    //   it.composite = true;
    // }
    // else if( selector )
    // {
    //   it.continue = false;
    //   it.dstSetting = false;
    // }

    if( o.onSelectorUp )
    o.onSelectorUp.call( it, o );
  }

  /* */

  function onDown()
  {
    let it = this;
    if( o.onSelectorDown )
    o.onSelectorDown.call( it, o );
  }

  /* */

}

_.routineExtend( select_body, selectSingle.body );

var defaults = select_body.defaults;
defaults.root = null;
defaults.onSelectorUp = null;
defaults.onSelectorDown = null;
defaults.onSelectorReplicate = onSelectorReplicate;
defaults.onSelectorUndecorate = onSelectorUndecorate;
defaults.recursive = 0;
defaults.compositeSelecting = 0;

//

/**
 * @summary Selects elements from source object( src ) using provided pattern( selector ).
 * @param {} src Source entity.
 * @param {String} selector Pattern that matches against elements in a entity.
 *
 * @example //select element with key 'a1'
 * _.select( { a1 : 1, a2 : 2 }, 'a1' ); // 1
 *
 * @example //select any that starts with 'a'
 * _.select( { a1 : 1, a2 : 2 }, 'a*' ); // { a1 : 1, a2 : 1 }
 *
 * @example //select with constraint, only one element should be selected
 * _.select( { a1 : 1, a2 : 2 }, 'a*=1' ); // error
 *
 * @example //select with constraint, two elements
 * _.select( { a1 : 1, a2 : 2 }, 'a*=2' ); // { a1 : 1, a2 : 1 }
 *
 * @example //select inner element using path selector
 * _.select( { a : { b : { c : 1 } } }, 'a/b' ); //{ c : 1 }
 *
 * @example //select value of each property with name 'x'
 * _.select( { a : { x : 1 }, b : { x : 2 }, c : { x : 3 } }, '*\/x' ); //{a: 1, b: 2, c: 3}
 *
 * @example // select root
 * _.select( { a : { b : { c : 1 } } }, '/' );
 *
 * @example // select from array
 * _.selectSingle( [ 'a', 'b', 'c' ], '2' ); // 'c'
 *
 * @example // select second element from each string of array
 * _.selectSingle( [ 'ax', 'by', 'cz' ], '*\/1' ); // [ 'x', 'y', 'z' ]
 *
 * @function select
 * @memberof module:Tools/base/Selector.Tools( module::Selector )
*/

let select = _.routineFromPreAndBody( select_pre, select_body );

//

/**
 * @summary Short-cut for {@link module:Tools/base/Selector.Tools( module::Selector ).selectSingle _.selectSingle }. Sets value of element selected by pattern ( o.selector ).
 * @param {Object} o Options map
 * @param {} o.src Source entity
 * @param {String} o.selector Pattern to select element(s).
 * @param {} o.set=null Entity to set.
 * @param {Boolean} o.setting=1 Allows to set value for a property or create a new property if needed.
 *
 * @example
 * let src = {};
   _.selectSet({ src, selector : 'a', set : 1 });
   console.log( src.a ); //1
 *
 * @function selectSet
 * @memberof module:Tools/base/Selector.Tools( module::Selector )
*/

let selectSet = _.routineFromPreAndBody( selectSingle.pre, selectSingle.body );

var defaults = selectSet.defaults;
defaults.set = null;
defaults.setting = 1;

//

/**
 * @summary Short-cut for {@link module:Tools/base/Selector.Tools( module::Selector ).selectSingle _.selectSingle }. Returns only unique elements.
 * @param {} src Source entity.
 * @param {String} selector Pattern that matches against elements in a entity.
 *
 * @function select
 * @memberof module:Tools/base/Selector.Tools( module::Selector )
*/

function selectUnique_body( o )
{
  _.assert( arguments.length === 1 );

  let selected = _.selectSingle.body( o );

  let result = _.replicate({ src : selected, onUp });

  return result;

  function onUp( e, k, it )
  {
    if( _.longLike( it.src ) )
    {
      // if( _.arrayIs( it.src ) )
      it.src = _.longOnce( it.src );
      // else
      // it.src = _.longOnce( null, it.src ); /* xxx : uncomment later */
    }
  }

}

_.routineExtend( selectUnique_body, selectSingle.body );

let selectUnique = _.routineFromPreAndBody( selectSingle.pre, selectUnique_body );

//

function onSelectorReplicate( src )
{
  let it = this;
  if( _.strIs( src ) )
  return src;
}

//

function onSelectorUndecorate()
{
  let it = this;
  _.assert( _.strIs( it.selector ) || _.numberIs( it.selector ) );
}

//

function onSelectorComposite( fop )
{

  fop = _.routineOptions( onSelectorComposite, arguments );
  fop.prefix = _.arrayAs( fop.prefix );
  fop.postfix = _.arrayAs( fop.postfix );
  fop.onSelectorReplicate = fop.onSelectorReplicate || onSelectorReplicate;

  _.assert( _.strsAreAll( fop.prefix ) );
  _.assert( _.strsAreAll( fop.postfix ) );
  _.assert( _.routineIs( fop.onSelectorReplicate ) );

  return function onSelectorComposite( selector )
  {
    let it = this;

    if( !_.strIs( selector ) )
    return;

    let selector2 = _.strSplitFast
    ({
      src : selector,
      delimeter : _.arrayAppendArrays( [], [ fop.prefix, fop.postfix ] ),
    });

    if( selector2[ 0 ] === '' )
    selector2.splice( 0, 1 );
    if( selector2[ selector2.length-1 ] === '' )
    selector2.pop();

    if( selector2.length < 3 )
    {
      if( fop.isStrippedSelector )
      return fop.onSelectorReplicate.call( it, selector );
      else
      return;
    }

    if( selector2.length === 3 )
    if( _.strsEquivalentAny( fop.prefix, selector2[ 0 ] ) && _.strsEquivalentAny( fop.postfix, selector2[ 2 ] ) )
    return fop.onSelectorReplicate.call( it, selector2[ 1 ] );

    selector2 = _.strSplitsCoupledGroup({ splits : selector2, prefix : '{', postfix : '}' });

    if( fop.onSelectorReplicate )
    selector2 = selector2.map( ( split ) =>
    {
      if( !_.arrayIs( split ) )
      return split;
      _.assert( split.length === 3 );

      let split1 = fop.onSelectorReplicate.call( it, split[ 1 ] );
      if( split1 === undefined )
      return split.join( '' );
      else
      return split[ 0 ] + split1 + split[ 2 ];

      // if( fop.onSelectorReplicate.call( it, split[ 1 ] ) === undefined )
      // return split.join( '' );
      // else
      // return split;

    });

    selector2 = selector2.map( ( split ) => _.arrayIs( split ) ? split.join( '' ) : split );
    selector2.composite = _.select.composite;

    return selector2;
  }

  function onSelectorReplicate( selector )
  {
    return selector;
  }

}

onSelectorComposite.defaults =
{
  prefix : '{',
  postfix : '}',
  onSelectorReplicate : null,
  isStrippedSelector : 0, /* treat selector beyond affixes like "pre::c/c2" as selector */
}

//

function onSelectorDownComposite( fop )
{
  return function onSelectorDownComposite()
  {
    let it = this;
    if( it.continue && _.arrayIs( it.dst ) && it.src.composite === _.select.composite )
    {
      it.dst = _.strJoin( it.dst );
    }
  }
}

//

function onSelectorUndecorateDoubleColon()
{
  return function onSelectorUndecorateDoubleColon()
  {
    let it = this;
    if( !_.strIs( it.selector ) )
    return;
    if( !_.strHas( it.selector, '::' ) )
    return;
    it.selector = _.strIsolateRightOrAll( it.selector, '::' )[ 2 ];
  }
}

// --
// declare looker
// --

let Selector = Object.create( Parent );

Selector.constructor = function Selector(){};
Selector.Looker = Selector;
// Selector.look = look;
Selector.reselectIt = reselectIt;
Selector.reselect = reselect;
Selector.start = start;
// Selector.iterationMake = iterationMake;
// Selector.iterationRemake = iterationRemake;
Selector.iterationReinit = iterationReinit;
Selector.iterableEval = iterableEval;
Selector.choose = choose;
Selector.selectorChanged = selectorChanged;
Selector.indexedAccessToMap = indexedAccessToMap;
Selector.globParse = globParse;

Selector.errNoDown = errNoDown;
Selector.errNoDownThrow = errNoDownThrow;
Selector.errCantSet = errCantSet;
Selector.errCantSetThrow = errCantSetThrow;
Selector.errDoesNotExist = errDoesNotExist;
Selector.errDoesNotExistThrow = errDoesNotExistThrow;

Selector.visitUp = visitUp;
Selector.visitUpBegin = visitUpBegin;
Selector.upTerminal = upTerminal;
Selector.upRelative = upRelative;
Selector.upGlob = upGlob;
Selector.upSingle = upSingle;

Selector.visitDown = visitDown;
Selector.downTerminal = downTerminal;
Selector.downRelative = downRelative;
Selector.downGlob = downGlob;
Selector.downSingle = downSingle;
Selector.downSet = downSet;

// Selector.ascend = ascend;
// Selector._termianlAscend = _termianlAscend;
Selector._relativeAscend = _relativeAscend;
// Selector._globAscend = _globAscend;
Selector._singleAscend = _singleAscend;

let Iterator = Selector.Iterator = _.mapExtend( null, Selector.Iterator );

Iterator.selectorArray = null;
Iterator.replicateIteration = null;

let Iteration = Selector.Iteration = _.mapExtend( null, Selector.Iteration );

Iteration.dst = null;
Iteration.selector = null;
Iteration.absoluteLevel = 0;
Iteration.parsedSelector = null;
Iteration.isRelative = null;
Iteration.isGlob = null;
Iteration.isTerminal = null;
Iteration.dstWritingDown = true;
Iteration.dstWriteDown = null;

let IterationPreserve = Selector.IterationPreserve = _.mapExtend( null, Selector.IterationPreserve );
IterationPreserve.absoluteLevel = 0;

// --
// declare
// --

let composite = Symbol.for( 'composite' );
var FunctorExtnesion =
{
  onSelectorComposite,
  onSelectorDownComposite,
  onSelectorUndecorateDoubleColon,
}

let SelectorExtension =
{

  selectSingleIt,
  selectSingle,
  select,
  selectSet,
  selectUnique,

  onSelectorUndecorate,
  onSelectorReplicate,
  composite,

}

let SupplementSelect =
{

  onSelectorUndecorate,
  onSelectorReplicate,
  composite,

}

let SupplementTools =
{

  Selector,

  selectSingleIt,
  selectSingle,
  select,
  selectSet,
  selectUnique,

}

let Self = Selector;
_.mapSupplement( _, SupplementTools );
_.mapSupplement( _.selector, SelectorExtension );
_.mapSupplement( _.selector.functor, FunctorExtnesion );
_.mapSupplement( select, SupplementSelect );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _;

})();
