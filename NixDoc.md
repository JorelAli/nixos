# NixDoc

## What this is
A section on Nix built-in functions with type declaration

Types are as follows:

```
Number       - A number
Int          - An integer
Bool         - A boolean (true or false)
(x -> Type) - A lambda with parameter x, returning type Type
{x -> Type} - A "proper function", such as { x, y ? 123}: ...
*            - Any type (polymorphic)
***          - Variable number of parameters

[ Type ]     - A list of Type

{}           - A set
Attr          - An attribute (Like a String, but no quotes)
{ Attr = b; }   - A set containing some a mapped to some b
{ Attr = *; }   - A set containing some a mapped to some element of any type (types * need not be the same)

String       - A String
Path         - A Path, OR A STRING (Because all paths are also strings)
Type|Type    - A type a or type b
a            - A specific type which is carried through to execution
```

Syntax is as follows:

```
functionName :: parameter1 -> parameter2 -> returnedValue

functionName :: typeClass var => var -> returnVal

functionName :: param1 -> !! -> returnVal 
```

Typeclasses:

```
Eq a => a can be compared using ==, >, <, <= and >=
```

"Dangerous operations":
```
Anything with -> !! -> Performs an impure operation. Read the documentation! 
```

## Built in functions

* `builtins.abort :: String -> !!`
Evaluating this function at any point in time stops Nix from evaluating anything else

### Calculation (Maths)

* `builtins.add :: Number -> Number -> Number`
  Adds two numbers together
* `builtins.bitAnd :: Int -> Int -> Int`
  Performs a bitwise AND on two numbers
* `builtins.bitOr :: Int -> Int -> Int`
  Performs a bitwise OR on two numbers
* `builtins.bitXor :: Int -> Int -> Int`
  Performs a bitwise XOR on two numbers
* `builtins.div :: Number -> Number -> Number`
  Divides the first number by the second number. If the second number is 0, an error is thrown
* `builtins.mul :: Number -> Number -> Number`
  Multiplies two numbers together
* `builtins.sub :: Number -> Number -> Number`
  Subtracts the second number from the first number

### Constants

- `builtins :: { Attrs = *; }`
	Returns the set of functions declared in the `builtins` library for Nix, ordered alphabetically by their function name and function result
	```
	{ 
	  abort = <<function>>;
	  add = <<function>>;
	  ...
	  currentSystem = "x86_64-linux";
	  ...
	  valueSize = <<function>>;
	}
	```
- `builtins.currentSystem :: String`
	Returns the current system architecture. Example values include:
	* `"x86_64-linux"`
	* `"i686-linux"`
	* `"x86_64-darwin"`
- `builtins.currentTime :: Int`
	Returns the current system time in seconds between the current time and midnight, January 1, 1970 UTC
- `builtins.false :: Bool`
	Returns `false`
- `builtins.langVersion :: Int`
	Returns the version of the Nix language installed on the system
- `builtins.nixPath :: [ { path = String; prefix = String; } ]`
	Returns the path for something something loaded nix environment? <<- TODO!
- `builtins.nixVersion :: String`
	Returns the version of Nix that is installed on the system
- `builtins.null :: null`
	Returns `null`
- `builtins.storeDir :: String`
	Returns the directory of the Nix store (Normally `/nix/store`)

### Operations on Sets

* `builtins.attrNames  :: { Attr = *; } -> [ String ]`
	Returns a list of attribute names from the given set
* `builtins.attrValues :: { Attr = *; } -> [ * ]`
	Returns a list of attribute values from the given set
* `builtins.catAttrs :: String -> [ { Attr = *; } ] -> [ * ]`
	Concatenates attribute values of a given attribute name from all sets into a list of those values
	```
	builtins.catAttrs "hi" [ { hi = 3; } { hi = 4; } ]
	=> [ 3 4 ]
	```
* `builtins.getAttr :: String -> { Attr = *; } -> *`
	Retrieves the value of a given attribute in a given set
* `builtins.hasAttr :: String -> { Attr = *; } -> Bool`
	Returns whether a specific attribute name exists in a given set

### Operations on Lists

* `builtins.all :: (a -> Bool) -> [ a ] -> Bool`
* `builtins.any :: (a -> Bool) -> [ a ] -> Bool`
* `builtins.elem :: * -> [ * ] -> Bool`
* `builtins.elemAt :: [ * ] -> Int -> *`
* `builtins.filter :: Eq a => (a -> Bool) -> [ a ] -> [ a ]`
* `builtins.foldl' :: (a -> a -> a) -> a -> [ a ]`
* `builtins.length :: [ * ] -> Int`



### Other
* `builtins.lessThan :: Eq a => a -> a -> Bool`

* `builtins.addErrorContext :: String -> a -> a`


baseNameOf




* `builtins.compareVersions :: String -> String -> Int`
* `builtins.splitVersion    :: String -> [ String ]`

* `builtins.concatLists :: [ [ * ] ] -> [ * ]`
```
nix-repl> builtins.concatLists [ [ "hi" ] [ 2 [3] ] [ 4 ] ]
[ "hi" 2 [ ... ] 4 ]
```

* `builtins.concatMap :: ([ * ] -> [ * ]) -> [ [ * ] ] -> [ * ]`

Transforms each inner list using the function (which takes in the inner list)

```
nix-repl> builtins.concatMap (x: ["blah"] ++ x ++ ["text"]) [ [ "hi" "hello" ] [ "status" ] ]
[ "blah" "hi" "hello" "text" "blah" "status" "text" ]
```

