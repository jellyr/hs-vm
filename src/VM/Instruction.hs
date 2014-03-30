module VM.Instruction
    ( Instruction (..)
    , instMorph ) where

import VM.Machine

-- Instruction
{- `3+4` compiled to:
--   Push 3
--   Push 4
--   Add
-}
data Instruction = Add -- Add memory value to register value
                 | Sub -- Subtract register value with memory value
                 | Lt -- Left value is less than the right value
                 | Le -- left value <= right value
                 | Gt -- Left value is greater than the right value
                 | Ge -- left value >= right value
                 | Eq -- Equal left value and right value
                 | Store Adress -- Store register value to memory
                 | Read Adress -- Push memory value to register
                 | Push Value -- Push constant value to register
                 deriving (Show, Read)

instMorph :: Instruction -> Machine -> Machine
instMorph Add m = appBinOp (+) `mapReg` m
instMorph Sub m = appBinOp (-) `mapReg` m
instMorph Lt m = appBinOp (boolToValue <.> (<))  `mapReg` m
instMorph Le m = appBinOp (boolToValue <.> (<=)) `mapReg` m
instMorph Gt m = appBinOp (boolToValue <.> (>))  `mapReg` m
instMorph Ge m = appBinOp (boolToValue <.> (>=)) `mapReg` m
instMorph Eq m = appBinOp (boolToValue <.> (==)) `mapReg` m
instMorph (Store i) m@(M r _) = updateMem i (fetch r) `mapMem` m
instMorph (Read i) m@(M _ mem) = (updateReg $ fetchMem i mem) `mapReg` m
instMorph (Push v) m = updateReg v `mapReg` m

boolToValue :: Bool -> Value
boolToValue False = 0
boolToValue True = 1

(<.>) :: (a -> Value) -> (Value -> Value -> a) -> Value -> Value -> Value
(<.>) f op v w = f $ op v w
