{-# LANGUAGE OverloadedStrings #-}
module ADL.Adlc.Config.Haskell(
    HaskellCustomType(..),
    UnionConstructor(..),
) where

import ADL.Core
import Control.Applicative( (<$>), (<*>), (<|>) )
import qualified Data.Aeson as JS
import qualified Data.HashMap.Strict as HM
import qualified Data.Proxy
import qualified Data.Text as T
import qualified Prelude

data HaskellCustomType = HaskellCustomType
    { haskellCustomType_haskellname :: T.Text
    , haskellCustomType_haskellimports :: [T.Text]
    , haskellCustomType_insertCode :: [T.Text]
    , haskellCustomType_generateOrigADLType :: T.Text
    , haskellCustomType_structConstructor :: T.Text
    , haskellCustomType_unionConstructors :: [UnionConstructor]
    }
    deriving (Prelude.Eq,Prelude.Ord,Prelude.Show)

instance AdlValue HaskellCustomType where
    atype _ = "adlc.config.haskell.HaskellCustomType"
    
    defaultv = HaskellCustomType
        defaultv
        defaultv
        defaultv
        ""
        ""
        [  ]
    
    jsonGen = genObject
        [ genField "haskellname" haskellCustomType_haskellname
        , genField "haskellimports" haskellCustomType_haskellimports
        , genField "insertCode" haskellCustomType_insertCode
        , genField "generateOrigADLType" haskellCustomType_generateOrigADLType
        , genField "structConstructor" haskellCustomType_structConstructor
        , genField "unionConstructors" haskellCustomType_unionConstructors
        ]
    
    jsonParser = HaskellCustomType
        <$> parseField "haskellname"
        <*> parseField "haskellimports"
        <*> parseField "insertCode"
        <*> parseFieldDef "generateOrigADLType" ""
        <*> parseFieldDef "structConstructor" ""
        <*> parseFieldDef "unionConstructors" [  ]

data UnionConstructor = UnionConstructor
    { unionConstructor_fieldName :: T.Text
    , unionConstructor_constructor :: T.Text
    }
    deriving (Prelude.Eq,Prelude.Ord,Prelude.Show)

instance AdlValue UnionConstructor where
    atype _ = "adlc.config.haskell.UnionConstructor"
    
    defaultv = UnionConstructor
        defaultv
        defaultv
    
    jsonGen = genObject
        [ genField "fieldName" unionConstructor_fieldName
        , genField "constructor" unionConstructor_constructor
        ]
    
    jsonParser = UnionConstructor
        <$> parseField "fieldName"
        <*> parseField "constructor"