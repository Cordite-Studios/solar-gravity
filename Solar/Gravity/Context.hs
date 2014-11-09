{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE Rank2Types #-}
{-# OPTIONS_HADDOCK show-extensions #-}

module Solar.Gravity.Context where

import Solar.Orbit.Types
-- import Solar.Orbit.OrbiterF
import qualified  Data.Sequence   as S
import qualified  Data.Map.Strict as M
import qualified  Data.ByteString as B
import            Data.Typeable
import            Data.Generics

-- | Modes of operation that may allow or restrict certain actions
-- or instructs the Orbiter to behave in a certain mode if it supports
-- multiple modes.
data OperatingContext
  = ReadingShared
  -- ^ Reads through files at its own pace
  | WritingExclusive
  -- ^ This Orbiter has exclusive write ability
  | WritingShared
  -- ^ This Orbiter does not have exclusive write access, act accordingly
  | SoloExclusive
  -- ^ This Orbiter has exclusive access to its logs
  | ConsumingLinear
  -- ^ This Orbiter consumes at its own pace
  | ConsumingShared
  -- ^ This Orbiter may load balance what it consumes with other orbiters.
  | ProducerExclusive
  -- ^ This Orbiter's purpose is to produce, do little reading,
  -- and has exclusive writing
  | ProducerShared
  -- ^ This Orbiter's purpose is to produce, do little reading,
  -- has shared writing, act accordingly
  deriving(Show, Eq, Enum, Typeable, Data)

data PhysicalContext = PhysicalContext
  { physicalMachine :: B.ByteString
  , physicalPort    :: Int
  }
  deriving(Show, Eq, Typeable, Data)

-- | A typeclass for contexts within the Gravity implementation
class GravityContext a where
  -- | Gets the namespace for the things it can access
  logicalNamespace :: a -> OrbiterLogName

  -- | Gets the partitioned namespace that it is safe to use without
  --  contention (particularly important in multi-write contexts)
  logicalPartition :: a -> OrbiterLogName

  -- | Gets the operating context that an orbiter operates at
  operating :: a -> OperatingContext
  -- | Gets the physical context for where this orbiter is located
  physical :: a -> PhysicalContext
