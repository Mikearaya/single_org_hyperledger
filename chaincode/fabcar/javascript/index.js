/*
 * SPDX-License-Identifier: Apache-2.0
 */

"use strict";

const FabCar = require("./lib/fabcar");
const TestChain = require("./lib/testchainCode");

module.exports.FabCar = FabCar;
module.exports.TestChain = TestChain;
module.exports.contracts = [FabCar, TestChain];
