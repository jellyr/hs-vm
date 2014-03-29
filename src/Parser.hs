module Parser
    ( parse
    , instructions ) where

import Control.Applicative ((<$>), (<$))
import Data.Maybe (catMaybes)
import Text.ParserCombinators.Parsec
import VM.Instruction

instructions :: Parser [Instruction]
instructions = catMaybes <$> (comment <|> instruction) `sepBy` many1 newline

instruction :: Parser (Maybe Instruction)
instruction = Just <$> (choice $ try <$> [add, sub, store, read', push])

add :: Parser Instruction
add = Add <$ string "Add"

sub :: Parser Instruction
sub = Sub <$ string "Sub"

store :: Parser Instruction
store = Store <$> instWithNumber "Store"

read' :: Parser Instruction
read' = Read <$> instWithNumber "Read"

push :: Parser Instruction
push = Push <$> instWithNumber "Push"

instWithNumber :: String ->  Parser Integer
instWithNumber s = read <$> (string s >> spaces >> many1 digit)

comment :: Parser (Maybe Instruction)
comment = char '#' >> many (noneOf "\n") >> return Nothing