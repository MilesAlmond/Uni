

-------------------------
-------- PART A --------- 
-------------------------

type Var = String

data Term =
    Variable Var
  | Lambda   Var  Term
  | Apply    Term Term
  --deriving Show

instance Show Term where
  show = pretty

example :: Term
example = Lambda "a" (Lambda "x" (Apply (Apply (Lambda "y" (Apply (Variable "a") (Variable "c"))) (Variable "x")) (Variable "b")))

pretty :: Term -> String
pretty = f 0
    where
      f i (Variable x) = x
      f i (Lambda x m) = if i /= 0 then "(" ++ s ++ ")" else s where s = "\\" ++ x ++ ". " ++ f 0 m 
      f i (Apply  n m) = if i == 2 then "(" ++ s ++ ")" else s where s = f 1 n ++ " " ++ f 2 m


------------------------- Assignment 1

numeral' :: Int -> Term
numeral' 0 = Variable "x"
numeral' i = (Apply (Variable "f") (numeral' (i-1)))

numeral :: Int -> Term
numeral 0 = Lambda "f" (Lambda "x" (Variable "x"))
numeral i = Lambda "f" (Lambda "x" (Apply (Variable "f") (numeral' (i-1))))


-------------------------

merge :: Ord a => [a] -> [a] -> [a]
merge xs [] = xs
merge [] ys = ys
merge (x:xs) (y:ys)
    | x == y    = x : merge xs ys
    | x <= y    = x : merge xs (y:ys)
    | otherwise = y : merge (x:xs) ys


------------------------- Assignment 2

variables' :: Int -> [Var]
variables' 0 = undefined

variables :: [Var]
variables = map (:[]) ['a'..'z'] ++ [x : show i | i <- [1..] , x <- ['a'..'z'] ]

filterVariables :: [Var] -> [Var] -> [Var]
filterVariables xs [] = xs
filterVariables xs (y:ys) = filter (/=y) (filterVariables xs ys)

fresh :: [Var] -> Var
fresh xs = (filterVariables variables xs) !! 0

used :: Term -> [Var]
used (Variable x) = [x]
used (Lambda x n) = merge [x] (used n)
used (Apply n m) = merge (used n) (used m)


------------------------- Assignment 3

rename :: Var -> Var -> Term -> Term
rename x y (Variable z)
    | x == z = Variable y
    | otherwise = Variable z

rename x y (Lambda z n)
    | x == z = (Lambda z n)
    | otherwise = (Lambda z (rename x y n))

rename x y (Apply  n m) = (Apply (rename x y n) (rename x y m))


substitute :: Var -> Term -> Term -> Term
substitute x n (Variable y)
    | x == y = n
    | otherwise = (Variable y)

substitute x n (Lambda y m)
    | x == y = (Lambda y m)
    | otherwise = (Lambda (z) (substitute x n (rename y z m)))
        where z = fresh (merge (used m) (used n))

substitute x n (Apply m1 m2) = (Apply (substitute x n m1) (substitute x n m2)) 


------------------------- Assignment 4

beta :: Term -> [Term]
beta (Apply (Lambda x n) m) =
    [substitute x m n] 
    ++ [Apply (Lambda x n') m | n' <- beta n]
    ++ [Apply (Lambda x n) m' | m' <- beta m]

beta (Apply n m) =
    [Apply n' m | n' <- beta n]
    ++ [Apply n m' | m' <- beta m]

beta (Lambda x n) = [Lambda x n' | n' <- beta n]

beta (Variable _) = []

normalize :: Term -> Term
normalize n
    | null ns = n
    | otherwise = normalize (head ns)
        where ns = beta n

run :: Term -> IO ()
run n = do
    print n
    let ns = beta n
    if null ns then 
        return()
    else 
        run (head ns)

 
-------------------------

suc    = Lambda "n" (Lambda "f" (Lambda "x" (Apply (Variable "f") (Apply (Apply (Variable "n") (Variable "f")) (Variable "x")))))
add    = Lambda "m" (Lambda "n" (Lambda "f" (Lambda "x" (Apply (Apply (Variable "m") (Variable "f")) (Apply (Apply (Variable "n") (Variable "f")) (Variable "x"))))))
mul    = Lambda "m" (Lambda "n" (Lambda "f" (Lambda "x" (Apply (Apply (Variable "m") (Apply (Variable "n") (Variable "f"))) (Variable "x")))))
dec    = Lambda "n" (Lambda "f" (Lambda "x" (Apply (Apply (Apply (Variable "n") (Lambda "g" (Lambda "h" (Apply (Variable "h") (Apply (Variable "g") (Variable "f")))))) (Lambda "u" (Variable "x"))) (Lambda "x" (Variable "x")))))
minus  = Lambda "n" (Lambda "m" (Apply (Apply (Variable "m") dec) (Variable "n")))

-------------------------
-------- PART B --------- 
-------------------------

------------------------- Assignment 5

free :: Term -> [Var]
free (Variable x) = [x]
free (Lambda x n) = filter (/=x) (free n)
free (Apply  n m) = merge (free n) (free m)

abstractions :: Term -> [Var] -> Term
abstractions n [] =     n
abstractions n (x:xs) = Lambda x (abstractions n xs)

applications :: Term -> [Term] -> Term
applications n [] =     n
applications n (x:xs) = applications (Apply n x) xs

lift :: Term -> Term
lift n = applications (abstractions n (free n)) [Variable x | x <- free n]

super :: Term -> Term
super (Lambda a b) =  lift (Lambda a (findN b))
    where findN (Variable x) = super (Variable x)
          findN (Apply n m) = super (Apply n m)
          findN (Lambda a b) = (Lambda a (findN b))

super (Apply n m) =   Apply (super n) (super m)
super (Variable x) =  Variable x


------------------------- Assignment 6

data Expr = 
    V Var
  | A Expr Expr

toTerm :: Expr -> Term
toTerm (V n) =   Variable n
toTerm (A n m) = Apply (toTerm n) (toTerm m)

instance Show Expr where
  show = show . toTerm

type Inst = ([Char],[Var],Expr)

data Prog = Prog [Inst]


instance Show Prog where
  show (Prog ls) = unlines (map showInst ks)
    where
      ks = map showParts ls
      n  = maximum (map (length . fst) ks)
      showParts (x,xs,e) = (x ++ " " ++ unwords xs , show e)
      showInst (s,t) = take n (s ++ repeat ' ') ++ " = " ++ t


names = ['$':show i | i <- [1..] ]

-------------------------

stripAbs :: Term -> ([Var],Term)
stripAbs (Variable x) =  ([], Variable x)
stripAbs (Apply n m) =   ([], Apply n m)
stripAbs (Lambda n xs) = (stripLambda (Lambda n xs),snd (stripAbs xs))
    where stripLambda (Variable x) = []
          stripLambda (Apply n m) = []
          stripLambda (Lambda n xs) = [n] ++ stripLambda xs

takeAbs :: Term -> [Term]
takeAbs (Variable x) =  []
takeAbs (Lambda n xs) = [Lambda n xs]
takeAbs (Apply n m) =   takeAbs n ++ takeAbs m

termIsEmpty :: [Term] -> Bool
termIsEmpty [] = True
termIsEmpty x =  False

termIsApply :: Term -> Bool
termIsApply (Apply n m) = True
termIsApply x =           False
    
toExpr :: [Var] -> Term -> Expr
toExpr _ (Variable y) =      V y
toExpr (x:xs) (Lambda a b) = V x
toExpr (x:xs) (Apply n m)
    | termIsApply n =           A (toExpr (x:xs) n) (toExpr (drop (length (takeAbs n)) (x:xs)) m)
    | termIsApply m =           A (toExpr (drop (length (takeAbs m)) (x:xs)) n) (toExpr (x:xs) m)
    | termIsEmpty (takeAbs n) = A (toExpr [] n) (toExpr (x:xs) m)
    | termIsEmpty (takeAbs m) = A (toExpr (x:xs) n) (toExpr [] m)
    | otherwise =               A (V x) (toExpr xs m)

toInst :: [Var] -> (Var,Term) -> (Inst,[(Var,Term)],[Var])
toInst (x:xs) (a,b) = ((a,fst(stripAbs b),toExpr (x:xs) (snd(stripAbs b))),
                      zip (x:xs) (takeAbs(snd(stripAbs b))),
                      drop (length (takeAbs(snd(stripAbs b)))) (x:xs))

first (x,_,_) = x
second (_,x,_) = x
third (_,_,x) = x

prog :: Term -> Prog
prog n = Prog (aux (names) [("$main",super n)])
  where
    aux :: [Var] -> [(Var,Term)] -> [Inst]
    aux [] (y:ys) =      []
    aux (x:xs) [] =      []
    aux (x:xs) (y:ys) =  [first (toInst (x:xs) y)] ++ aux (x:xs) ys ++ (aux (third (toInst (x:xs) y)) (second (toInst (x:xs) y)))

example2 = Apply (Variable "S") (Apply (Apply example (numeral 0)) (Variable "0"))
example3 = Apply (Apply add (numeral 1)) (Apply (Apply mul (numeral 2)) (numeral 3))
example4 = Apply (Apply example3 (Variable "S")) (Variable "0")

------------------------- Assignment 7

sub :: [(Var,Expr)] -> Expr -> Expr
sub [] n =           n
sub (x:xs) (V m)
    | m == (fst x) = (snd x)
    | otherwise =    sub xs (V m) 
sub (x:xs) (A n m) = A (sub (x:xs) n) (sub (x:xs) m)

findCharacter :: Char -> String -> Bool
findCharacter x [] = False
findCharacter x (y:ys)
    | x == y =       True
    | otherwise =    findCharacter x ys
    
trueLength :: Expr -> Int
trueLength (V x) =   1
trueLength (A n m) = (trueLength n) + (trueLength m)

removeLastN :: Int -> [Expr] -> [Expr]
removeLastN 0 (x:xs) = (x:xs)
removeLastN n (x:xs)
    | (length xs) == n = [x]
    | otherwise = x : (removeLastN n xs)

newSub :: Expr -> [Expr] -> Expr
newSub x [] =           x
newSub (V x) (y:ys) =   y
newSub (A n m) (y:ys) = A (newSub n (y:ys)) (newSub m (drop (trueLength n) (y:ys)))

step :: [Inst] -> [Expr] -> IO [Expr]

step (x:xs) ((V y):ys)   = do
 
                           if findCharacter '$' y == True
                           then do
                              let zs = [(a,c) | (a,_,c) <- (x:xs)]
                              let ws = sub zs (V y)
                              let n = drop ((trueLength ws) + 1) ys
                              let p = take (trueLength ws) (ys)
                              return ([newSub ws p] ++ n)
                              
                           else do
                              putStr y
                              putStr " "
                              return ys  
                              
step (x:xs) ((A n m):ys) = do

                           return ([n,m] ++ ys)
  
  
exprIsEmpty :: [Expr] -> Bool
exprIsEmpty [] = True
exprIsEmpty x =  False
                           
                           
stepCharOnly :: [Inst] -> [Expr] -> IO ()

stepCharOnly (x:xs) [] =           return ()

stepCharOnly (x:xs) ((V y):ys)   =  do
                                    if exprIsEmpty ys && (findCharacter '$' y == False)
                                    then do
                                        putStr y
                                        putStr "\n"
                                    else if findCharacter '$' y == True
                                    then do
                                        let zs = [(a,c) | (a,_,c) <- (x:xs)]
                                        let ws = sub zs (V y)
{- Decided to leave this error out      if ((trueLength ws) > (length ys))
   as my step function does not fully   then do
   work                                     putStr "*** Exception: step: insufficient arguments on stack \n"
                                        else do -}
                                        let n = drop ((trueLength ws) + 1) ys
                                        let p = take (trueLength ws) (ys)
                                        stepCharOnly (x:xs) ([newSub ws p] ++ n)
                                    else do
                                        putStr y
                                        putStr " "
                                        stepCharOnly (x:xs) ys
                           
                           
                          
stepCharOnly (x:xs) ((A n m):ys) = do
                                   stepCharOnly (x:xs) ([n,m] ++ ys)

                              
                           

supernormalize :: Term -> IO ()
supernormalize n = do 
                   let Prog p = prog n
                   stepCharOnly p [V "$main"]
