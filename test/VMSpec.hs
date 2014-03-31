module VMSpec where

import Test.Hspec

import VM

spec :: Spec
spec = do
        describe "runVM" $ do
            context "with normalInstructions" $ do
                it "runs" $ do
                    takeResult (runVM normalInstructions) `shouldBe` 3

-- test instructions for:
--   a = 3 + 4
--   b = a + 3
--   b - a
normalInstructions :: [Instruction]
normalInstructions = [ Push 3
                     , Push 4
                     , Add
                     , Store 0
                     , Load 0
                     , Push 3
                     , Add
                     , Store 1
                     , Load 1
                     , Load 0
                     , Sub ]