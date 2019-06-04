# NixDoc

## What this is
A section on Nix built-in functions with type declaration

Types are as follows:

```
Number       - A number
Int          - An integer
Bool         - A boolean (true or false)
(x ->> Type) - A lambda with parameter x, returning type Type
{x ->> Type} - A "proper function", such as { x, y ? 123}: ...
*            - Any type (polymorphic)
***          - Variable number of parameters

[ Type ]     - A list of Type

{}           - A set
{ a = b; }   - A set containing some a mapped to some b
{ a = *; }   - A set containing some a mapped to some element of any type (types * need not be the same)

String       - A String
Path         - A Path
Path|String  - A path or a String
a            - A specific type which is carried through to execution
```

Syntax is as follows:

```
functionName :: parameter1 -> parameter2 ->> returnedValue

functionName :: typeClass var => var ->> returnVal

functionName :: param1 ->> !! ->> returnVal 
```

Typeclasses:

```
Eq a => a can be compared using ==, >, <, <= and >=
```

"Dangerous operations":
```
Anything with ->> !! ->> Performs an impure operation. Read the documentation! 
```

## Built in functions

### Calculation (Maths)

#### builtins.add    :: Number -> Number ->> Number
#### builtins.bitAnd :: Int -> Int ->> Int
#### builtins.bitOr  :: Int -> Int ->> Int
#### builtins.bitXor :: Int -> Int ->> Int
#### builtins.div    :: Number -> Number ->> Number



#### builtins.addErrorContext :: String -> a ->> a

#### builtins.all :: (a ->> Bool) -> [ a ] ->> Bool
#### builtins.any :: (a ->> Bool) -> [ a ] ->> Bool

#### builtins.attrNames  :: { a = *; } ->> [ String ]
#### builtins.attrValues :: { a = *; } ->> [ * ]

baseNameOf


builtins

#### builtins.catAttrs :: String -> [ { a = *; } ] ->> [ * ]

```
nix-repl> builtins.catAttrs "hi" [ {hi = 3;} {hi = 4;}]
[ 3 4 ]
```

#### builtins.compareVersions :: String -> String ->> Int
#### builtins.splitVersion    :: String -> [ String ]

#### builtins.concatLists :: [ [ * ] ] ->> [ * ]
```
nix-repl> builtins.concatLists [ [ "hi" ] [ 2 [3] ] [ 4 ] ]
[ "hi" 2 [ ... ] 4 ]
```

#### builtins.concatMap :: ([ * ] ->> [ * ]) -> [ [ * ] ] ->> [ * ]

Transforms each inner list using the function (which takes in the inner list)

```
nix-repl> builtins.concatMap (x: ["blah"] ++ x ++ ["text"]) [ [ "hi" "hello" ] [ "status" ] ]
[ "blah" "hi" "hello" "text" "blah" "status" "text" ]
```

#### builtins.concatStringsSep

### Constants

#### builtins.currentSystem :: String
#### builtins.currentTime :: Int
#### builtins.false :: Bool

### Compositions

#### builtins.deepSeq

### Derivations

#### builtins.derivation :: { a = *; } ->> <<derivation>>
#### builtins.derivationStrict :: ?? ->> <<derivation>>

#### builtins.dirOf :: Path|String ->> Path|String
Gets the parent directory of the input

### Operations on lists

#### builtins.elem :: * -> [ * ] ->> Bool
#### builtins.elemAt :: [ * ] -> Int ->> *
#### builtins.filter :: Eq a => (a ->> Bool) -> [ a ] -> [ a ]


#### builtins.fetchGit
#### builtins.fetchMercurial
#### builtins.fetchTarball
#### builtins.fetchurl


#### builtins.filterSource :: (Path -> String ->> Bool) ->> !! ->> String 
```
String value in the function (Path -> String ->> Bool) must be:
"regular", "directory", "symlink" or "unknown"

!! Creates a directory at the return value with the contents filtered by the predicate function
```

#### builtins.findFile :: [ { path = String; } ] -> String ->> ??

#### builtins.foldl' :: (a -> a ->> a) -> a ->> [ a ]

### File parsers

#### builtins.fromJSON :: String -> { a = *; }
#### builtins.fromTOML :: String -> { a = *; }

#### builtins.functionArgs :: {*** ->> *} -> { * = Bool; }
#### builtins.genList
#### builtins.genericClosure
#### builtins.getAttr
#### builtins.getEnv
#### builtins.hasAttr
#### builtins.hasContext
#### builtins.hashString
#### builtins.head
#### builtins.import
#### builtins.intersectAttrs
#### builtins.isAttrs
#### builtins.isBool
#### builtins.isFloat
#### builtins.isFunction
#### builtins.isInt
#### builtins.isList
#### builtins.isNull
#### builtins.isString
#### builtins.langVersion
#### builtins.length
#### builtins.lessThan
#### builtins.listToAttrs
#### builtins.map
#### builtins.mapAttrs
#### builtins.match
#### builtins.mul
#### builtins.nixPath
#### builtins.nixVersion
#### builtins.null
#### builtins.parseDrvName
#### builtins.partition
#### builtins.path
#### builtins.pathExists
#### builtins.placeholder
#### builtins.readDir
#### builtins.readFile
#### builtins.removeAttrs
#### builtins.replaceStrings
#### builtins.scopedImport
#### builtins.seq
#### builtins.sort
#### builtins.split
#### builtins.splitVersion
#### builtins.storeDir
#### builtins.storePath
#### builtins.stringLength
#### builtins.sub
#### builtins.substring
#### builtins.tail
#### builtins.throw
#### builtins.toFile
#### builtins.toJSON
#### builtins.toPath
#### builtins.toString
#### builtins.toXML
#### builtins.trace
#### builtins.true
#### builtins.tryEval
#### builtins.typeOf
#### builtins.unsafeDiscardOutputDependency
#### builtins.unsafeDiscardStringContext
#### builtins.unsafeGetAttrPos
#### builtins.valueSize