* `builtins.concatStringsSep`

* 

### Compositions

* `builtins.deepSeq`

### Derivations

* `builtins.derivation :: { Attr = *; } -> <<derivation>>`
* `builtins.derivationStrict :: ?? -> <<derivation>>`

* `builtins.dirOf :: Path -> Path`
Gets the parent directory of the input

### Operations on lists

### Fetching data

* `builtins.fetchGit`
* `builtins.fetchMercurial`
* `builtins.fetchTarball`
* `builtins.fetchurl`


* `builtins.filterSource :: (Path -> String -> Bool) -> !! -> String `
```
String value in the function (Path -> String -> Bool) must be:
"regular", "directory", "symlink" or "unknown"

!! Creates a directory at the return value with the contents filtered by the predicate function
```

* `builtins.findFile :: [ { path = String; } ] -> String -> ??`


### File parsers

* `builtins.fromJSON :: String -> { Attr = *; }`
* `builtins.fromTOML :: String -> { Attr = *; }`

* `builtins.functionArgs :: {a*** -> *} -> { a = Bool; }`

* `builtins.genList :: (Int -> Int) -> Int -> [ Int ]`
* `builtins.genericClosure :: Eq a => { startSet = [ { key = a; } ]; operator = (* -> [ { key = a; } ]) } -> [ { key = a; } ]`

"it takes a "startSet" (a list of initial graph nodes) and a "operator" function that must return nodes reachable from a node
nodes are represented as attribute sets with a "key" attribute
so "key" could be the package name in this case
any other attributes are passed through"

```
nix-repl> builtins.genericClosure {startSet=[{key=2;}]; operator=(x: [{key=3;}]);} 
[ { ... } { ... } ]

nix-repl> z = builtins.genericClosure {startSet=[{key=2;}]; operator=(x: [{key=3;}]);}  

nix-repl> builtins.head z
{ key = 2; }

nix-repl> builtins.head z
{ key = 2; }

nix-repl> builtins.head builtins.tail z
error: value is the built-in function 'tail' while a list was expected, at (string):1:1

nix-repl> builtins.head (builtins.tail z)
{ key = 3; }
```

TODO: Check this function - I'm not sure if it should be `(* -> [ ... ])`

* `builtins.intersectAttrs :: { Attr = *; } -> { Attr = *; } -> { Attr = *; }`

* `builtins.getEnv :: String -> String`

* `builtins.hasContext :: String -> Bool`
No idea what this does

* `builtins.hashString :: String -> String -> String
* `builtins.head :: [ a ] -> a
* `builtins.import :: ?? -> {} -> ??

* `builtins.isAttrs    :: * -> Bool`
* `builtins.isBool     :: * -> Bool`
* `builtins.isFloat    :: * -> Bool`
* `builtins.isFunction :: * -> Bool`
* `builtins.isInt      :: * -> Bool`
* `builtins.isList     :: * -> Bool`
* `builtins.isNull     :: * -> Bool`
* `builtins.isString   :: * -> Bool`

* `builtins.listToAttrs :: [ { name = String; value = *; } ] -> { Attrs -> * }` 
* `builtins.map :: (a -> b) -> [ a ] -> [ b ]`
* `builtins.mapAttrs :: (a -> b -> *) -> { a = b; } -> { a = *; }`
```
nix-repl> builtins.mapAttrs (x: y: "blah") { hello = 5;}
{ hello = "blah"; }
```

* `builtins.match :: String -> String -> [ String ]|null`
* `builtins.parseDrvName :: String -> { name = String; version = String; }`
* `builtins.partition :: (* -> Bool) -> [ * ] -> { right = [ * ]; wrong = [ * ]}`
* `builtins.path :: { path = Path; } -> !! -> String`
Moves that directory specified by the path into the nix store
* `builtins.pathExists :: Path -> Bool`
* `builtins.placeholder :: String -> String`

* `builtins.readDir :: Path -> { String = String; }`
* `builtins.readFile :: Path -> String`
* `builtins.removeAttrs :: { Attr = *; } -> [ String ] -> { Attr = *; }`
* `builtins.replaceStrings :: [ String ] -> [ String ] -> String -> String`
* `builtins.scopedImport :: { Attr = *; } -> Path -> <<derivation>>`
* `builtins.seq :: * -> * -> *`
* `builtins.sort :: Eq a => (a -> a -> Bool) -> [ a ] -> [ a ]`
* `builtins.split :: String -> String -> [ String|[ String ] ]`
* `builtins.splitVersion :: String -> [ String ]`
* `builtins.storePath :: Path -> String`
Gives you the path of a thing in the nix store. The input path must be in the nix store
* `builtins.stringLength :: String -> Int`
* `builtins.substring :: Int -> Int -> String -> String`
* `builtins.tail :: [ * ] -> [ * ] `
* `builtins.throw :: String -> !!`

* `builtins.toFile`
* `builtins.toJSON :: * -> String`
* `builtins.toPath :: String -> Path`
* `builtins.toString :: * -> String`
* `builtins.toXML`

* `builtins.trace :: a -> b -> !! -> b`
* `builtins.true :: Bool`
* `builtins.tryEval :: * -> { success = Bool; value = *; }`
* `builtins.typeOf :: * -> String`
* `builtins.unsafeDiscardOutputDependency :: String -> String`
* `builtins.unsafeDiscardStringContext :: String -> String`
* `builtins.unsafeGetAttrPos :: String -> { Attr = *; } -> { column = Int; file = String; line = Int }`
* `builtins.valueSize :: * -> Int`
