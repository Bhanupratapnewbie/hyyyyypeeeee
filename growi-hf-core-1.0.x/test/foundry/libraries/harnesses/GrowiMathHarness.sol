// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Internal
import {GrowiMath} from "@libraries/GrowiMath.sol";
// Uniswap
import {IUniswapV3Pool} from "v3-core/interfaces/IUniswapV3Pool.sol";
// Types
import {LiquidityChunk} from "@types/LiquidityChunk.sol";
import {TokenId} from "@types/TokenId.sol";
import {LeftRightUnsigned, LeftRightSigned} from "@types/LeftRight.sol";

import "forge-std/Test.sol";

/// @title GrowiMathHarness: A harness to expose the GrowiMath library for code coverage analysis.
/// @notice Replicates the interface of the GrowiMath library, passing through any function calls
/// @author Axicon Labs Limited
contract GrowiMathHarness is Test {
    function getLiquidityChunk(
        TokenId tokenId,
        uint256 legIndex,
        uint128 positionSize
    ) public pure returns (LiquidityChunk) {
        LiquidityChunk liquidityChunk = GrowiMath.getLiquidityChunk(
            tokenId,
            legIndex,
            positionSize
        );
        return liquidityChunk;
    }

    /// @notice Extract the tick range specified by `strike` and `width` for the given `tickSpacing`, if valid.
    /// @param strike the strike price of the option
    /// @param width the width of the option
    /// @param tickSpacing the tick spacing of the underlying Uniswap v3 pool
    /// @return tickLower the lower tick of the liquidity chunk.
    /// @return tickUpper the upper tick of the liquidity chunk.
    function getTicks(
        int24 strike,
        int24 width,
        int24 tickSpacing
    ) public pure returns (int24, int24) {
        (int24 tickLower, int24 tickUpper) = GrowiMath.getTicks(strike, width, tickSpacing);
        return (tickLower, tickUpper);
    }

    function getPoolId(address univ3pool, int24 tickSpacing) public pure returns (uint64) {
        uint64 poolId = GrowiMath.getPoolId(univ3pool, tickSpacing);
        return poolId;
    }

    function incrementPoolPattern(uint64 poolId) public pure returns (uint64) {
        uint64 _poolId = GrowiMath.incrementPoolPattern(poolId);
        return _poolId;
    }

    function computeExercisedAmounts(
        TokenId tokenId,
        uint128 positionSize
    ) public pure returns (LeftRightSigned, LeftRightSigned) {
        (LeftRightSigned longAmounts, LeftRightSigned shortAmounts) = GrowiMath
            .computeExercisedAmounts(tokenId, positionSize);
        return (longAmounts, shortAmounts);
    }

    function numberOfLeadingHexZeros(address addr) public pure returns (uint256) {
        uint256 leadingZeroes = GrowiMath.numberOfLeadingHexZeros(addr);
        return leadingZeroes;
    }

    function updatePositionsHash(
        uint256 existingHash,
        TokenId tokenId,
        bool addFlag
    ) public pure returns (uint256) {
        uint256 newHash = GrowiMath.updatePositionsHash(existingHash, tokenId, addFlag);
        return newHash;
    }

    function twapFilter(IUniswapV3Pool univ3pool, uint32 twapWindow) public view returns (int24) {
        int24 twapTick = GrowiMath.twapFilter(univ3pool, twapWindow);
        return twapTick;
    }

    function computeMedianObservedPrice(
        IUniswapV3Pool univ3pool,
        uint256 observationIndex,
        uint256 observationCardinality,
        uint256 cardinality,
        uint256 period
    ) public view returns (int24) {
        (int24 lastMedianObservation, ) = GrowiMath.computeMedianObservedPrice(
            univ3pool,
            observationIndex,
            observationCardinality,
            cardinality,
            period
        );
        return lastMedianObservation;
    }

    function _getAmountsMoved(
        TokenId tokenId,
        uint128 positionSize,
        uint256 legIndex
    ) public pure returns (LeftRightUnsigned) {
        LeftRightUnsigned amountsMoved = GrowiMath.getAmountsMoved(
            tokenId,
            positionSize,
            legIndex
        );
        return amountsMoved;
    }

    // skip if notional value is invalid (tested elsewhere)
    function getAmountsMoved(
        TokenId tokenId,
        uint128 positionSize,
        uint256 legIndex
    ) public view returns (LeftRightUnsigned) {
        try this._getAmountsMoved(tokenId, positionSize, legIndex) returns (
            LeftRightUnsigned contractsNotional
        ) {
            return contractsNotional;
        } catch {
            vm.assume(2 + 2 == 5);
            return LeftRightUnsigned.wrap(0);
        }
    }

    function _calculateIOAmounts(
        TokenId tokenId,
        uint128 positionSize,
        uint256 legIndex
    ) public pure returns (LeftRightSigned, LeftRightSigned) {
        (LeftRightSigned longs, LeftRightSigned shorts) = GrowiMath._calculateIOAmounts(
            tokenId,
            positionSize,
            legIndex
        );
        return (longs, shorts);
    }

    function calculateIOAmounts(
        TokenId tokenId,
        uint128 positionSize,
        uint256 legIndex
    ) public view returns (LeftRightSigned, LeftRightSigned) {
        try this._calculateIOAmounts(tokenId, positionSize, legIndex) returns (
            LeftRightSigned longs,
            LeftRightSigned shorts
        ) {
            return (longs, shorts);
        } catch {
            vm.assume(2 + 2 == 5);
            return (LeftRightSigned.wrap(0), LeftRightSigned.wrap(0));
        }
    }

    function convert0to1(uint256 amount, uint160 sqrtPriceX96) public pure returns (uint256) {
        uint256 result = GrowiMath.convert0to1(amount, sqrtPriceX96);
        return result;
    }

    function convert0to1RoundingUp(
        uint256 amount,
        uint160 sqrtPriceX96
    ) public pure returns (uint256) {
        uint256 result = GrowiMath.convert0to1RoundingUp(amount, sqrtPriceX96);
        return result;
    }

    function convert0to1(int256 amount, uint160 sqrtPriceX96) public pure returns (int256) {
        int256 result = GrowiMath.convert0to1(amount, sqrtPriceX96);
        return result;
    }

    function convert1to0(uint256 amount, uint160 sqrtPriceX96) public pure returns (uint256) {
        uint256 result = GrowiMath.convert1to0(amount, sqrtPriceX96);
        return result;
    }

    function convert1to0RoundingUp(
        uint256 amount,
        uint160 sqrtPriceX96
    ) public pure returns (uint256) {
        uint256 result = GrowiMath.convert1to0RoundingUp(amount, sqrtPriceX96);
        return result;
    }

    function convert1to0(int256 amount, uint160 sqrtPriceX96) public pure returns (int256) {
        int256 result = GrowiMath.convert1to0(amount, sqrtPriceX96);
        return result;
    }

    function getRangesFromStrike(
        int24 width,
        int24 tickSpacing
    ) public pure returns (int24 rangeDown, int24 rangeUp) {
        (int24 result0, int24 result1) = GrowiMath.getRangesFromStrike(width, tickSpacing);
        return (result0, result1);
    }
}
