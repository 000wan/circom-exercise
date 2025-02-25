const fs = require("fs");
const solidityRegex = /pragma solidity \^\d+\.\d+\.\d+/

const groth16VerifierRegex = /contract Groth16Verifier/

let content = fs.readFileSync("./contracts/SystemOfEquationsVerifier.sol", { encoding: 'utf-8' });
let bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0');
bumped = bumped.replace(groth16VerifierRegex, 'contract SystemOfEquationsVerifier');

fs.writeFileSync("./contracts/SystemOfEquationsVerifier.sol", bumped);