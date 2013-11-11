{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}
module ADL.Core.Primitives (
  -- export only class instances
  ) where

import qualified Data.Aeson as JSON
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import qualified Data.Vector as V
import qualified Data.ByteString as B
import qualified Data.ByteString.Base64 as B64
import Data.Int
import Data.Word
import GHC.Float

import Data.Attoparsec.Number

import ADL.Core.Value

instance JSONSerialisable () where
  jsonSerialiser jf = JSONSerialiser to from
    where
      to _ = JSON.Null
      from JSON.Null = Just ()
      from _ = Nothing

instance ADLValue () where
  atype _ = "void"
  defaultv = ()

instance JSONSerialisable Bool where
  jsonSerialiser jf = JSONSerialiser to from
    where
      to v = JSON.Bool v
      from (JSON.Bool v) = Just v
      from _ = Nothing
  
instance ADLValue Bool where
  atype _ = "bool"
  defaultv = False


iToJSON :: Integral a => a -> JSON.Value
iToJSON v = JSON.Number (I (fromIntegral v))

iFromJSON :: Num a => JSON.Value -> Maybe a
iFromJSON (JSON.Number (I v)) = Just (fromIntegral v)
iFromJSON _ = Nothing

instance JSONSerialisable Int8 where
  jsonSerialiser jf = JSONSerialiser iToJSON iFromJSON
  
instance ADLValue Int8 where
  atype _ = "int8"
  defaultv = 0

instance JSONSerialisable Int16 where
  jsonSerialiser jf = JSONSerialiser iToJSON iFromJSON

instance ADLValue Int16 where
  atype _ = "int16"
  defaultv = 0

instance JSONSerialisable Int32 where
  jsonSerialiser jf = JSONSerialiser iToJSON iFromJSON

instance ADLValue Int32 where
  atype _ = "int32"
  defaultv = 0

instance JSONSerialisable Int64 where
  jsonSerialiser jf = JSONSerialiser iToJSON iFromJSON

instance ADLValue Int64 where
  atype _ = "int64"
  defaultv = 0

instance JSONSerialisable Word8 where
  jsonSerialiser jf = JSONSerialiser iToJSON iFromJSON

instance ADLValue Word8 where
  atype _ = "word8"
  defaultv = 0

instance JSONSerialisable Word16 where
  jsonSerialiser jf = JSONSerialiser iToJSON iFromJSON

instance ADLValue Word16 where
  atype _ = "word16"
  defaultv = 0

instance JSONSerialisable Word32 where
  jsonSerialiser jf = JSONSerialiser iToJSON iFromJSON

instance ADLValue Word32 where
  atype _ = "word32"
  defaultv = 0

instance JSONSerialisable Word64 where
  jsonSerialiser jf = JSONSerialiser iToJSON iFromJSON

instance ADLValue Word64 where
  atype _ = "word64"
  defaultv = 0

instance JSONSerialisable Double where
  jsonSerialiser jf = JSONSerialiser to from
    where
      to v = JSON.Number (D v)
      from (JSON.Number (D v)) = Just v
      from  _ = Nothing
      
instance ADLValue Double where
  atype _ = "double"
  defaultv = 0

instance JSONSerialisable Float where
  jsonSerialiser jf = JSONSerialiser to from
    where
      to v = JSON.Number (D (float2Double v))
      from (JSON.Number (D v)) = Just (double2Float v)
      from  _ = Nothing

instance ADLValue Float where
  atype _ = "float"
  defaultv = 0

instance JSONSerialisable T.Text where
  jsonSerialiser jf = JSONSerialiser to from
    where
      to v = JSON.String v
      from (JSON.String v) = Just v
      from  _ = Nothing

instance ADLValue T.Text where
  atype _ = "string"
  defaultv = T.empty

instance JSONSerialisable B.ByteString where
  jsonSerialiser jf = JSONSerialiser to from
    where
      to v = JSON.String (T.decodeUtf8 (B64.encode v))
      from (JSON.String v) = case B64.decode (T.encodeUtf8 v) of
        (Left _) -> Nothing
        (Right v1) -> Just v1 
      from  _ = Nothing

instance ADLValue B.ByteString where
  atype _ = "bytes"
  defaultv = B.empty

instance (JSONSerialisable a) => JSONSerialisable [a] where
  jsonSerialiser jf = JSONSerialiser to from
    where
      js = jsonSerialiser jf
      to vs = JSON.Array (V.fromList (map (aToJSON js) vs))
      from (JSON.Array v) = mapM (aFromJSON js) (V.toList v)
      from _ = Nothing
  

instance forall a . (ADLValue a) => ADLValue [a] where
  atype _ = T.concat ["vector<",atype (undefined :: a),">"]
  defaultv = []




